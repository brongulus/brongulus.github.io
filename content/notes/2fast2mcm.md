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
---
  config:
    layout: elk
---
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
            
            ValidateMachine --> ValidateMachineClass
            VaildateMachineClass --> DeletionTimestamp

            DeletionTimestamp --> DeletionFlow : Deletion Requested
            DeletionTimestamp --> AddFinalizers : No Deletion
            
            AddFinalizers --> CheckPhase&NodeLabel
            
            CheckPhase&NodeLabel --> ReconcileHealth : Has Node & Non-empty phase
            CheckPhase&NodeLabel --> CreationFlow : No Node or<br/>CrashLoopBackOff<br/>or EmptyPhase
            
            ReconcileHealth --> SyncNodeName
            SyncNodeName --> SyncTemplates
            SyncTemplates --> [*]
            
            CreationFlow --> [*]
            DeletionFlow --> [*]
        }
    }
```

### Machine Creation
Machine Creation Flow:
- Complex process involving multiple status checks
- Handles initialization and error cases
- Includes node verification and cleanup of stale resources
- Multiple retry mechanisms for resilience

```mermaid
---
  config:
    look: handDrawn
---
stateDiagram-v2
    classDef imp font-weight:bold,stroke-width:5px;
        state "From <u>CreateResponse</u>: Assign Node Name & ProviderID" as ANPIDCMR
        state "From <u>GetMachineStatusResponse</u>: Assign Node Name & ProviderID" as ANPIDGMS
        state "From <u>GetMachineStatusResponse</u>: Assign Node Name & ProviderID" as ANPIDGMSR
        state "Assign Node Name<br/>from Machine label" as ANML
        state "Phase: <i>Pending</i><br/>State: <i>Processing</i><br/>OpType: Create" as CPPP
        state "State: <i>Failed</i><br/>OpType: <i>Create</i>" as SFFF
        
        [*] --> AddBootToken&MachineName
        AddBootToken&MachineName --> GetMachineStatus:::imp
        
        GetMachineStatus:::imp --> ANPIDGMS : Success
        ANPIDGMS --> UpdateAnnotationsLabels
        UpdateAnnotationsLabels --> CPPP : Phase <i>""(empty) or CrashLoopBackOff</i>
        CPPP --> StatusUpdate
        StatusUpdate --> [*]
        
        GetMachineStatus:::imp --> CheckNodeExists : NotFound or Unimplemented
        CheckNodeExists --> ANML : Node Exists
        ANML --> UpdateAnnotationsLabels
        
        CheckNodeExists --> CreateMachine:::imp : No Node
        CreateMachine:::imp --> ANPIDCMR : Successful creation
        CreateMachine:::imp --> CheckFailurePhase : Creation Error
        ANPIDCMR --> SetUninitialized : Node name is Machine Name
        SetUninitialized --> UpdateAnnotationLabel
        UpdateAnnotationLabel --> InitializeMachine:::imp
        InitializeMachine:::imp --> [*]
        
        ANPIDCMR --> DeleteMachine:::imp : <u>Stale Node</u><br/>NodeName is not MachineName
        DeleteMachine:::imp --> SFFF: "VM using old node obj"
        
        GetMachineStatus:::imp --> ANPIDGMSR : Uninitialized
        ANPIDGMSR --> SetUninitialized
        
        GetMachineStatus:::imp --> CheckFailurePhase : Other Errors
        CheckFailurePhase --> Failed : Timeout
        CheckFailurePhase --> CrashLoopBackOff : Not timed out
        Failed --> SFFF
        CrashLoopBackOff --> SFFF
        
        SFFF --> [*]

```

### Health Check
```mermaid
---
  config:
    layout: elk
---
stateDiagram-v2
    state "Health Reconciliation" as HR {
        state "Phase: <i>Unknown</i><br/>State: <i>Processing</i><br/>LastOp: <i>HealthChk</i>" as PUSP
        state "Phase: <i>Failed</i><br/>State: <i>Failed</i>" as PFSF
        state "LastOp State: Successful<br/>Phase: Running" as SSPR

        [*] --> GetMachineNode
        GetMachineNode --> PUSP : Not Found & RunningPhase<br/>Node object missing
        GetMachineNode --> Found

        Found --> MachineCondSetToNodeCond : NodeCondition != MachineCondition
        Found --> isHealthy : TODO (isHealthy)

        GetMachineNode --> CreationTimeout : PendingPhase
        GetMachineNode --> HealthTimeout : UnknownPhase

        CreationTimeout --> PFSF : Now - LastUpdateTime > Timeout
        HealthTimeout --> GetDeploymentName : Now - LastUpdateTime > Timeout
        CreationTimeout --> EnqueueAfter : Not timed out
        HealthTimeout --> EnqueueAfter : Not timed out


        GetDeploymentName --> RegisterPermit
        RegisterPermit --> TryMarkingMachineFailed
        TryMarkingMachineFailed --> InProgressMachines++ : Phase not<br/>Unknown or Running<br/>Machines "getting replaced"
        InProgressMachines++ --> PFSF:  InProgressMachines < MaxReplacements(1)

        MachineCondSetToNodeCond --> isHealthy
        isHealthy --> PUSP: Not Healthy & RunningPhase
        isHealthy --> CheckLastOp : Healthy & NotRunningPhase &<br/>NoCriticalComponentNotReadyTaint

        CheckLastOp --> DeleteBootstrapToken: TypeCreate &<br/> State is not Successful<br/>(Machine creation happened)
        CheckLastOp --> LastOpType=HealthChk: Not Create<br/>(Machine re-joined)

        DeleteBootstrapToken --> SSPR
        LastOpType=HealthChk --> SSPR

        SSPR --> UpdateStatus
        PUSP --> UpdateStatus
        PFSF --> UpdateStatus

        UpdateStatus --> [*]
        EnqueueAfter --> [*]
    }       

```

### Machine Deletion
Machine Deletion Flow:
- Carefully orchestrated process to ensure clean resource cleanup
- Involves multiple phases from drain to final cleanup
- Handles volume attachments and node cleanup
- Includes finalizer management for resource protection

```mermaid
---
  config:
    layout: elk
---
stateDiagram-v2
    state "Deletion Flow" as DF {
        direction LR
        state "ProcessPhase" as PP
        state "UpdateStatus" as US

        [*] --> CheckFinalizers
        CheckFinalizers --> SetTerminating
        SetTerminating --> PP

        PP --> GetVMStatus
        GetVMStatus --> [*]
        PP --> InitiateDrain
        InitiateDrain --> [*]
        PP --> DeleteVolumeAttachments
        DeleteVolumeAttachments --> [*]
        PP --> InitiateVMDeletion
        InitiateVMDeletion --> [*]
        PP --> InitiateNodeDeletion
        InitiateNodeDeletion --> [*]
        PP --> RemoveFinalizers
        RemoveFinalizers --> [*]
        PP --> US
        US --> [*]
    }
```

```mermaid
---
  config:
    layout: elk
---
stateDiagram-v2
    state "Initiate Drain" as ND {
        [*] --> ValidateNode
        state "UpdateStatus" as USD
        state "State: Processing<br/>Type: Delete" as SPTD
        state "CheckNodeCondition<br/>'Ready' or 'Read-only FS'" as CNC
        state "Phase is not Terminating" as NAT
        state "Terminating<br/>Reason: Unhealthy" as TRU
        state "Terminating<br/>Reason: ScaleDown" as TRSD
        state "SkipDrain<br/>State: Failed" as CUFail
        state "State: Processing<br/>Desc: DelVolAttachments" as SPDDVA
        state "State: Processing<br/>Desc: InitVMDeletion" as SPDIVD
        state "State: Failed<br/>Desc: InitiateDrain" as SFDID

        ValidateNode --> SPTD : NodeName is empty
        SPTD --> USD
        ValidateNode --> CNC
        CNC --> ForceDeletion : Read-Only/NotReady &<br/>Last-transition Timeout
        CNC --> NormalDrain : Healthy
        CNC --> ForceDeletion : "force-delete" label on machine or Drain<br/> Timeout on deletion

        ForceDeletion --> UpdateTerminationCondition
        NormalDrain --> UpdateTerminationCondition

        UpdateTerminationCondition --> RunDrain : Phase is empty or CrashLoopBackOff
        UpdateTerminationCondition --> NAT : Non-creation Phase
        NAT --> TRU : Phase is failed
        NAT --> TRSD : Phase not failed
        TRU --> TerminationConditionUpdate
        TRSD --> TerminationConditionUpdate

        TerminationConditionUpdate --> CUFail : Update failure<br/>during NormalDrain
        TerminationConditionUpdate --> RunDrain : Update failure<br/>during ForceDeletion
        TerminationConditionUpdate --> RunDrain : Update Successful
        CUFail --> USD

        RunDrain --> SPDDVA : Drain successful<br/>during ForceDeletion
        RunDrain --> SPDIVD : Drain successful<br/>during NormalDrain
        RunDrain --> SPDDVA : Drain failed<br/>"force-delete" label present
        RunDrain --> SFDID : Drain failed<br/>"force-delete" label absent

        SPDDVA --> USD
        SPDIVD --> USD
        SFDID --> USD

        USD --> [*]
    }
```

Let's visualize the Node Drain process, which is a critical part of machine deletion:
- Sophisticated pod eviction handling
- Supports both forced and normal drain scenarios
- Handles PDB (Pod Disruption Budget) violations
- Includes parallel and serial eviction strategies

```mermaid
---
  config:
    layout: elk
---
stateDiagram-v2
    state "RunDrain" as Normal {
        state "CordonNode (Sealing off)<br/>(Set Unschedulable to true)" as CN
        [*] --> CN
        CN --> WaitForPodCacheSync
        WaitForPodCacheSync --> GetPodsForDeletion : TODO
        
        %% http://localhost:3000/machine-controller/node_drain.html#drainoptionsgetpodsfordeletion
        %% mirrorPodFilter: pod doesnt have MirrorPodAnnotation (set by kubelet when creating mirror pods)
        %% localStorageFilter
        %% unreplicatedFilter
        %% daemonSetFilter
        
        GetPodsForDeletion --> DeleteOrEvictPods

        DeleteOrEvictPods --> UpdateNodeCondition
        UpdateNodeCondition --> [*]
        
        state "DeleteOrEvictPods" as EP {
            [*] --> CheckEvictionSupport

            CheckEvictionSupport --> ParallelEviction : ForceDeletion
            CheckEvictionSupport --> MixedEviction : NormalDrain

            MixedEviction --> ParallelEvictNoPV
            MixedEviction --> SerialEvictWithPV

            ParallelEvictNoPV --> WaitForEviction
            SerialEvictWithPV --> WaitForEviction
            ParallelEviction --> WaitForEviction
            WaitForEviction --> HandlePDBViolation
            HandlePDBViolation --> RetryEviction
            RetryEviction --> [*]
        }
}
```

```mermaid
---
title: EvictPodsNoPV
---
stateDiagram-v2
    classDef imp font-weight:bold,stroke-width:5px;
        state "Retry count >= MaxEvictRetries" as Term
        state "Set attemptEvict as False" as AEF
        state "Sleep(EvictRetryInterval)" as SRC

        [*] --> Term:::imp

        Term:::imp --> CheckAttemptEvict : No
        Term:::imp --> AEF : Yes
        AEF --> CheckAttemptEvict

        CheckAttemptEvict --> EvictPod : True
        CheckAttemptEvict --> DeletePod : False

        EvictPod --> CheckErr
        DeletePod --> CheckErr

        CheckErr --> BreakLoop:::imp : nil
        CheckErr --> LogEvict : notFound
        CheckErr --> EvictFailErr : AttemptEvict is False
        CheckErr --> PDBViolation : APIErr too many req

        PDBViolation --> GetPDB

        GetPDB --> SRC : No PDB
        GetPDB --> CheckMisconfigured : PDB exists

        CheckMisconfigured --> MisconfigErr : Generation is ObserverGen<br/>HealthyPods >= ExpectedPods<br/>DisruptionsAllowed is 0
        CheckMisconfigured --> SRC : No

        SRC:::imp --> Term : count++


        BreakLoop:::imp --> ReturnSuccess:::imp : ForceDeletion
        BreakLoop:::imp --> GetTerminationGracePeriod : NormalDrain

        GetTerminationGracePeriod --> SetToTimeout : GracePeriod > Timeout
        GetTerminationGracePeriod --> WaitForDeletion : Grace < Timeout
        SetToTimeout --> WaitForDeletion

        WaitForDeletion --> TimeoutErr : timeout &<br/>pod exists
        WaitForDeletion --> WaitErr : err
        WaitForDeletion --> ReturnSuccess:::imp : timeout &<br/>pod deleted

        LogEvict --> [*]
        EvictFailErr --> [*]
        MisconfigErr --> [*]
        TimeoutErr --> [*]
        WaitErr --> [*]
        ReturnSuccess:::imp --> [*]
```

```mermaid
---
title: EvictPodsWithPV
config:
  layout: elk
---
stateDiagram-v2
    classDef imp font-weight:bold,stroke-width:5px;
        state "Retry count < MaxEvictRetries" as Term
        state "Sleep(EvictRetryInterval)" as SRC
        state "CheckRemainingPods" as CRP
        
        [*] --> SortPodsByPriority
        SortPodsByPriority --> podVolumeInfoMap
        note left of podVolumeInfoMap
            Creates a map from pod to list of attached PVs (VolName, VolID -> GetVolumeID)
        end note

        podVolumeInfoMap --> AttemptEvict
        AttemptEvict --> evictPodPVInternal(Delete):::imp : false
        AttemptEvict --> Term:::imp : true
        Term:::imp --> evictPodPVInternal(Evict):::imp : true
        evictPodPVInternal(Evict):::imp --> break:::imp : FastTrack or<br/>All pods evicted
        evictPodPVInternal(Evict):::imp --> SRC : Not FastTrack and<br/>Pods Remaining
        SRC --> Term:::imp : count++

        Term:::imp --> evictPodPVInternal(Delete):::imp : false<br/>Not FastTrack and<br/>Pods Remaining
        break:::imp --> [*] : All pods evicted

        break:::imp --> CRP : FastTrack
        evictPodPVInternal(Delete):::imp --> CRP

        CRP --> Success:::imp : Node Not Found
        CRP --> ChkAttemptEvict
        ChkAttemptEvict --> EvictErr : True
        ChkAttemptEvict --> DeleteErr : False

```

```mermaid
---
title: EvictPodsWithPVInternal
config:
  layout: elk
---
stateDiagram-v2
    classDef imp font-weight:bold,stroke-width:5px;
        state "Add Pod to RetryPods" as Retry
        state "Log NotFound<br/>DeleteWorker" as LogNotFound
        [*] --> SelectPod : Start Eviction Process

        SelectPod --> CheckContextTimeout:::imp

        CheckContextTimeout:::imp --> AbortProcess : Context Done
        CheckContextTimeout:::imp --> AddWorker(AttachmentHandler) : Context Not Done

        AddWorker(AttachmentHandler) --> EvictOrDelete

        EvictOrDelete --> CheckEvictionResult:::imp

        CheckEvictionResult:::imp --> EvictionFailed
        EvictionFailed --> PDBViolation : Eviction Attempted &<br/>TooManyRequests
        EvictionFailed --> PodAlreadyGone : Pod Not Found
        EvictionFailed --> EvictionError : Other Errors
        CheckEvictionResult:::imp --> WaitForVolumeDetach : Successful Eviction

        PDBViolation --> GetPDB
        GetPDB --> CheckMisconfigured : PDB Exists
        GetPDB --> Retry : NoPDB
        CheckMisconfigured --> MisconfigErr : Generation is ObserverGen<br/>HealthyPods >= ExpectedPods<br/>DisruptionsAllowed is 0
        CheckMisconfigured --> Retry:::imp : NotMisconfig
        MisconfigErr --> DeleteWorker

        PodAlreadyGone --> DeleteWorker

        EvictionError --> Retry:::imp

        WaitForVolumeDetach --> CheckDetachResult:::imp : TerminationGracePeriod + DetachTimeout

        CheckDetachResult:::imp --> LogNotFound : Node Not Found
        CheckDetachResult:::imp --> DetachError : Detach Failed
        CheckDetachResult:::imp --> WaitForReattach : Successful Detach

        LogNotFound --> AbortProcess
        DetachError --> DeleteWorker

        WaitForReattach --> CheckReattachResult:::imp : PvReattachTimeout

        CheckReattachResult:::imp --> ReattachTimeout : Timeout
        CheckReattachResult:::imp --> LogError : Reattach Failed
        CheckReattachResult:::imp --> SuccessfulEviction:::imp : Successful Reattach

        ReattachTimeout --> DeleteWorker : TODO IsThisCorrect?
        LogError --> DeleteWorker
        SuccessfulEviction:::imp --> DeleteWorker : Pod Processed

        DeleteWorker --> [*]
        Retry:::imp --> DeleteWorker
        AbortProcess --> Exit:::imp : Terminate (FastTrack)<br/>Return Remaining Pods
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
---
  config:
    layout: elk
---
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
---
  config:
    layout: elk
---
stateDiagram-v2
    state "MachineSet Controller" as MSC {
        state "Sync MachineSet<br/>NodeTemplate<br/>to Machine" as SyncNodeTemplates
        state "Sync MachineSet<br/>MachineConfiguration<br/>to Machine" as SyncMachineConfig
        state "Sync MachineSet<br/>MachineClass.Kind<br/>to Machine" as SyncMachineKind

        [*] --> FetchMachineSet
        FetchMachineSet --> ValidateSpec
        ValidateSpec --> AddFinalizers : Deletion Not Requested
        
        AddFinalizers --> ClaimMachines
        
        state "ClaimMachines (Returns filtered machines)" as CM {
            [*] --> CreateControllerRefMgr
            CreateControllerRefMgr --> GetControllerRef
            GetControllerRef --> Orphan : Nil<br/>(No Owner)
            GetControllerRef --> CheckUID : Not Nil<br/>(Owner Exists)
            
            CheckUID --> Ignore : Mismatch<br/>(Wrong Owner)
            CheckUID --> MatchSelector : UID Same
            Orphan --> CheckDeletion
            CheckDeletion --> SelectorMatch : No Deletion
            SelectorMatch --> AdoptOrphan : Selector Match
            
            MatchSelector --> KeepClaim : Selector Match<br/>Already Owned
            MatchSelector --> DeletionCheck : Selector Mismatch
            DeletionCheck --> AttemptRelease : No Deletion

            KeepClaim --> AddToClaimed
            AdoptOrphan --> AddToClaimed
            AttemptRelease --> RemoveFromClaimed
        }
        
        ClaimMachines --> SyncNodeTemplates
        SyncNodeTemplates --> SyncMachineConfig
        SyncMachineConfig --> SyncMachineKind
        SyncMachineKind --> CheckFilteredMachines : Deletion Requested
        SyncMachineKind --> ManageReplicas : No Deletion

        CheckFilteredMachines --> RemoveFinalizers : Zero Owned Machines
        CheckFilteredMachines --> CheckFinalizerPresent : Backed Machines
        CheckFinalizerPresent --> TerminateMachines
        RemoveFinalizers --> UpdateStatus
        TerminateMachines --> UpdateStatus

        state "ManageReplicas" as MR {
            [*] --> CheckMachinePhase
            CheckMachinePhase --> ActiveMachines : Phase<br/>NotFailedOrTerminating
            CheckMachinePhase --> StaleMachines : PhaseFailed

            ActiveMachines --> CheckDiff
            StaleMachines --> TerminateStale
            TerminateStale --> CheckDiff
            
            CheckDiff --> ScaleUp : ActiveMachines<br/>Less than<br/>Replica Count
            CheckDiff --> ScaleDown : ActiveMachines<br/>More than<br/>Replica Count
            
            ScaleUp --> NotFrozenAnd<br/>NotToBeDeleted
            NotFrozenAnd<br/>NotToBeDeleted --> SlowStartBatch : TODO Expectations
            SlowStartBatch --> CreateMachines
            
            ScaleDown --> SortMachines
            SortMachines --> DeleteExcess
        }
        
        ManageReplicas --> UpdateStatus
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
---
  config:
    layout: elk
---
stateDiagram-v2
    state "TODO MachineDeployment Controller" as MDC {
        [*] --> FetchDeployment
        FetchDeployment --> LogFrozenOrTBD
        LogFrozenOrTBD --> ValidateSpec
        ValidateSpec --> CheckDeletion
        
        state "GetMachineSets" as GMS {
            [*] --> CreateControllerRefMgr
            CreateControllerRefMgr --> GetControllerRef
            GetControllerRef --> Orphan : Nil<br/>(No Owner)
            GetControllerRef --> CheckUID : Not Nil<br/>(Owner Exists)

            CheckUID --> Ignore : Mismatch<br/>(Wrong Owner)
            CheckUID --> MatchSelector : UID Same
            Orphan --> CheckDelete
            CheckDelete --> SelectorMatch : No Deletion
            SelectorMatch --> AdoptOrphan : Selector Match

            MatchSelector --> KeepClaim : Selector Match<br/>Already Owned
            MatchSelector --> DeletionCheck : Selector Mismatch
            DeletionCheck --> AttemptRelease : No Deletion

            KeepClaim --> AddToClaimed
            AdoptOrphan --> AddToClaimed
            AttemptRelease --> RemoveFromClaimed
        }
        
        CheckDeletion --> AddFinalizer : No Deletion
        AddFinalizer --> StatusUpdate
        StatusUpdate --> GetMachineSets

        GetMachineSets --> BuildMachineMap<br/>MSetUIDToMachines
        BuildMachineMap<br/>MSetUIDToMachines --> DeleteChk
        DeleteChk --> CheckPausedCond : No Deletion
        DeleteChk --> ProcessDeletion : Deletion Requested
        
        state "Process Deletion" as DC {
            [*] --> Exit : Finalizer<br/>NotPresent
            [*] --> RemoveFinalizers : NoBackingMS
            [*] --> TerminateMachineSets : BackingMS
            
            TerminateMachineSets --> SyncStatusOnly<br/>UpdateMcdStatus
            RemoveFinalizers --> Exit
        }

        state "Check Paused Condition" as CPC {
            [*] --> GetCondition<br/>TypeProcessing
            
            GetCondition<br/>TypeProcessing --> [*] : CondReason<br/>TimeOut
            GetCondition<br/>TypeProcessing --> ExistingPaused : CondReason<br/>Paused
            GetCondition<br/>TypeProcessing --> NotExistingPaused : Else
            
            NotExistingPaused --> Spec.Paused
            Spec.Paused --> SetPausedCondition : true

            ExistingPaused --> SpecPaused
            SpecPaused --> SetResumedCondition : False

            SetPausedCondition --> UpdateMcdStatus
            SetResumedCondition --> UpdateMcdStatus

            UpdateMcdStatus --> [*]
        }

        CheckPausedCond --> SetPrioAnnotation : TODO

        SetPrioAnnotation --> Sync : Spec.Paused true<br/>TODO
        SetPrioAnnotation --> CheckRollbackTo : Spec.Paused false
        
        state "Rollback" as RB {
            [*] --> FindRevision
            FindRevision --> FindMatchingMS : RollbackTo.Revision<br/>Present
            FindRevision --> ClearRollbackTo : No last revision

            FindMatchingMS --> Remove<br/>PreferNoSched<br/>Taint : MSRevisionAnnotation<br/>same as<br/>RollbackTo Revision
            FindMatchingMS --> ClearRollbackTo : NoMachineSetFound
            
            Remove<br/>PreferNoSched<br/>Taint --> UpdateMcdTemplate
            UpdateMcdTemplate --> UpdateMcdAnnotations : Copy MS template<br/>Remove label<br/>machine-template-hash

            UpdateMcdAnnotations --> ClearRollbckTo
            ClearRollbckTo --> EmitRollbackEvent
        }
        
        CheckRollbackTo --> Rollback : Rollback Requested
        CheckRollbackTo --> IsScalingEvent : No Rollback
        
        state "Is Scaling Event" as SC {
            [*] --> GetMS<br/>SyncRev
            GetMS<br/>SyncRev --> NotScaling : err
            GetMS<br/>SyncRev --> NotScaling : No New MS
            
            GetMS<br/>SyncRev --> CheckActiveMS : MS Replicas > 0
            CheckActiveMS --> ScalingEvent : NoActiveMS &<br/>MCD Replicas > 0<br/>(ScaleFromZero)
            
            CheckActiveMS --> GetMSDesiredReplica<br/>Annotation
            GetMSDesiredReplica<br/>Annotation --> ScalingEvent : Desired not equal<br/>to MCD Replicas

            CheckActiveMS --> NotScaling : NoActiveMS or<br/>Desired = MCD Replicas<br/>(For all active)
        }
        
        IsScalingEvent --> Sync : Scale Event
        IsScalingEvent --> DeployStrategy : No Scale Event

        state "Sync" as SN {
            [*] --> GetMS<br/>SyncRevision
            GetMS<br/>SyncRevision --> Scale
            Scale --> CleanMCD : Paused and<br/>No RollbackTo
            Scale --> SyncMCDStatus

            state "Find Active or Latest MS" as ALMS {
            [*] --> SortMS by CreationTime<br/>FilterActiveMS
            }

            state "TODO Scale" as SCC {
                state "ReplicasToAdd<br/>AllowedSize - AllMSReplicaCnt" as ReplicasToAdd
                
                [*] --> GetActiveOrLatestMS
                GetActiveOrLatestMS --> CheckActiveMSReplicas : not nil
                GetActiveOrLatestMS --> CheckNewMS<br/>Saturated

                CheckActiveMSReplicas --> FIXME : ActiveMSRep = mcdRep

                CheckNewMS<br/>Saturated --> ScaleDownOldMS : true
                CheckNewMS<br/>Saturated --> IsRollingUpdate : false

                IsRollingUpdate --> FilterActiveMS : true
                FilterActiveMS --> GetReplicaCount<br/>AllMS

                GetReplicaCount<br/>AllMS --> FindAllowedSize

                FindAllowedSize --> Zero : MCD Replicas <= 0
                FindAllowedSize --> McdReplicas+MaxSurge : MCD Replicas > 0

                Zero --> ReplicasToAdd
                McdReplicas+MaxSurge --> ReplicasToAdd

                ReplicasToAdd --> ScaleUp : more than 0
                ReplicasToAdd --> ScaleDown : < 0

                ScaleUp --> map[name]=NewRep : oldMS = Replicas
                ScaleUp --> map[name]=NewRep : newMS = Rep+RepToAdd
                
            }
        }

        state "TODO DeployStrategy" as DS {
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
