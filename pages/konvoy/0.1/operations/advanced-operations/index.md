---
layout: layout.pug
navigationTitle: Advanced Operations
title: Advanced Operations
menuWeight: 50
excerpt: 
enterprise: false


---

## Specifying Amazon Machine Image (AMI) identifiers for a region

In AWS, different regions use unique Amazon Machine Image (AMI) identifiers for the same operating system image.
Depending on your region and operating system, you may need to specify an image ID for the `ClusterProvisioner` setting before provisioning.

The regions and their corresponding AMI IDs that are already listed in the tool are, as follows:

```text
ap-south-1     = "ami-02e60be79e78fef21"
eu-west-3      = "ami-0e1ab783dc9489f34"
eu-west-2      = "ami-0eab3a90fc693af19"
eu-west-1      = "ami-0ff760d16d9497662"
ap-northeast-2 = "ami-06cf2a72dadf92410"
ap-northeast-1 = "ami-045f38c93733dd48d"
sa-east-1      = "ami-0b8d86d4bf91850af"
ca-central-1   = "ami-033e6106180a626d0"
ap-southeast-1 = "ami-0b4dd9d65556cac22"
ap-southeast-2 = "ami-08bd00d7713a39e7d"
eu-central-1   = "ami-04cf43aca3e6f3de3"
us-east-1      = "ami-02eac2c0129f6376b"
us-east-2      = "ami-0f2b4fc905b0bd1f1"
us-west-1      = "ami-074e2d6769f445be5"
us-west-2      = "ami-01ed306a12b7d1c96"
```

If deploying in a different region then you must specify a Centos 7 or RHEL 7 `imageID:`, as follows:

```yaml
kind: ClusterProvisioner
apiVersion: konvoy.mesosphere.io/v1alpha1
metadata:
  name: dkkonvoy201
  creationTimestamp: "2019-06-03T16:21:18.5149792Z"
spec:
  provider: aws
  providerOptions:
    region: __some_region__
    availabilityZones:
    - __some_region_az__
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
      imageID: __some_id__
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
      imageID: __some_id__
```

Konvoy is tested with the [CentOS Linux 7](https://aws.amazon.com/marketplace/pp/B00O7WM7QW) image.

## Adding Custom Terraform Resources When Provisioning

It is possible to provide custom `*.tf` resource files when provisioning.
The additional files will be used along with the default provided `*.tf` resource files.

First, create a file in `extras/provisioner/`.

```bash
mkdir -p extras/provisioner
# create a file with a custom backend
cat <<EOF > extras/provisioner/backend.tf
terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "kubernetes"
    region = "us-west-2"
  }
}
EOF
```

Any files in `extras/provisioner` are merged with the default provided `*.tf` resource files and used during provisioning.
If a filename from `extras/provisioner` already exists in the default `*.tf` resource files the contents will be replaced with the newly provided file.

Then run `./konvoy up`

The following is the Terraform output:

```text
Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.
```

This output indicates that the tool successfully picked up the additional `backend.tf` file and will store the state file in an S3 bucket.

## Addon Configuration

Most of the Addons in `cluster.yaml` are managed by [helm](https://Helm.sh).
You can modify the Helm values of these Addons, as shown below:

```yaml
kind: ClusterConfiguration
apiVersion: konvoy.mesosphere.io/v1alpha1
metadata:
  name: konvoy
  creationTimestamp: "2019-05-31T18:00:00.844964-04:00"
spec:
  kubernetes:
    version: 1.14.3
    networking:
      podSubnet: 192.168.0.0/16
      serviceSubnet: 10.0.0.0/18
    cloudProvider:
      provider: aws
    podSecurityPolicy:
      enabled: false
  containerRuntime:
    containerd:
      version: 1.2.5
  addons:
    configVersion: v0.0.11
    addonList:
    - name: velero
      enabled: false
    - name: calico
      enabled: true
    - name: helm
      enabled: true
    - name: awsstorageclass
      enabled: false
    - name: awsebscsidriver
      enabled: true
    - name: awsebscsidriverstorageclass
      enabled: true
    - name: opsportal
      enabled: true
    - name: elasticsearch
      enabled: true
    - name: fluentbit
      enabled: true
    - name: kibana
      enabled: true
    - name: prometheus
      enabled: true
      values: |
        prometheus:
          prometheusSpec:
            tolerations:
              - key: "dedicated"
                operator: "Equal"
                value: "monitoring"
                effect: "NoExecute"
            nodeSelector:
              dedicated: "monitoring"
            resources:
              limits:
                cpu: "4"
                memory: "28Gi"
              requests:
                cpu: "2"
                memory: "8Gi"
          storageSpec:
            volumeClaimTemplate:
              spec:
                resources:
                  requests:
                    storage: "100Gi"
    - name: traefik
      enabled: true
    - name: dashboard
      enabled: true
  version: v0.0.15-10-g57dff48
---
```

To find the proper keys and values, you must identify the associated Helm chart for each Addon in the [kubeaddons-configs][kubeaddons-configs_templates] repo.

For example, the `kibana` Addon points to [`stable/kibana@3.0.0`][helm_kibana] in [this file][kubeaddons-configs_kibana].

Addons like `prometheus` and `elasticsearch` may point to multiple Helm charts outside of the `kubeaddons-configs`.

## Taints

You can use [Addon Configuration](#addon-configuration) to configure and taint nodes.

1. `./konvoy init`
2. Disable `prometheus` by setting `prometheus`'s `enabled: false` in `cluster.yaml`
3. `./konvoy up`
4. Set the taint and label to the node as displayed in the following code sample:

    ```bash
    PROM_NODE=$(kubectl get nodes | grep ip | head -1 | cut -d " " -f 1)
    kubectl taint node $PROM_NODE dedicated=monitoring:NoExecute
    kubectl label node $PROM_NODE dedicated=monitoring
    ```

5. Enable Prometheus and set custom values like in the [Addon Configuration](#addon-configuration) section:

    ```yaml
      - name: prometheus
        enabled: true
        values: |
          prometheus:
            prometheusSpec:
              tolerations:
                - key: "dedicated"
                  operator: "Equal"
                  value: "monitoring"
                  effect: "NoExecute"
              nodeSelector:
                dedicated: "monitoring"
    ```

6. `./konvoy deploy kubeaddons`.

[kubeaddons-configs_templates]: https://github.com/mesosphere/kubeaddons-configs/tree/master/templates
[helm_kibana]: https://github.com/helm/charts/blob/bca1e989ee38cb95815760188e8aee4286b0df1c/stable/kibana/Chart.yaml#L2-L3
[kubeaddons-configs_kibana]: https://github.com/mesosphere/kubeaddons-configs/blob/65d7a7ae26d4bebd7035d713a5ea5db656ac2659/templates/kibana.yaml#L11-L12
