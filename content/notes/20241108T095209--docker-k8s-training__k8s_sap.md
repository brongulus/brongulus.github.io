+++
title = "Docker Kubernetes Training Notes"
author = ["Tak"]
date = 2024-11-08T09:52:00+05:30
tags = ["k8s", "sap"]
draft = false
+++

## Docker {#docker}

A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another. The Linux kernel does not know about containers at all – for it, containers are nothing more than just regular processes running on the system. It however offers several features that Docker and other container engines leverage to achieve an almost complete isolation of processes from each other. Some of them being

-   Chroot : Changes the root directory for a process to any given directory, processes running in that chroot can only see those parts of the filesystem which are subdirectories of it
-   Namespaces : Different processes see different environments even though they are on the same host/OS
-   cgroups : manage/limit resource allocation to individual processes

When talking about a “container”, we are referring to the combination of read-only layers from the image and one read-write layer on top of it (overlayfs). You can derive/instantiate an indefinite number of containers from the same image. They only vary by the read-write layer on top. Or stated another way: A container consists of just the read-write layer, some meta data (settings, flags pass on start) and a reference to the image.

Creating a Docker image involves two things:

-   A _Dockerfile_ containing directives on how the image is meant to be built
-   A _build-context_ (or PATH) which is a directory on your hard disk; every file to be added to the image must be inside the build-context

Each line in a Dockerfile is executed in a temporary container which gets persisted as a new layer on top of the existing layers. Some directives to keep in mind are `FROM, ENV, LABEL, COPY, ADD, RUN, EXPOSE, CMD, ENTRYPOINT, USER`.

**Multistage builds** are another powerful feature of the container ecosystem. Typically, you do not want ship your build environment, but have a dedicated runtime environment. Multistage builds are an elegant way to separate these two things. The first stage is a build environment with a compiler or whatever is needed. The 2nd stage is much smaller in size/content (e.g. distroless) and should contain only those things needed to run the application. The stages are referred later on by specifying their names as `FROM <stage/image> AS <stage-name>`

Check [these links](20241017T232938--sap-useful-links__k8s_sap_work.org) for further references.


## Kubernetes {#h:06603D16-4A5E-4AC0-8A9C-8C7F5EE20433}

Kubernetes makes the core design decision that all configuration is declarative, and that all configuration is implemented by way of “operators” which function as control loops: They continually compare the desired configuration with the state of reality, and then attempt to take actions to bring reality in line with the desired state. ([Ref](https://buttondown.com/nelhage/archive/two-reasons-kubernetes-is-so-complex))

Kubernetes is just a container orchestrator. The central part remains our image, which contains the application we want to run. In the end Kubernetes runs lots and lots of containers – however in a smart way.

But it doesn’t allow you to schedule individual containers, it wraps the container into something called a _pod_ – which can be considered as a logical host with 1..n containers in it. Its one or more containers that share storage and network resources. Put another way, a Kubernetes Pod is a set of containers that perform an interrelated function and that operate as part of the same workload.

Containers in a pod share storage/network interface. Usually its one or two containers per pod, following the [sidecar](https://labs.iximiuz.com/tutorials/kubernetes-native-sidecars) (2nd container provides augmentation to improve the application container) or adapter (provides abstraction to entities outside of pod) pattern. ([Containers vs Pods](https://labs.iximiuz.com/tutorials/containers-vs-pods))

Although you could add all the containers for yoxur application into the same Pod, it is a good practice to have one container per Pod. Then, group all the Pods that conform one application into a Namespace.

A Kubernetes node is a physical or virtual machine that operates as part of a Kubernetes cluster. Pods can run on nodes, but the purpose of a node is to provide host infrastructure, not define and deploy applications. Pods do the latter. Thus, while Pods are the fundamental building blocks of Kubernetes workloads, nodes are the fundamental building blocks of Kubernetes infrastructure.

While deploying a pod manually works, it doesn’t allow to scale nor to run reliably. With _deployments_ etc we get different constructs allowing to run one to many pods with different characteristics.

The networking entities provide cluster internal as well as external connectivity. _Policies_ provide a runtime security context on networking as well as container level. Resources have also an API representation – you can get information about nodes and manage consumption per pod etc.

Further details:

-   Ingress: Allows to create a network entity on top of services to expose applications. Expose applications via a URL.
-   Endpoints are networking objects backing services to enable routing etc. Endpoints can be created manually to point to external applications. So external apps can be integrated into the cluster.
-   Network ([k8s networking](https://sysdig.com/learn-cloud-native/what-is-kubernetes-networking/)) policies are the cluster’s firewall to regulate access to pods etc. They cover ingress and egress traffic cluster internally and externally.
-   Job/CronJob: Schedule a pod and run as task to completion. CronJob allows to schedule jobs periodically.
-   DaemonSet: Ensures that all (or explicitly specified) nodes run a copy of a pod. They ensure that a pod is replicated on some or all of the nodes. When a new node is added to a Kubernetes cluster, a new pod will be created on that node. For example a kube-proxy can run as a pod on every node managed by a daemonSet. A daemonset works almost similar to a deployment. However the replica count is determined by the number of cluster nodes.
-   StatefulSet: Manages the deployment and scaling of a set of pods, and **provides guarantees about the ordering and uniqueness** of these pods. Similar to deployments, however it provides _more stability_ with regards to names/identifiers. Service routes traffic to a **specific** pod based on labels and **names** and pods have stable names, individual persistent storage and are ordered unlike in the case of deployments.
-   Headless Service: Allows you to connect directly to a pod while using dns names instead of IP addresses. A headless service is created, by specifying “None” as the value for “ClusterIP”. They are needed to make StatefulSets work.
-   [ReplicaSet](https://sysdig.com/learn-cloud-native/kubernetes-replicasets-overview/): Kubernetes object used to maintain a stable set of replicated pods running within a cluster at any given time. Deployments are an alternative to ReplicaSets,  as they are used to manage ReplicaSets . They are handy when it comes to rolling out changes to a set of pods via a ReplicaSet. You can simply roll back to a previous Deployment revision when managing a ReplicaSet using a Deployment or create a new revision.
-   Pod Security Policy: Defines conditions pods must run with. Conditions cover aspects like runAsUser, file system groups, privileges of containers and more. ([k8s secrets](https://sysdig.com/learn-cloud-native/how-to-create-and-use-kubernetes-secrets/))
-   Resource Quotas: Set quotas on namespace level, Limit the number of resources (pod, pvc, service, …) allowed in this namespace =&gt; object count quota or limit the resources allowed to be consumed by pods or other objects =&gt; (compute) resource quota. Can also enforce applications to specify minimal resources required and max resources wanted.
-   Roles: a role defines a setup of API objects that can be accessed in a certain way. For example, a role can allow only list/read access to pods. Another role could also allow to list/read, create &amp; delete pods
-   Role Bindings: assign roles to service accounts /technical users ([rbac explained](https://sysdig.com/learn-cloud-native/kubernetes-rbac-explained/))

Reconciliation consists of three stages - "Observe, Analyze, Act"

1.  Observe: Control loop watches API for changes
2.  Analyze: Check current state against the desired, look for any deltas
3.  Act: If there is a delta, controller should act and trigger a defined action to bring the observed objects into desired state

GVK: Groups are a collection of related functionality, versions are specific implementations and kinds are types. Namespaces group a set of resources.
`/api/<version>/` or `/apis/<group>/<version>/namespaces/<name>/...`

You don’t want to know and manage individual pods. You would like to specify a template and instantiate it as often as you wish. Also you want to manage the group of pods e.g. in terms of docker image used. The **deployment** gives you these management capabilities. In it’s resource description (yaml file) you specify a pod template, how pods should be labeled and of course a corresponding selector to identify your pods. The deployment creates and manages a replicaSet which in turn manages the pods.

Communication between pods requires something called as a "service", it's not sensible to rely on IP addresses for pods are they can change if a pod dies/restarts. Services act as a reliable and stable endpoint that provides cluster-internal and external connectivity. Services determine their managed pods by labels and corresponding selectors. Kubernetes also offers a way to name any port on a container/service level which can then be used as a reference even if the port value changes over time without impacting the application.

To expose a service to the outside world (outside of cluster scoped DNS/IP range), we can use NodePorts or LoadBalancer. Service Types

1.  Cluster IP
2.  LoadBalancer: A single network endpoint with a unique IP which will be associated with a service. Incoming traffic to this IP on the service port will be forwarded through the service to the pods matching the labels specified in the service description.
3.  NodePort: A port that is opened on every node of the cluster. It is associated with a service and any incoming traffic at this nodePort will be routed to the corresponding service. From there it will be forwarded to service’s pods, regardless on which node it they actually run.

Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. You must have an Ingress controller to satisfy an Ingress. Only creating an Ingress resource has no effect. You may need to deploy an Ingress controller such as ingress-nginx. Ingress controller is typically exposed via a LoadBalancer service and it handles traffic according to ingress specifications.

The easiest way of using an Ingress is as an entry point to a single service with one to multiple pods. The ingress is created for a dedicated URL. From the services perspective everything works as usual. A port and a target port are specified and base on labels and selectors the traffic is routed. In the spec, there is a section about rules &amp; TLS. Rules define forwarding of incoming traffic to backends. In this case traffic is send to a service.

[Types of ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/#types-of-ingress):

1.  An Ingress with no rules sends all traffic to a single default backend and `.spec.defaultBackend` is the backend that should handle requests in that case.
2.  A fanout configuration routes traffic from a single IP address to more than one Service, based on the HTTP URI being requested.
    ```yaml
    spec:
      rules:
    ​    - host: foo.bar.com
          http:
            paths:
    ​        - path: /foo
              pathType: Prefix
              backend:
                service:
                  name: service1
    ​        - path: /bar
              pathType: Prefix
              backend:
                service:
                  name: service2
    ```
3.  Name-based virtual hosts support routing HTTP traffic to multiple host names at the same IP address.
    ```yaml
    spec:
      rules:
    ​    - host: foo.bar.com # foo bar
          http:
            paths:
    ​        - path: "/"
              pathType: Prefix
              backend:
                service:
                  name: service1
    ​    - host: bar.foo.com # bar foo
          http:
            paths:
    ​        - path: "/"
              pathType: Prefix
              backend:
                service:
                  name: service2
    ```

Pods can die/restart unexpectedly and lose all the data that's local to them, to solve the problem of persistance kubernetes offers PV/PVCs. A PersistentVolume (PV) is a piece of storage in the cluster that has been provisioned by an administrator having a lifecycle independent of the pods using the PV. A PersistentVolumeClaim (PVC) is a request for a storage by a user.

Claims can request specific sizes and access modes and claims bind pod storage to PVs. PV size must match or exceed PVC requested size. Due to the PV-PVC bind mechanism, it might happen that storage is claimed by the “wrong” requests. _Storage classes_ overcome this issue of manually provisioning PV by reversing the order. Firstly create a PVC and the storage class provides a fitting PV.

CSI – Container Storage Interface:

1.  User requests a PVC
2.  StorageClass is triggered to provision a PV
3.  PV is backed by a physical volume, which is made available via the container storage interface.

Upon deletion of the claim object, PV becomes "unbound", then it can either be retained, deleted or recycled (deprecated). The access modes a PVC can specify are RWO (ReadWriteOnce) where a single node can mount a PVC at a time but if multiple pods are running on the same node they can all access it for restricting that to a single Pod use RWOP (ReadWriteOncePod). There's also ROX (ReadOnlyMany) and RWX (ReadWriteMany) where the volumes can be mounted as specified by many nodes.

An application container certainly needs configuration. However, adding this information to the container image is not feasible at all. Instead, we need a way through the Kubernetes API to reach our goal of dynamically injecting configuration, this is where ConfigMaps and Secrets come in. They separate configuration &amp; credentials from the application and the required configuration data can be stored in specific data objects in etcd.

Configmaps and secret are based on key-value pairs. Allowed values are string or binary data. When using binary data, base64 encoding of the binary is mandatory. The contents of both can be project to environment variables of a container or mounted to the container file system via the volumes API.

The secrets can be used like any other volume and bound to the pod. When mounted into the filesystem the content/values are decoded and available in plain text so it's advised to set proper file permissions for them. There are 3 different types of secrets:

1.  generic: to store credentials like passwords. Include as env variables or mount files
2.  TLS: store certificates to setup TLS e.g. with a webserver
3.  Docker-registry: Contains credentials to authenticate pulls from protected registry like the docker store or a private registry. Assign the secret as “imagePullSecret” to a pod, to use the credentials for image pulling for this pod.


## Helm {#helm}

Ref: [What is helm](https://sysdig.com/learn-cloud-native/what-is-helm-in-kubernetes/)
