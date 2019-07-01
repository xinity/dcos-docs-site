---
layout: layout.pug
navigationTitle: Storage
title: Storage Basics
menuWeight: 1
excerpt: 
enterprise: false


---

Clusters that you deploy with `konvoy` use the underlying storage components provided by [Kubernetes](https://kubernetes.io). The native Kubernetes storage components enable persistent storage for add-ons and for end-user applications.

The topics in this section describe the basic storage options and how storage is used on a **konvoy** cluster. If you are not familiar with Kubernetes storage, however, you should start by reviewing basic storage concepts such as [volumes](https://kubernetes.io/docs/concepts/storage/) and [storage classes](https://kubernetes.io/docs/concepts/storage/storage-classes/) in the Kubernetes documentation. You should also be familiar with how Kubernetes uses [persistent volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/).

## Default storage options

If you don't have a cloud provider configured for the cluster you deployed with `konvoy`, the [default storage class](https://kubernetes.io/docs/tasks/administer-cluster/change-default-storage-class/) provided is a **local-path** storage option. You should keep in mind that local-path storage does not provide **high-availability** (HA) and is not suitable for a production environment. You should only use the local-path storage option for **test clusters** or **demonstration purposes**.

If a `konvoy` cluster is deployed on a cloud provider instance, the high-availability storage option for that provider is configured as the default storage class for your cluster. Currently, the supported storage backends are:

* [AWS EBS Volumes](https://aws.amazon.com/ebs/)

You can also add your own storage classes and set a new default storage option for your own applications.

The **Konvoy add-ons** also use the default storage option you have deployed, and any additional applications you deploy into the cluster will use the default storage class as well.

You can view the default storage class on the cluster by running the following command:

```bash
$ kubectl get storageclasses
```
The command returns information similar to the following:
```
NAME                       PROVISIONER       AGE
ebs-csi-driver (default)   ebs.csi.aws.com   15s
```

To test your storage option, see the Kubernetes documentation for [configuring persistent volume storage for a pod](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/).
