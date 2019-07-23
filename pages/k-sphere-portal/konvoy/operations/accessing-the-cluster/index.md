---
layout: layout.pug
navigationTitle: Accessing the cluster
title: Accessing the cluster
menuWeight: 1
excerpt: Access the Konvoy cluster using the operations portal, command-line interface, or kubectl
enterprise: false
---

# Using the operations portal

# Using the Konvoy command-line interface

# Using kubectl

One of the most common ways to perform administrative tasks and interact with a Kubernetes cluster is through the `kubectl` command-line interface.
With `kubectl`, you can run commands against native Kubernetes clusters to retrieve information about key cluster activities and to control specific cluster-level components and operations.
For example, you can use `kubectl` to:
- Deploy applications
- Manage cluster resources
- View logs and status messages

For a complete list of `kubectl` operations, see [Overview of kubectl](https://kubernetes.io/docs/reference/kubectl/overview/).

### Install kubectl

The specific steps required in install kubectl depend on your operating system platfor. For platform-specific instructions to help you install kubectl, see the appropriate Kubernetes [installation and setup information][0] for the platform you use.

### Configure kubectl

The `kubectl` program uses information in its configuration file to customize operations for a specific cluster.
By default, the configuration file for `kubectl` is named `config` and is located in the `$HOME/.kube` directory.
You can specify other `kubeconfig` files by setting the `KUBECONFIG` environment variable or by setting the `--kubeconfig` flag.

After you create a cluster with the `konvoy up` command, the simplest way to add that cluster's `kubectl` configuration to either the default  `~/.kube/config` file or to the file you have specified using the `KUBECONFIG` environment variable is to run the following `konvoy` command:

```bash
konvoy apply kubeconfig
```

The `konvoy apply kubeconfig` command applies the contents of the local Konvoy `admin.conf` configuration file to your existing default configuration.

### Common kubectl command examples

The following sections highlight several important commands that are particularly relevant for working with **konvoy** clusters.
For information about other commands that are generally useful, see [the kubectl cheatsheet][1].

#### Viewing addons and system pods

Konvoy clusters come with a series of addons deployed.
These addons live in one of three namespaces:

* `kube-system`: addons that require administrative access to the cluster deploy here
* `velero`: Velero (used for cluster backup and restore) and its components are deployed here
* `kubeaddons`: by default addons will be deployed here unless otherwise specified

For a basic status check of all the addon- and system-related pods, run the following commands:

```bash
kubectl -n kube-system get pods
kubectl -n velero get pods
kubectl -n kubeaddons get pods
```

[0]:https://kubernetes.io/docs/tasks/tools/install-kubectl/
[1]:https://kubernetes.io/docs/reference/kubectl/cheatsheet/