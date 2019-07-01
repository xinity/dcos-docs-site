---
layout: layout.pug
navigationTitle: Component Integrity
title: Checking Component Integrity
menuWeight: 1
excerpt: 
enterprise: false


---

**Konvoy** clusters have several compoints, and the `konvoy` CLI has a subcommand `konvoy check` for verifying the integrity of these components.

This document will cover the use of the `konvoy check` subcommand to help verify proper cluster operations.

## Check Preflight

The preflight checks can be useful for verifying the readiness of Linux servers for deployment of Kubernetes to them.

This can be triggered in the following manner:

```bash
$ ./konvoy check preflight
This process will take about 1 minutes to complete (additional time may be required for larger clusters), do you want to continue [y/n]: y

STAGE [Running Preflights]

PLAY [Check Machine Readiness] ***********************************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************************************
ok: [10.0.195.156]
ok: [10.0.128.10]

TASK [preflights : check memory swap is disabled] ****************************************************************************************************************************
ok: [10.0.195.156]
ok: [10.0.128.10]
<... other checks>
PLAY RECAP *******************************************************************************************************************************************************************
10.0.128.10                : ok=10   changed=0    unreachable=0    failed=0
10.0.195.156               : ok=9    changed=0    unreachable=0    failed=0
```

This can be particularly helpful when providing your own infrastructure for Kubernetes deployment via `konvoy deploy` to verify your hosts configuration, and the state of the hosts for deployment.

## Check Addons

**Konvoy** deploys several addon applications, which can be checked for integrity in the following manner:

```bash
$ ./konvoy check addons
This process will take about 1 minutes to complete (additional time may be required for larger clusters), do you want to continue [y/n]: y

STAGE [Checking Addons]
awsebscsidriver                                                        [OK]
calico                                                                 [OK]
helm                                                                   [OK]
awsebscsidriverstorageclassdefault                                     [OK]
traefik                                                                [OK]
velero                                                                 [OK]
```

This can be particularly helpful as a first step when trying to diagnose issues with addon components in the cluster to highlight addons which are encountering problems, as the output here will provide error information in the output here on failures.

## Check Kubernetes

The underlying Kubernetes control plane integrity can be checked in the following manner:

```bash
$ ./konvoy check kubernetes
This process will take about 1 minutes to complete (additional time may be required for larger clusters), do you want to continue [y/n]: y

STAGE [Checking Kubernetes]

PLAY [Check Control Plane Health] ********************************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************************************
ok: [10.0.195.156]
ok: [10.0.128.10]

TASK [check-kubernetes : calico health] **************************************************************************************************************************************
ok: [10.0.128.10 -> ec2-34-222-69-18.us-west-2.compute.amazonaws.com]
ok: [10.0.195.156 -> ec2-34-222-69-18.us-west-2.compute.amazonaws.com]

TASK [check-kubernetes : coredns health] *************************************************************************************************************************************
ok: [10.0.128.10 -> ec2-34-222-69-18.us-west-2.compute.amazonaws.com]

TASK [check-kubernetes : count number of nodes] ******************************************************************************************************************************
ok: [10.0.128.10 -> ec2-34-222-69-18.us-west-2.compute.amazonaws.com]

TASK [check-kubernetes : check nodes are Ready] ******************************************************************************************************************************
ok: [10.0.128.10 -> ec2-34-222-69-18.us-west-2.compute.amazonaws.com]

PLAY RECAP *******************************************************************************************************************************************************************
10.0.128.10                : ok=5    changed=0    unreachable=0    failed=0
10.0.195.156               : ok=2    changed=0    unreachable=0    failed=0
```

## Check Nodes

A variety of node checks can be run to ensure the nodes are in the right condition for Kubernetes operations:

```bash
$ ./konvoy check nodes
This process will take about 1 minutes to complete (additional time may be required for larger clusters), do you want to continue [y/n]: y

STAGE [Checking Nodes]

PLAY [Check Nodes] ***********************************************************************************************************************************************************

<... various check output>

TASK [check-nodes : kube-scheduler health] ***********************************************************************************************************************************
skipping: [10.0.128.10]
ok: [10.0.195.156]

PLAY RECAP *******************************************************************************************************************************************************************
10.0.128.10                : ok=12   changed=0    unreachable=0    failed=0
10.0.195.156               : ok=15   changed=0    unreachable=0    failed=0
```
