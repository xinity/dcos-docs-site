---
layout: layout.pug
navigationTitle: Backup and Restore
title: Backing Up and Restoring Clusters
menuWeight: 6
excerpt: 
enterprise: false


---

`Konvoy` provides an add-on named `velero` that gives you the tools to back up and
restore your Kubernetes cluster resources and persistent volumes. You can
use `velero` by enabling it as part of the `ClusterConfiguration` in the
`cluster.yaml` file, as follows:

```yaml
addons:
- name: velero
  enabled: true
...
```

The default settings of `Konvoy` configure `velero` to schedule the creation of backups
on daily basis saving the data from all the namespaces. Once the cluster is created
an initial backup will be triggered. To change this default settings,
the `Schedule` custom resource `daily-backup` needs to be updated:

```yaml
apiVersion: velero.io/v1
kind: Schedule
metadata:
  name: daily-backup
  namespace: velero
spec:
  schedule: 0 1 * * *
  template:
    includedNamespaces:
    - '*'

```

## Backup

To back up a cluster data on demand, you should install the `velero` command
line [tool](https://github.com/heptio/velero/releases).

```shell
velero --kubeconfig=admin.conf backup create my-test-backup
```

This action saves a backup in a S3 compatible storage system. Initially, `Konvoy`
configures `velero` to use [Minio](https://velero.io/docs/v1.0.0/get-started/) as S3 storage system.

To download a created backup, the user should use the following command that would
download the cluster data to a tarball in the current directory.

```shell
velero --kubeconfig=admin.conf backup download my-test-backup
```

## Restore

To restore a cluster data on demand, you should run the following `velero` command:

```shell
velero --kubeconfig=admin.conf restore create my-test-backup
```

This command assumes a previous backup was created with the same name.
