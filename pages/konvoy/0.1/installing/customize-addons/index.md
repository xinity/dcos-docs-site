---
layout: layout.pug
navigationTitle: Customize Addons
title: Customize Addons
menuWeight: 1
excerpt: 
enterprise: false


---

One of the resulting files from the [Basic AWS Install][basics_aws] is an `cluster.yaml` file, which includes the Cluster Provisioning Configuration
(in `ClusterProvisioner`, explained in the [previous section][cluster_provision]) and the `ClusterConfiguration` below:

```yaml
kind: ClusterConfiguration
apiVersion: konvoy.mesosphere.io/v1alpha1
metadata:
  name: konvoy
  creationTimestamp: "2019-06-12T21:55:20.991926-04:00"
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
    configVersion: v0.0.17
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
  version: v0.0.19
```

This file is formatted in [YAML][yaml] to specify a custom resource in Kubernetes.

Please see the [`cluster.yaml` Reference][cluster_file] for details.

Specific to addons, you can enable or disable a single addon with the `enabled` property.
You can also customize the addon with the `values` property. To find the proper keys and values for `values`,
you will have to identify the associated Helm chart for each addon in the [kubeaddons-configs][kubeaddons-configs_templates] repository.

For example, the `kibana` addon points to [`stable/kibana@3.0.0`][helm_kibana] in [this file][kubeaddons-configs_kibana].

Addons like `prometheus` and `elasticsearch` may point to multiple Helm charts outside of the `kubeaddons-configs` repository.

[basics_aws]: ./basics_aws.md
[cluster_provision]: ./cluster_provision.md
[cluster_file]: ../reference.md
[yaml]: https://en.wikipedia.org/wiki/YAML
[kubeaddons-configs_templates]: https://github.com/mesosphere/kubeaddons-configs/tree/master/templates
[helm_kibana]: https://github.com/helm/charts/blob/bca1e989ee38cb95815760188e8aee4286b0df1c/stable/kibana/Chart.yaml#L2-L3
[kubeaddons-configs_kibana]: https://github.com/mesosphere/kubeaddons-configs/blob/65d7a7ae26d4bebd7035d713a5ea5db656ac2659/templates/kibana.yaml#L11-L12
