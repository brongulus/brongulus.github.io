+++
title = "2 Fast 2 MCM"
author = ["Tak"]
date = 2025-01-15T00:07:00+05:30
draft = false
+++

These visual representations helps understand the complex workflows within the Machine Controller Manager.

## Machine Controller Manager Architecture
- The system consists of three main controllers working in concert
- Each controller handles specific aspects of machine lifecycle management
- Interfaces with both cloud providers and Kubernetes clusters
- Manages the full lifecycle of machines from creation to deletion

Let's start with an overview of the main components and their interactions:

```mermaid
stateDiagram-v2
    direction TB
    
    state "Machine Controller Manager" as MCM {
        state "Machine Controller" as MC
        state "Safety Controller" as SC
        state "MCM Controller" as MCMC
        
        [*] --> MC
        [*] --> SC
        [*] --> MCMC
    }
    
    state "Cloud Provider" as CP {
        VMs
        API
    }
    
    state "Kubernetes Cluster" as K8S {
        state "Control Plane" as CP_K8S {
            API_Server
            etcd
        }
        
        state "Node Components" as NC {
            kubelet
            container_runtime
        }
    }
    
    MCM --> CP : Manages VMs
    MCM --> K8S : Manages Nodes
    
    note right of MCM
        Handles:
        - Machine lifecycle
        - Safety checks
        - Deployments/Sets
    end note
```

## Machine Controller Core Flows
Now, let's dive into the Machine Controller's core reconciliation flows for different resources. It handles three main types of reconciliation:
- Secret Reconciliation: Manages secrets referenced by MachineClasses
- MachineClass Reconciliation: Handles machine class lifecycle
- Machine Reconciliation: Core machine lifecycle management

```mermaid
stateDiagram-v2
    state "Machine Controller" as MC {
        state "Secret Reconciliation" as SR {
            [*] --> FetchSecret
            FetchSecret --> GetMachineClass
            GetMachineClass --> CheckReferences
            CheckReferences --> FinalizerAdd : Has References
            CheckReferences --> FinalizerRemove : No References
            FinalizerAdd --> [*]
            FinalizerRemove --> [*]
        }

        state "MachineClass Reconciliation" as MCR {
            [*] --> FetchClass
            FetchClass --> GetMachines
            GetMachines --> CheckMachines
            CheckMachines --> AddFinalizer : Has Machines
            CheckMachines --> RemoveFinalizer : No Machines
            AddFinalizer --> EnqueueMachines
            EnqueueMachines --> [*]
            RemoveFinalizer --> [*]
        }

        state "Machine Reconciliation" as MR {
            [*] --> FetchMachine
            FetchMachine --> CheckFrozen
            
            CheckFrozen --> ValidateMachine : Not Frozen
            CheckFrozen --> RetryLater : Frozen
            
            ValidateMachine --> DeletionFlow : Deletion Requested
            ValidateMachine --> AddFinalizers : No Deletion
            
            AddFinalizers --> CheckPhase
            
            CheckPhase --> ReconcileHealth : Has Node
            CheckPhase --> CreationFlow : No Node/Failed
            
            ReconcileHealth --> SyncNodeName
            SyncNodeName --> SyncTemplates
            SyncTemplates --> [*]
            
            CreationFlow --> [*]
            DeletionFlow --> [*]
        }
    }
```

### Machine Creation or Deletion
Machine Creation Flow:
- Complex process involving multiple status checks
- Handles initialization and error cases
- Includes node verification and cleanup of stale resources
- Multiple retry mechanisms for resilience

Machine Deletion Flow:
- Carefully orchestrated process to ensure clean resource cleanup
- Involves multiple phases from drain to final cleanup
- Handles volume attachments and node cleanup
- Includes finalizer management for resource protection

```mermaid
stateDiagram-v2
    state "Creation Flow" as CF {
        [*] --> UpdateMachineRequest
        UpdateMachineRequest --> GetMachineStatus
        
        GetMachineStatus --> UpdateNodeLabels : Success
        GetMachineStatus --> CreateMachine : NotFound
        GetMachineStatus --> HandleError : Other Errors
        
        CreateMachine --> CheckNodeExists
        CheckNodeExists --> DeleteMachine : Stale Node
        CheckNodeExists --> StatusUpdate : No Node
        
        DeleteMachine --> MarkFailed
        StatusUpdate --> InitializeMachine : Success
        InitializeMachine --> Requeue
        
        HandleError --> MarkFailed : Timeout
        MarkFailed --> [*]
        Requeue --> [*]
    }

    state "Deletion Flow" as DF {
        [*] --> CheckFinalizers
        CheckFinalizers --> SetTerminating
        SetTerminating --> ProcessPhase
        
        state "ProcessPhase" as PP {
            [*] --> GetVMStatus
            GetVMStatus --> InitiateDrain
            InitiateDrain --> DeleteVolumeAttachments
            DeleteVolumeAttachments --> InitiateVMDeletion
            InitiateVMDeletion --> InitiateNodeDeletion
            InitiateNodeDeletion --> RemoveFinalizers
            RemoveFinalizers --> [*]
        }
        
        ProcessPhase --> UpdateStatus
        UpdateStatus --> [*]
    }
```

### Node Drain Process
Let's visualize the Node Drain process, which is a critical part of machine deletion:
- Sophisticated pod eviction handling
- Supports both forced and normal drain scenarios
- Handles PDB (Pod Disruption Budget) violations
- Includes parallel and serial eviction strategies

```mermaid
stateDiagram-v2
    state "Node Drain" as ND {
        [*] --> ValidateNode
        
        ValidateNode --> CheckNodeCondition
        CheckNodeCondition --> ForceDeletion : Not Ready/Timeout
        CheckNodeCondition --> NormalDrain : Healthy
        
        state "NormalDrain" as Normal {
            [*] --> CordonNode
            CordonNode --> WaitForSync
            WaitForSync --> GetPods
            GetPods --> EvictPods
            
            state "EvictPods" as EP {
                [*] --> CheckEvictionSupport
                
                CheckEvictionSupport --> ParallelEviction : Force Delete
                CheckEvictionSupport --> MixedEviction : Normal Delete
                
                state "MixedEviction" as ME {
                    ParallelNoPV --> SerialWithPV
                }
                
                ParallelEviction --> WaitForEviction
                MixedEviction --> WaitForEviction
                WaitForEviction --> HandlePDBViolation
                HandlePDBViolation --> RetryEviction
                RetryEviction --> [*]
            }
            
            EvictPods --> UpdateNodeCondition
            UpdateNodeCondition --> [*]
        }
        
        ForceDeletion --> [*]
    }
```

## Safety Controller
1. Orphan VM Check:
   - Runs periodically (every 15 minutes) to detect and clean up orphaned VMs
   - Lists all VMs in the cloud provider matching the cluster's tag
   - Maps VMs to machine objects using ProviderID
   - Handles nodes without machine objects:
     + Adds `NotManagedByMCM` annotation after timeout
     + Removes annotation if machine object is found
   - Logs all cleanup operations for audit purposes

2. API Server Safety:
   - Monitors connectivity to both control and target API servers
   - Implements a freezing mechanism when API servers are unreachable
   - Manages machine controller state based on API server health:
     + Freezes operations if timeout exceeded
     + Unfreezes when API servers become available
   - Handles machine status updates during API server recovery

```mermaid
stateDiagram-v2
    state "Safety Controller" as SC {
        state "Orphan VM Check" as OVC {
            [*] --> ListCloudVMs
            ListCloudVMs --> MapToMachines
            MapToMachines --> CheckOrphans
            
            state "CheckOrphans" as CO {
                [*] --> NoMachineObject
                NoMachineObject --> ConfirmDeletion
                ConfirmDeletion --> DeleteVM
                DeleteVM --> LogDeletion
            }
            
            CheckOrphans --> AnnotateNodes
            
            state "AnnotateNodes" as AN {
                [*] --> CheckNodeMachine
                CheckNodeMachine --> MultipleMatch : Multiple Machines
                CheckNodeMachine --> NoMatch : No Machine
                CheckNodeMachine --> SingleMatch : One Machine
                
                NoMatch --> TimeoutCheck
                TimeoutCheck --> AddAnnotation : Timeout Exceeded
                
                SingleMatch --> RemoveAnnotation : Has Annotation
                
                AddAnnotation --> UpdateNode
                RemoveAnnotation --> UpdateNode
            }
        }

        state "API Server Safety" as ASS {
            [*] --> CheckFrozen
            CheckFrozen --> CheckAPIServer : Frozen
            CheckFrozen --> MonitorAPI : Not Frozen
            
            CheckAPIServer --> Unfreeze : API Up
            CheckAPIServer --> Requeue : API Down
            
            MonitorAPI --> SetInactiveTime : API Down
            MonitorAPI --> ClearInactiveTime : API Up
            
            SetInactiveTime --> CheckTimeout
            CheckTimeout --> Freeze : Timeout Exceeded
            
            Unfreeze --> UpdateMachines
            UpdateMachines --> ResetTimeout
        }
    }
```


## MachineSet Controller
1. Core Reconciliation:
   - Validates MachineSet specifications
   - Manages finalizers for proper cleanup
   - Implements machine ownership through controller references
   - Synchronizes node templates and configurations

2. Replica Management:
   - Implements sophisticated scaling logic:
     - Slow-start batching for scale-up operations
     - Prioritized scale-down based on machine health
   - Handles stale machine cleanup
   - Maintains desired replica count
   - Updates status to reflect current state

```mermaid
stateDiagram-v2
    state "MachineSet Controller" as MSC {
        [*] --> FetchMachineSet
        FetchMachineSet --> ValidateSpec
        ValidateSpec --> AddFinalizers : No Deletion
        ValidateSpec --> ProcessDeletion : Deletion Requested
        
        AddFinalizers --> ClaimMachines
        
        state "ClaimMachines" as CM {
            [*] --> CreateControllerRef
            CreateControllerRef --> MatchSelector
            MatchSelector --> AdoptOrphan : No Owner
            MatchSelector --> ReleaseClaimed : Wrong Owner
            
            AdoptOrphan --> UpdateOwnerRef
            ReleaseClaimed --> RemoveOwnerRef
        }
        
        ClaimMachines --> SyncNodeTemplates
        SyncNodeTemplates --> SyncMachineConfig
        SyncMachineConfig --> HandleDeletion : Deletion Requested
        SyncMachineConfig --> ManageReplicas : No Deletion
        
        state "ManageReplicas" as MR {
            [*] --> GetActiveMachines
            GetActiveMachines --> DeleteStale
            DeleteStale --> CheckReplicas
            
            CheckReplicas --> ScaleUp : Active Machine Too Few
            CheckReplicas --> ScaleDown : Active Machine Too Many
            
            ScaleUp --> SlowStartBatch
            SlowStartBatch --> CreateMachines
            
            ScaleDown --> SortMachines
            SortMachines --> DeleteExcess
        }
        
        ManageReplicas --> UpdateStatus
        HandleDeletion --> UpdateStatus
        UpdateStatus --> [*]
    }
```


## MachineDeployment Controller
Deployment Management:
- Handles multiple MachineSets for a deployment
- Maintains deployment history through revisions
- Supports pausing and resuming deployments
- Implements rollback functionality

1. Deployment Strategies:
   - Recreate Strategy:
     - Scales down old MachineSets completely
     - Creates and scales up new MachineSet
     - Ensures clean cutover between versions
   
   - Rolling Update Strategy:
     - Gradually scales up new MachineSet
     - Gradually scales down old MachineSets
     - Maintains availability during updates
     - Handles surge and unavailability constraints

2. Scaling Operations:
   - Detects and handles scaling events
   - Manages desired replica counts across MachineSets
   - Updates annotations for autoscaler integration
   - Ensures proper resource cleanup

```mermaid
stateDiagram-v2
    state "MachineDeployment Controller" as MDC {
        [*] --> FetchDeployment
        FetchDeployment --> ValidateSpec
        ValidateSpec --> GetMachineSets
        
        state "GetMachineSets" as GMS {
            [*] --> ClaimMachineSets
            ClaimMachineSets --> BuildMachineMap
            BuildMachineMap --> SyncRevision
            
            state "ClaimMachineSets" as CMS {
                [*] --> CreateControllerRef
                CreateControllerRef --> MatchSelector
                MatchSelector --> AdoptOrphan : No Owner
                MatchSelector --> ReleaseClaimed : Wrong Owner

                AdoptOrphan --> UpdateOwnerRef
                ReleaseClaimed --> RemoveOwnerRef
            }
        }
        
        GetMachineSets --> CheckDeletion
        CheckDeletion --> HandleDeletion : Deletion Requested
        CheckDeletion --> CheckPaused : No Deletion
        
        
        CheckPaused --> Sync : Paused
        CheckPaused --> CheckRollback : Not Paused
        
        state "Rollback" as RB {
            [*] --> FindRevision
            FindRevision --> RemoveTaints
            RemoveTaints --> UpdateTemplate
            UpdateTemplate --> SyncStatus
        }
        
        CheckRollback --> Rollback : Rollback Requested
        CheckRollback --> CheckScaling : No Rollback
        
        state "Scaling" as SC {
            [*] --> CheckActiveMS
            CheckActiveMS --> CheckReplicas
            CheckReplicas --> SyncScale
        }
        
        CheckScaling --> Scaling : Scale Event
        CheckScaling --> DeployStrategy : No Scale Event
        
        state "DeployStrategy" as DS {
            state "Recreate" as RC {
                [*] --> OldScaleDown
                OldScaleDown --> CreateNew
                CreateNew --> NewScaleUp
            }
            
            state "RollingUpdate" as RU {
                [*] --> ScaleUpNew
                [*] --> ScaleDownOld
                ScaleDownOld --> CleanupOld
            }
        }
        
        DeployStrategy --> UpdateStatus
        UpdateStatus --> [*]
    }
        
```

## Summary
Each of these controllers implements sophisticated error handling and retry mechanisms:
1. Error Handling:
   - Categorizes errors into recoverable and non-recoverable
   - Implements exponential backoff for retries
   - Maintains error counters and conditions
   - Updates status to reflect error states

2. Resource Protection:
   - Uses finalizers to prevent premature deletion
   - Implements owner references for proper garbage collection
   - Maintains consistent state through careful status updates
   - Handles race conditions through proper locking

3. Performance Considerations:
   - Implements work queues for efficient processing
   - Uses informers for efficient cache handling
   - Batches operations when possible
   - Implements rate limiting for API calls

4. Monitoring and Metrics:
   - Tracks operation durations
   - Records error counts and types
   - Provides health metrics
   - Implements proper logging for debugging

The entire system works together to provide:
1. Reliable machine lifecycle management
2. Proper cleanup of resources
3. Scaling capabilities
4. Rolling updates and rollbacks
5. Protection against race conditions and API server issues
6. Efficient resource utilization
7. Proper monitoring and debugging capabilities

This comprehensive system ensures robust machine management while maintaining high availability and proper resource utilization. The controllers work together to maintain the desired state while handling various edge cases and failure scenarios.
