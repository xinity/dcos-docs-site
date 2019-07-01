---
layout: layout.pug
navigationTitle: Cluster Teardown
title: Cluster Teardown
menuWeight: 1
excerpt: 
enterprise: false


---

After a cluster has been deployed with the `konvoy up` command, the `konvoy down` command can be used to tear down the cluster.

The `konvoy down` command must be run with the state files created when you deployed the cluster using the `konvoy up` command. By default, the state files are created in a subdirectory specifically for containing the state files associated with your cluster (for example,  `cd ~/Clusters/KonvoyCluster1/ && konvoy up`, or `cd ~/Clusters/KonvoyCluster2/ && konvoy provision`).

Before running the `konvoy down` command for any cluster, you should note that this action is **destructive and may result in downtime and dataloss if used incorrectly**.

## Default

When running `konvoy up`, AWS resources are created through [Terraform][terraform].
Once the Kubernetes cluster is running, Kubernetes can create additional resources such as load balancers, security groups and Volumes, which map to your Kubernetes resources.

By default, all AWS infrastructure for the cluster **except Volumes created by Kubernetes** will remain.
To clear your cluster's resources, from the directory that contains your cluster state, run the following command:

**NOTE:** To find the Volumes created by Kubernetes, keep reading before running the command.

```bash
konvoy down
```

This command prompts you with a time estimate for completing the operation. You can respond by typing `Y` to proceed.

Konvoy will begin by deleting load balancers and security groups through the AWS API. This will ensure they are deleted quickly.
After, we use Terraform to delete the resources created by Terraform in `konvoy up`.

Before running `konvoy down`, you can find these Volumes by listing the the Persistent Volumes though `kubectl`:

```bash
kubectl get persistentvolumes -o custom-columns=NAME:.metadata.name,STORAGECLASS:.spec.storageClassName

# Output:
# NAME                                       STORAGECLASS
# pvc-024e0dfc-8e09-11e9-92cb-0a859d0d78a0   ebs-csi-driver
# pvc-1d54359a-8e09-11e9-92cb-0a859d0d78a0   ebs-csi-driver
# pvc-1ecacd60-8e09-11e9-92cb-0a859d0d78a0   ebs-csi-driver
# pvc-3bfee13e-8e09-11e9-92cb-0a859d0d78a0   ebs-csi-driver
# pvc-f6e08b63-8e08-11e9-92cb-0a859d0d78a0   ebs-csi-driver
# pvc-f6eb2786-8e08-11e9-92cb-0a859d0d78a0   ebs-csi-driver
# pvc-f951b4aa-8e08-11e9-a615-0ae6f30d517a   ebs-csi-driver
```

The Volumes should be tagged with `CSIVolumeName: VOLUME_NAME`. With the `aws-cli`, you can find one of the volumes via:

```bash
aws ec2 describe-volumes --filters "Name=tag:CSIVolumeName,Values=pvc-024e0dfc-8e09-11e9-92cb-0a859d0d78a0"

# Output:
# {
#   "Volumes": [
#     {
#       "Attachments": [
#         {
#           "AttachTime": "2019-06-13T18:28:23.000Z",
#           "Device": "/dev/xvdct",
#           "InstanceId": "i-0ece8ecd51efa694a",
#           "State": "attached",
#           "VolumeId": "vol-09f0cc1e780856883",
#           "DeleteOnTermination": false
#         }
#       ],
#       "AvailabilityZone": "us-west-2c",
#       "CreateTime": "2019-06-13T18:28:15.915Z",
#       "Encrypted": false,
#       "Size": 50,
#       "SnapshotId": "",
#       "State": "in-use",
#       "VolumeId": "vol-09f0cc1e780856883",
#       "Iops": 150,
#       "Tags": [
#         {
#           "Key": "CSIVolumeName",
#           "Value": "pvc-024e0dfc-8e09-11e9-92cb-0a859d0d78a0"
#         }
#       ],
#       "VolumeType": "gp2"
#     }
#   ]
# }
```

And delete them if necessary.

## Skipping Kubernetes cleanup

To skip deleting resources created by Kubernetes, run:

```bash
konvoy down --skip-clean-kubernetes
```

## Cleaning up failed teardown operations

If a failure occurs during a teardown operation, it is possible for some cluster data or infrastructure components to be left behind.

For example, if the **konvoy** cluster is deployed on AWS, an unsuccessful or incomplete teardown operation can potentially leave behind the following cluster components:

* Load balancers
* EBS storage volumes
* EC2 instances
* Key pairs
* Security groups
* Identity and access management (IAM) roles
* VPC and related networks

If you encounter this issue, you should try re-running the teardown command. If the failure was caused by a temporary condition, re-running the command might resolve the issue. If the failure persists, destroying the cluster might require manual intervention. For example, you might need to manually remove cluster artifacts to return to a clean state.

If a persistent failure occurs during clean-up operations, you should report the failure as an issue in the **konvoy** repository so that testing and automation can be added to address the failure and the problem can be mitigated by removing resources with your provider's API.

If you need to manually remove cluster resources, resources created by Terraform can be located by searching for the `name` in the `cluster.yaml` file,
as many resources are named `<CLUSTER_NAME><4 character hash>-resouce-name` (ex. `cluster_name143a-worker-0`).
Resources are also tagged with `konvoy/clusterName: CLUSTER_NAME` and `ClusterProvisioner.spec.providerOptions.tags` in the `cluster.yaml` file.

Formats for resources created by Kubernetes can vary greatly, but a useful tag is `kubernetes.io/cluster/cluster_name` (ex. `kubernetes.io/cluster/konvoy143a`).

Also, the following resources contain useful information for AWS-based deployments in particular:

* [Deleting Load Balancers][0]
* [Deleting EBS Storage Volumes][1]
* [Deleting EC2 Instances][2]

**NOTE:** Proceed cautiously when removing components manually.
These actions can lead to unexpected downtime and data loss.

[0]:https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-delete.html
[1]:https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-deleting-volume.html
[2]:https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html
[terraform]: https://www.terraform.io
