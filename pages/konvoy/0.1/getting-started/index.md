---
layout: layout.pug
navigationTitle:  Konvoy Quickstart
title: Getting Started with Konvoy
menuWeight: 20
excerpt: A quick install method to experience Konvoy
enterprise: false


---

Konvoy is a tool for provisioning pure Kubernetes clusters without an underpinning DC/OS cluster. The Konvoy cluster includes a suite of [Cloud Native Computing Foundation (CNCF)](https://www.cncf.io) and community-contributed tools that, deployed together, provide a complete _out-of-the-box_ experience of production-ready Kubernetes.

The quick start guide describes the following tasks:

- [1. Usage](#1-Usage)
  - [1.1. Prerequisites](#11-Prerequisites)
  - [1.2. Before you begin](#12-Before-you-begin)
  - [1.3. Download the Konvoy package](#13-Download-the-Konvoy-package)
  - [1.4. Provision and deploy the cluster and Addons](#14-Provision-and-deploy-the-cluster-and-Addons)
  - [1.5. Connecting to the operations portal](#15-Connecting-to-the-operations-portal)
  - [1.6. Merge the kubeconfig](#16-Merge-the-kubeconfig)
    - [1.6.1. Alternative kubeconfig locations](#161-Alternative-kubeconfig-locations)
  - [1.7. Deploy a sample application](#17-Deploy-a-sample-application)
    - [1.7.1. Deploy the Redis master pods & service](#171-Deploy-the-Redis-master-pods--service)
    - [1.7.2. Deploy the Redis agents](#172-Deploy-the-Redis-agents)
    - [1.7.3. Deploy the webapp frontend](#173-Deploy-the-webapp-frontend)
    - [1.7.4. Deploy the load-balancer](#174-Deploy-the-load-balancer)
    - [1.7.5. Check the deployed service](#175-Check-the-deployed-service)
    - [1.7.6. Remove the sample app](#176-Remove-the-sample-app)
  - [1.8. Tearing down the cluster](#18-Tearing-down-the-cluster)
  - [1.9. Provisioning a customized cluster](#19-Provisioning-a-customized-cluster)
    - [1.9.1. Generate the configuration files](#191-Generate-the-configuration-files)
    - [1.9.2. Edit the provisioner configuration file in `cluster.yaml`, to suit](#192-Edit-the-provisioner-configuration-file-in-clusteryaml-to-suit)
    - [1.9.3. Provision the cluster](#193-Provision-the-cluster)
- [2. Cluster diagnostics](#2-Cluster-diagnostics)
  - [2.1. Check Kubernetes](#21-Check-Kubernetes)
  - [2.2. Check nodes](#22-Check-nodes)
  - [2.3. Check Addons](#23-Check-Addons)
- [3. Advanced Usage](#3-Advanced-Usage)
- [4. Troubleshooting](#4-Troubleshooting)
  - [4.1. Terraform hangs immediately when I start provisioning](#41-Terraform-hangs-immediately-when-I-start-provisioning)
  - [4.2. Some hosts are unreachable during deployment, after provisioning](#42-Some-hosts-are-unreachable-during-deployment-after-provisioning)

## 1. Usage

### 1.1. Prerequisites

Currently, all the runtime dependencies of Konvoy are bundled in a Docker container. The Konvoy runtime dependencies include Terraform, Ansible, Kubectl, and Helm. Each release of Konvoy is accompanied by a wrapper that correctly executes the container.

**Note:** This may not be a permanent release architecture.

**The prerequisites for installing Konvoy are as follows:**

* A valid AWS account with [credentials configured][aws_credentials]
* The [aws][install_aws] command line utility
* [Docker][install_docker]
* [kubectl][install_kubectl] _v1.14.3 or newer_ (for interacting with the running cluster)

### 1.2. Before you begin

1. Verify the version of `kubectl` you have is supported by running `kubectl version --short=true`. Many important functions of Kubernetes will _not work_ if your client is outdated.
2. Install the prerequisites using your preferred package manager. On Mac, this is easy with [Homebrew](https://brew.sh/). For example:

```bash
## bash and homebrew already installed.
brew install kubernetes-cli kubernetes-helm docker awscli
```

### 1.3. Download the Konvoy package

You start the installation process by downloading the Konvoy package tarball.
To download the package, follow these steps:

1. Reach out to your account representative or [konvoy-beta@mesosphere.com](mailto:konvoy-beta@mesosphere.com) to get the latest beta release of Konvoy.
1. Download the tarball to your Downloads directory, (assumed as ~/Downloads).
1. Extract the tarball to your local system.

    ```bash
    tar -xf ~/Downloads/konvoy_v0.0.15.tar.bz2
    cd ~/Downloads/konvoy_v0.0.15
    ```

1. Optionally you can add bash autocompletion for `konvoy`

    ```bash
    source <(./konvoy completion bash)
    ```

### 1.4. Provision and deploy the cluster and Addons

You must have *valid AWS security credentials* to deploy the cluster.

To deploy using all of the default settings, you should run this all-in-one command:

```bash
./konvoy up
```

The `./konvoy up` command performs the following tasks:

* Provisions three control plane machines of `t3.large` (a highly-available control-plane API)
* Provisions four worker machines of `t3.xlarge` on AWS
* Deploys all of the following default Addons:
  * CoreDNS
  * Velero
  * Calico
  * Helm
  * AWS CSI Driver
  * AWS CSI Driver Storage Class
  * OpsPortal
  * Elasticsearch (and Elasticsearch Exporter)
  * Fluentbit
  * Kibana
  * Prometheus (and Prometheus Adapter)
  * Traefik
  * Kubernetes Dashboard

The `./konvoy up` command produces **a verbose stream of output** from Terraform and Ansible operations.

You will see the following when the deployment succeeds:

```text
Kubernetes cluster and addons deployed successfully!

Run `konvoy apply kubeconfig` to update kubectl credentials.

Navigate to the URL below to access various services running in the cluster.
  https://lb_addr-12345.us-west-2.elb.amazonaws.com/ops/portal
And login using the credentials below.
  Username: AUTO_GENERATED_USERNAME
  Password: SOME_AUTO_GENERATED_PASSWORD_12345

The dashboard and services may take a few minutes to be accessible.
```

This information is important for future access to the operations portal and associated dashboards.
Copy this text and store it in a text file somewhere in a secured, shared file store.

### 1.5. Connecting to the operations portal

Unless you manually disable it, the default deployment includes an _operations portal_ that links to several dashboards of the installed services, including Grafana (metrics), Kibana (logs), Traefik (HTTP ingress), and the Kubernetes Dashboard.

Use the link provided in the deployment output to access the cluster's dashboards using the operations portal. For example,
navigate to the URL you copied from the deployment output (`https://lb_addr-12345.us-west-2.elb.amazonaws.com/ops/portal`) and log in using the automatically-generated credentials.

By default, the login credentials use self-signed SSL/TLS certificates. It is possible to override Traefik [chart values](https://github.com/helm/charts/tree/master/stable/traefik#configuration) to use your own certificates or to use the ACME protocol to use certificates issued by Let's Encrypt if you provide your own domain.

After you log in to the operations portal, you can [perform some diagnostics](#2-cluster-diagnostics);.

**Note:** Logging in to the operations portal are running diagnostics is optional. The Addons installation would fail if the Kubernetes cluster were not suitably functional already.

See also: [Provisioning a Customized Cluster](#1-9-provisioning-a-customized-cluster).

### 1.6. Merge the kubeconfig

Once the cluster is provisioned and functional, before using `kubectl` to interact with it, you probably want to store its access configuration in your main `kubeconfig` file.

This access configuration contains certificate credentials and the API server endpoint for accessing the cluster. The
`konvoy` cluster stores this information internally as `admin.conf`, but you may want to merge it into your "home" `kubeconfig`, so you can access the cluster from other working directories on your machine.

To merge the access configuration, use the following command:

```bash
./konvoy apply kubeconfig
```

By default, this will rely on the environment variable `KUBECONFIG` to declare the path to the correct file.
When absent, it defaults to `~/.kube/config`.

To validate this, you should be able to list nodes in the Kubernetes cluster, using the following command:

```bash
$ kubectl get nodes

NAME                                         STATUS   ROLES    AGE   VERSION
ip-10-0-129-3.us-west-2.compute.internal     Ready    <none>   24m   v1.14.3
ip-10-0-131-215.us-west-2.compute.internal   Ready    <none>   24m   v1.14.3
ip-10-0-131-239.us-west-2.compute.internal   Ready    <none>   24m   v1.14.3
ip-10-0-131-24.us-west-2.compute.internal    Ready    <none>   24m   v1.14.3
ip-10-0-192-174.us-west-2.compute.internal   Ready    master   25m   v1.14.3
ip-10-0-194-137.us-west-2.compute.internal   Ready    master   26m   v1.14.3
ip-10-0-195-215.us-west-2.compute.internal   Ready    master   26m   v1.14.3
```

#### 1.6.1. Alternative kubeconfig locations

You can override the default Kubernetes configuration path by first specifying an alternate path:

```bash
export KUBECONFIG="${HOME}/.kube/konvoy.conf"
./konvoy apply kubeconfig
```

Alternatively, you can set `KUBECONFIG` to the path of the current config file created and used within `konvoy`:

```bash
export KUBECONFIG="${PWD}/admin.conf"
```

### 1.7. Deploy a sample application

**Note:** This step is **optional**, and is not relevant for production deployments.

The following is a condensed form of the [Kubernetes sample guestbook application][guestbook].

#### 1.7.1. Deploy the Redis master pods & service

```bash
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml
```

#### 1.7.2. Deploy the Redis agents

```bash
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-deployment.yaml
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-service.yaml
```

#### 1.7.3. Deploy the webapp frontend

```bash
kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml
```

#### 1.7.4. Deploy the load-balancer

This step has been modified to specifically deploy a cloud `LoadBalancer`, instead of a `NodePort` service.

```bash
curl -L https://k8s.io/examples/application/guestbook/frontend-service.yaml | sed "s@NodePort@LoadBalancer@" | kubectl apply -f -
```

#### 1.7.5. Check the deployed service

```bash
kubectl get pods -l app=guestbook -l tier=frontend  # check the app pods
kubectl get service frontend                        # check the load balancer
```

The service properties will provide the name of the load-balancer; you will reach the application by accessing that load balancer address in your web browser.

**Note:**

* The sample deployments create a cloud load balancer. Creating the load balancer can take a few minutes to get running properly, due to DNS propagation and synchronization.
* Because the cloud provider will then have a load balancer linked to the cluster, you *must* delete the sample `Service` you created before tearing down the cluster.

#### 1.7.6. Remove the sample app

```bash
kubectl delete service frontend
kubectl delete service redis-master
kubectl delete service redis-slave
kubectl delete deployment frontend
kubectl delete deployment redis-master
kubectl delete deployment redis-slave
```

### 1.8. Tearing down the cluster

Use the following command to destroy the Kubernetes cluster and the infrastructure it's running on:

```bash
./konvoy down
```

### 1.9. Provisioning a customized cluster

#### 1.9.1. Generate the configuration files

```bash
./konvoy init --provisioner=aws
```

#### 1.9.2. Edit the provisioner configuration file in `cluster.yaml`, to suit

You can edit the cluster configuration settings to suit your needs. For instance, you can change the node count or add custom tags to all resources created by the installer by modifying the corresponding settings in the `cluster.yaml` file  `ClusterProvisioner` section.

```yaml
kind: ClusterProvisioner
apiVersion: konvoy.mesosphere.io/v1alpha1
metadata:
  name: konvoy
  creationTimestamp: "2019-05-31T18:00:01.482791-04:00"
spec:
  provider: aws
  providerOptions:
    region: us-west-2
    availabilityZones:
    - us-west-2c
    tags:
      owner: hector
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
    publicKeyFile: konvoy-ssh.pub
    privateKeyFile: konvoy-ssh.pem
  version: v0.0.15-10-g57dff48

---
```

* Refer to the `nodePools` section in the above code, to configure the nodes of your cluster, including the type and number of nodes.
* Refer to the `tags` section in the above code, to extend the lifetime of your cluster. This may be useful if your AWS administrator has set up some out-of-band cloud resources cleaning job based on AWS resource tags.

For example:

```yaml
### needs both tags
tags:
  owner: hector
  expiration: 24h
```

In the `ClusterConfiguration` section of `cluster.yaml`,  you can also change which Addons to enable/disable.

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
      enabled: true
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
    - name: traefik
      enabled: true
    - name: dashboard
      enabled: true
  version: v0.0.15-10-g57dff48

---
```

#### 1.9.3. Provision the cluster

```bash
./konvoy up
```

The cluster will be provisioned, similar to the default section above [Provision and deploy the cluster and Addons](#1-4-provision-and-deploy-the-cluster-and-addons).

## 2. Cluster diagnostics

### 2.1. Check Kubernetes

After your cluster is running, you can perform some diagnostics on the Kubernetes cluster:

```bash
./konvoy check kubernetes
```

This command validates a wide variety of components, including the following:

* The `api-server` is running and responsive
* The scheduler components are running
* The container manager is running

The command generates a lot of output from Ansible. A sample of the output, with a successful run, will end like this:

```text
PLAY RECAP ****************************************************************
10.0.2.144                 : ok=4    changed=0    unreachable=0    failed=0
10.0.2.162                 : ok=4    changed=0    unreachable=0    failed=0
10.0.2.223                 : ok=4    changed=0    unreachable=0    failed=0
10.0.2.56                  : ok=4    changed=0    unreachable=0    failed=0
10.0.2.57                  : ok=4    changed=0    unreachable=0    failed=0
10.0.2.94                  : ok=4    changed=0    unreachable=0    failed=0
10.0.3.5                   : ok=8    changed=0    unreachable=0    failed=0
10.0.3.70                  : ok=11   changed=0    unreachable=0    failed=0
10.0.3.91                  : ok=8    changed=0    unreachable=0    failed=0
```

### 2.2. Check nodes

```bash
./konvoy check nodes
```

This command performs a variety of health checks and prerequisite verifications on each node in the cluster. It also reports any failing nodes.

Verification criteria:

* Machine is reachable by SSH
* Machines's swap is disabled
* Machine has all necessary binaries present (e.g. kubelet, kubeadm)
* Kubelet considers the node healthy
* API server is running on the machine (control-plane only)
* Scheduler is running on the machine (control-plane only)
* Controller manager is running on the machine (control-plane only)

### 2.3. Check Addons

```bash
./konvoy check addons
```

This command checks that the addons exist, and are configured according to the defaults or to the configuration specified in the `cluster.yaml` file.

## 3. Advanced Usage

For more information on advanced use cases, refer to [Advanced Usage documentation](./advanced.md), which includes Addon configurations, node taints, and provisioning options.

## 4. Troubleshooting

In general, Konvoy is designed to be _idempotent_, which means you can run the tools multiple times to achieve the same desired configuration under most conditions. This capability enables Konvoy to be resilient in recovering from transient errors.

To see other commands available in `konvoy`, you can run `./konvoy` (with no commands) or `./konvoy <command> --help`.

### 4.1. Terraform hangs immediately when I start provisioning

This issue usually indicates that your AWS credentials are either invalid or your session has expired.

**Note:** Many provisioning steps *require valid AWS security credentials*.

### 4.2. Some hosts are unreachable during deployment, after provisioning

This issue is particularly prevalent when dealing with large clusters, as Ansible will be interacting with all of them in rapid succession. Likely, the cloud providers' networking is rate-limiting the interaction with so many host instances. This behavior can cause Ansible to fail part-way through. Generally, you can just re-try the same command, and Ansible will attempt to pick up where it left off.

[aws_credentials]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html
[install_aws]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
[install_docker]: https://docs.docker.com/install/
[install_kubectl]: https://kubernetes.io/docs/tasks/tools/install-kubectl/
[guestbook]: https://kubernetes.io/docs/tutorials/stateless-application/guestbook/
