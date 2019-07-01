---
layout: layout.pug
navigationTitle: Kubectl Basics
title: Kubectl Basics
menuWeight: 1
excerpt: 
enterprise: false


---

This document covers some basic commands to use in order to get started with a **konvoy** cluster and use **kubectl** to administrate it.

## Installing Kubectl

See the [kubernetes documentation on installing kubectl for your platform][0]

### Configuring Kubectl

After you create a cluster with the `konvoy up` command, the simplest way to add that cluster's `kubectl` configuration to either the `~/.kube/config` file or the file you have specified using the `KUBECONFIG` environment variable is to run the following `konvoy` command:

```bash
konvoy apply kubeconfig
```

This command applies the contents of the local `admin.conf` kubeconfig to your existing default configuration.

## Kubectl Examples

The following sections highlight several important commands that are particularly relevant for working with **konvoy** clusters.
For information about other commands that are generally useful, see [the kubectl cheatsheet][1].

### Viewing Addons and System Pods

**Konvoy** clusters come with a series of addons deployed.
These addons live in one of three namespaces:

* kube-system: addons that require administrative access to the cluster deploy here
* velero: Velero (used for cluster backup and restore) and its components are deployed here
* kubeaddons: by default addons will be deployed here unless otherwise specified

For a basic status check of all the addon- and system-related pods, run the following commands:

```bash
kubectl -n kube-system get pods
kubectl -n velero get pods
kubectl -n kubeaddons get pods
```

[0]:https://kubernetes.io/docs/tasks/tools/install-kubectl/
[1]:https://kubernetes.io/docs/reference/kubectl/cheatsheet/
