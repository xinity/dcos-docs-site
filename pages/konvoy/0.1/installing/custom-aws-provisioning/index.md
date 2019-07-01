---
layout: layout.pug
navigationTitle: Custom AWS Provisioning
title: Custom AWS Provisioning
menuWeight: 1
excerpt: 
enterprise: false


---

One of the resulting files from the [Basic AWS Install][basics_aws] is an `cluster.yaml` file, which includes the Addon Configuration
(in `ClusterConfiguration`, explained in the [next section][addons_config]) and the `ClusterProvisioner` below:

```yaml
kind: ClusterProvisioner
apiVersion: konvoy.mesosphere.io/v1alpha1
metadata:
  name: konvoy
  creationTimestamp: "2019-06-07T18:41:44.926993-04:00"
spec:
  provider: aws
  providerOptions:
    region: us-west-2
    availabilityZones:
    - us-west-2c
    tags:
      owner: the-owner-name
  adminCIDRBlocks:
  - 0.0.0.0/0
  nodePools:
  - name: control-plane
    controlPlane: true
    count: 3
    machine:
      type: t3.large
      rootVolumeType: gp2
      rootVolumeSize: 80
      imagefsVolumeEnabled: true
      imagefsVolumeType: gp2
      imagefsVolumeSize: 160
  - name: node
    count: 4
    machine:
      type: t3.xlarge
      rootVolumeType: gp2
      rootVolumeSize: 80
      imagefsVolumeEnabled: true
      imagefsVolumeType: gp2
      imagefsVolumeSize: 160
  sshCredentials:
    user: centos
    publicKeyFile: konvoy-ssh.pub
    privateKeyFile: konvoy-ssh.pem
  version: v0.0.17
```

This file is formatted in [YAML][yaml] to specify a custom resource in Kubernetes.

Please see the [`cluster.yaml` Reference][cluster_file] for details.

We recommend having `count` as an odd number when `controlPlane: true` as it will [help keep `etcd` consistent][etcd_consistent].
`count: 3` is "highly available" to protect against failures. Otherwise, feel free to configure your cluster
to your needs.

[cluster_file]: ../reference.md
[basics_aws]: ./basics_aws.md
[addons_config]: ./customize_addons.md
[yaml]: https://en.wikipedia.org/wiki/YAML
[etcd_consistent]: https://blog.containership.io/etcd/
