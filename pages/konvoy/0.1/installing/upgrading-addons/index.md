---
layout: layout.pug
navigationTitle: Upgrading Addons
title: Upgrading Addons
menuWeight: 1
excerpt: 
enterprise: false


---

Addons are managed by a library which pulls default configurations from [kubeaddons-configs](https://github.com/mesosphere/kubeaddons-configs).

Versioning is handled via [git tags](https://git-scm.com/book/en/v2/Git-Basics-Tagging) and [github releases](https://help.github.com/en/articles/creating-releases) within the repository.

Addons are deployed to the cluster as part of `konvoy deploy`, which uses the version of `kubeaddons-configs` declared in `cluster.yaml`'s `spec.addons.version`:

```yaml
kind: ClusterConfiguration
apiVersion: konvoy.mesosphere.io/v1alpha1
metadata:
  name: konvoy_v0.0.19
spec:
  addons:
    version: v0.0.20
```

You can edit this version to deploy a different version of addons to your cluster, and then update with:

```bash
konvoy deploy
```
