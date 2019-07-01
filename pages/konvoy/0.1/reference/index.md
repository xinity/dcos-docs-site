---
layout: layout.pug
navigationTitle: Reference
title: Reference Information
menuWeight: 80
excerpt: 
enterprise: false


---
# Reference

In customizing and defining a cluster, it is important to familiarize yourself with the `cluster.yaml` file.
The file is composed of two different configuration `kinds` (a `kind` is the name of a Kubernetes resource):

- `ClusterProvisioner` - Optional as it is dependant on provider and not required for on-prem cases.
- `ClusterConfiguration` - Mandatory as it specifies cluster specific details.

__NOTE:__ Although not the topic of discussion, the `inventory.yaml` file is required in addition to the `cluster.yaml` file.

An example of a `cluster.yaml` file is given below, and note that we are using `AWS` as our provisioner:

```bash
kind: ClusterProvisioner
apiVersion: konvoy.mesosphere.io/v1alpha1
metadata:
  name: konvoy-cluster
  creationTimestamp: "2019-06-08T03:25:24.2775264Z"
spec:
  provider: aws
  providerOptions:
    region: us-west-2
    availabilityZones:
    - us-west-2c
    tags:
      owner: konvoy-owner
  adminCIDRBlocks:
  - 0.0.0.0/0
  nodePools:
  - name: node
    count: 4
    machine:
      rootVolumeSize: 80
      rootVolumeType: gp2
      imagefsVolumeEnabled: true
      imagefsVolumeType: gp2
      imagefsVolumeSize: 160
      type: t3.xlarge
  - name: control-plane
    controlPlane: true
    count: 3
    machine:
      rootVolumeSize: 80
      rootVolumeType: gp2
      imagefsVolumeEnabled: true
      imagefsVolumeType: gp2
      imagefsVolumeSize: 160
      type: t3.large
  sshCredentials:
    user: centos
    publicKeyFile: konvoy-publicKey-ssh.pub
    privateKeyFile: konvoy-privateKey-ssh.pem
  version: v0.0.18
---
kind: ClusterConfiguration
apiVersion: konvoy.mesosphere.io/v1alpha1
metadata:
  name: alejandro
  creationTimestamp: "2019-06-08T03:25:20.939527Z"
spec:
  kubernetes:
    version: 1.14.3
    controlPlane:
      controlPlaneEndpointOverride: "172.17.0.100:6443"
    networking:
      podSubnet: 192.168.0.0/16
      serviceSubnet: 10.0.0.0/18
      httpProxy: 10.0.127.6:3128
      httpsProxy: 10.0.127.6:3128
      noProxy: []
    cloudProvider:
      provider: aws
    podSecurityPolicy:
      enabled: false
  containerRuntime:
    containerd:
      version: 1.2.5
  imageRegistries: []
  addons:
    configVersion: v0.0.16
    addonsList:
    - name: awsebscsidriver
      enabled: true
    - name: awsebscsidriverstorageclass
      enabled: false
    - name: awsebscsidriverstorageclassdefault
      enabled: true
    - name: awsstorageclass
      enabled: false
    - name: awsstorageclassdefault
      enabled: false
    - name: calico
      enabled: true
    - name: elasticsearchexporter
      enabled: true
    - name: helm
      enabled: true
    - name: opsportal
      enabled: true
    - name: prometheusadapter
      enabled: true
    - name: velero
      enabled: true
    - name: dashboard
      enabled: true
    - name: elasticsearch
      enabled: true
    - name: fluentbit
      enabled: true
    - name: kibana
      enabled: true
    - name: metallb
      enabled: false
    - name: prometheus
      enabled: true
    - name: traefik
      enabled: true
  version: v0.0.18
---
```

## ClusterProvisioner

| Parameter              | Description                                                             | Default       |
| ---------------------- | ----------------------------------------------------------------------- | ------------- |
| `spec.provider`        | defines the provider used to provision the cluster                      | `aws`         |
| `spec.providerOptions` | contains provider specific options                                      | `{ "region": "us-west-2", "availabilityZones": [ "us-west-2c" ], "tags": { "owner": "konvoy-owner" }}` |
| `spec.adminCIDRBlocks` | the [CIDR blocks](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_blocks) that defines IP addresses to access the cluster through [AWS Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html) for SSH and Kubernetes control plane external access | `[0.0.0.0/0]` |
| `spec.nodePools`       | a list of nodes to create, there must be at least one controlPlane pool | `[{"name": "worker", "count": 4, "machine": { "rootVolumeSize": 80, "rootVolumeType": "gp2", "type": "t3.xlarge" }}, { "name": "control-plane", "controlPlane": true, "count": 3, "machine": { "rootVolumeSize": 80, "rootVolumeType": "gp2", "type": "t3.large" }}]` |
| `spec.sshCredentials`  | contains credentials information for accessing machines in a cluster    | `{ "user": "centos", "publicKeyFile": "konvoy-publicKey-ssh.pub", "privateKeyFile": "konvoy-privateKey-ssh.pem" }` |
| `spec.version`         | version of a konvoy cluster                                             | `v0.0.18`     |

### spec.providerOptions

Properties of a `providerOptions` object.

#### AWS (provider)

| Parameter                                | Description                                                                                         | Default              |
| ---------------------------------------- | --------------------------------------------------------------------------------------------------- | -------------------- |
| `spec.providerOptions.region`            | [AWS region](https://docs.aws.amazon.com/general/latest/gr/rande.html) where your cluster is hosted |  `us-west-2`         |
| `spec.providerOptions.availabilityZones` | availability zones to deploy a cluster in a region                                                  | `[us-west-2c]`       |
| `spec.providerOptions.tags`              | additional [tags](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html) for the resources provisioned through the Konvoy CLI | `[owner: username]`  |

### spec.nodePool

| Parameter               | Description                                                                                   | Default   |
| ----------------------- | --------------------------------------------------------------------------------------------- | --------- |
| `nodePool.name`         | unique name that defines a node-pool                                                          | `""`      |
| `nodePool.controlPlane` | determines if a node-pool defines a Kubernetes Master node, only one such node-pool can exist | `false`   |
| `nodePool.count`        | defines the number of nodes in a node-pool                                                    | `0`       |
| `nodePool.machine`      | cloud-provider details about the machine types to use                                         | `{ "rootVolumeSize": 80, "rootVolumeType": "gp2", "type": "t3.xlarge" }` |

#### spec.nodePool.machine

Properties of a `nodePool.machine` object.

##### AWS (machine)

| Parameter                     | Description                                                                          | Default     |
| ----------------------------- | ------------------------------------------------------------------------------------ | ----------- |
| `machine.rootVolumeSize`      | size of root volume to use that is mounted on each machine in a node-pool in GiBs    | `80`        |
| `machine.rootVolumeType`      | [volume type](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html) to mount on each machine in a node-pool | `gp2`       |
|  machine.imagefsVolumeEnabled | whether to enable dedicated disk for image filesystem (i.e., `/var/lib/containerd`)  |  true       |
| `machine.imagefsVolumeSize`   | size of imagefs volume to use that is mounted on each machine in a node-pool in GiBs | `160`       |
| `machine.imagefsVolumeType`   | [volume type](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html) to mount on each machine in a node-pool | `gp2`       |

| `machine.type`           | [EC2 instance type](https://aws.amazon.com/ec2/instance-types/) to use       | `t3.xlarge` |

### spec.sshCredentials

| Parameter                       | Description                                                                   | Default               |
| ------------------------------- | ----------------------------------------------------------------------------- | --------------------- |
| `sshCredentials.user`           | username to use when accessing a machine via ssh                              | `centos`              |
| `sshCredentials.publicKeyFile`  | path and name of the public key file to use when accessing a machine via ssh  | `clustername`-ssh.pub |
| `sshCredentials.privateKeyFile` | path and name of the private key file to use when accessing a machine via ssh | `clustername`-ssh.pem |

## ClusterConfiguration

| Parameter               | Description                            | Default                                  |
| ----------------------- | -------------------------------------- | ---------------------------------------- |
| `spec.kubernetes`       | defines Kubernetes specific properties | `{ "version": "1.14.3", "controlPlane": { "controlPlaneEndpointOverride": "" }, "networking": { "podSubnet": "192.168.0.0/16", "serviceSubnet": "10.0.0.0/18" }` |
| `spec.containerRuntime` | container runtime to use               | `{ "containerd": { "version": "1.2.5" }` |
| `spec.imageRegistries`  | container image registries auth details | `{ "imageRegistries": []` |
| `spec.addons`           | list of addons that can be deployed    | `{ "configVersion": "v0.0.16", "addonsList": {[ { "name": "awsebscsidriver", "enabled": true }, { "name": "awsebscsidriverstorageclass", "enabled": false }, { "name": "awsebscsidriverstorageclassdefault", "enabled": true }, { "name": "awsstorageclass", "enabled": false }, { "name": "awsstorageclassdefault", "enabled": false }, { "name": "calico", "enabled": true }, { "name": "elasticsearchexporter", "enabled": true }, { "name": "helm", "enabled": true }, { "name": "opsportal", "enabled": true }, { "name": "prometheusadapter", "enabled": true }, { "name": "velero", "enabled": true }, { "name": "dashboard", "enabled": true }, { "name": "elasticsearch", "enabled": true }, { "name": "fluentbit", "enabled": true }, { "name": "kibana", "enabled": true }, { "name": "metallb", "enabled": false }, { "name": "prometheus", "enabled": true }, { "name": "traefik", "enabled": true }] }` |
| `spec.version`          | version of a konvoy cluster            | `v0.0.18`                                |

### spec.kubernetes

| Parameter                      | Description                                                 | Default                 |
| ------------------------------ | ----------------------------------------------------------- | ----------------------- |
| `kubernetes.version`           | version of kubernete to deploy                              | `1.14.3`                |
| `kubernetes.controlPlane`      | object that defines control plane configuration             | `{ "controlPlaneEndpointOverride": "" }` |
| `kubernetes.networking`        | object that defines cluster networking                      | `{ "podSubnet": "192.168.0.0/16", "serviceSubnet": "10.0.0.0/18" }` |
| `kubernetes.cloudProvider`     | object that defines which cloud-provider to enable          | `{ "provider": "aws" }` |
| `kubernetes.podSecurityPolicy` | object that defines whether to enable pod security policies | `{ "enabled": false }`  |

#### spec.kubernetes.controlPlane

| Parameter                                  | Description                                                    | Default  |
| ------------------------------------------ | -------------------------------------------------------------- | -------- |
| `controlPlane.controlPlaneEndpointOverride` | overrides the `control_plane_endpoint` from `inventory.yaml`  | `""`     |

#### spec.kubernetes.networking

| Parameter                  | Description                                                                      | Default          |
| -------------------------- | -------------------------------------------------------------------------------- | ---------------- |
| `networking.podSubnet`     | pod layer networking cidr                                                        | `192.168.0.0/16` |
| `networking.serviceSubnet` | service layer networking cidr                                                    | `10.0.0.0/18`    |
| `networking.httpProxy`     | address to the HTTP proxy to set `HTTP_PROXY` env variable during installation   | ``               |
| `networking.httpsProxy`    | address to the HTTPs proxy to set `HTTPS_PROXY` env variable during installation | ``               |
| `networking.noProxy   `    | list of addresses to pass to `NO_PROXY`, all node addresses, podSubnet, serviceSubnet, controlPlane endpoint and `127.0.0.1` and `localhost` are automatically set | `[]` |

#### spec.kubernetes.cloudProvider

| Parameter                | Description                               | Default |
| ------------------------ | ----------------------------------------- | ------- |
| `cloudProvider.provider` | define the provider for cloud services    | `aws`   |

#### spec.kubernetes.podSecurityPolicy

| Parameter                   | Description               | Default |
| --------------------------- | ------------------------- | ------- |
| `podSecurityPolicy.enabled` | enable podSecurity policy | `false` |

### spec.imageRegistries[]

| Parameter       | Description                                                             | Default    |
| --------------- | ----------------------------------------------------------------------- | ---------- |
| `server`        | the full address including `https://` or `http://` and an optional port | ``         |
| `username`      | registry username                                                       | ``         |
| `password`      | registry password, `username` must also be provided                     | ``         |
| `auth`          | base64 encoded `username:password`                                      | ``         |
| `identityToken` | used to authenticate the user and get an access token                   | ``         |


### spec.addons

| Parameter              | Description                                            | Default    |
| ---------------------- | ------------------------------------------------------ | ---------- |
| `addons.configVersion` | version of the addon configuration files to use        | `v0.0.16`  |
| `addons.addonsList`    | list of addon objects that can be deployed if enabled  | `[ { "name": "awsebscsidriver", "enabled": true }, { "name": "awsebscsidriverstorageclass", "enabled": false }, { "name": "awsebscsidriverstorageclassdefault", "enabled": true }, { "name": "awsstorageclass", "enabled": false }, { "name": "awsstorageclassdefault", "enabled": false }, { "name": "calico", "enabled": true }, { "name": "elasticsearchexporter", "enabled": true }, { "name": "helm", "enabled": true }, { "name": "opsportal", "enabled": true }, { "name": "prometheusadapter", "enabled": true }, { "name": "velero", "enabled": true }, { "name": "dashboard", "enabled": true }, { "name": "elasticsearch", "enabled": true }, { "name": "fluentbit", "enabled": true }, { "name": "kibana", "enabled": true }, { "name": "metallb", "enabled": false }, { "name": "prometheus", "enabled": true }, { "name": "traefik", "enabled": true }]` |

### addon

Properties of an `addon` object.

| Parameter | Description                                                   | Default |
| --------- | ------------------------------------------------------------- | ------- |
| `name`    | name of the addon that may deploy                             | `""`    |
| `enabled` | enable to deploy the addon                                    | `false` |
| `values`  | overrides to values found in default addon configuration file | `""`    |
