---
layout: layout.pug
navigationTitle: Quick start
title: Quick start
menuWeight: 2
excerpt: Get started by installing a cluster with default configuration settings
enterprise: false
---
Konvoy is a tool for provisioning Kubernetes clusters with a suite of pre-selected [Cloud Native Computing Foundation (CNCF)](https://www.cncf.io) and community-contributed tools.
By combining a native Kubernetes cluster as its foundation with a default set of cluster extensions, Konvoy provides a complete _out-of-the-box_ solution for organizations that want to deploy production-ready Kubernetes.

This quick start guide provides simplified instructions to get your Konvoy cluster up and running with minimal configuration requirements.

This guide covers the following tasks and topics:

* [Prepare for installation](#prepare-for-installation)
* [Download and install the Konvoy package](#download-and-install-the-konvoy-package)
* [Provision and deploy the cluster and addons](#provision-and-deploy-the-cluster-and-addons)
* [Review deployment output and login information](#review-deployment-output-and-login-information)
* [Connect to the operations portal](#connect-to-the-operations-portal)
* [Merge the kubeconfig](#merge-the-kubeconfig)
  * [Specify the kubeconfig location](#specify-the-kubeconfig-location)
  * [Validate a merged configuration](#validate-a-merged-configuration)
* [Deploy a sample application](#deploy-a-sample-application)
* [Provision a customized cluster](#provision-a-customized-cluster)
* [Generate cluster diagnostics](#generate-cluster-diagnostics)
* [Troubleshooting](#troubleshooting)

## Prepare for installation

Currently, all the runtime dependencies for Konvoy are bundled in a Docker container.
The Konvoy runtime dependencies include:
* Terraform
* Ansible
* Kubectl
* Helm

Each release of Konvoy is accompanied by a wrapper that executes the container and manages these dependencies.

### Before you begin

Before starting the Konvoy installation, you should verify the following:

* You have a valid AWS account with [credentials configured][aws_credentials] if you are installing on an AWS cloud instance.

* You have the [aws][install_aws] command-line utility if you are installing on an AWS cloud instance.

* You have [Docker Desktop][install_docker] _version 18.09.2 or newer_.

* You have [kubectl][install_kubectl] _v1.15.0 or newer_ for interacting with the running cluster.

In most cases, you can install the required software using your preferred package manager.
For example, on a macOS computer, you can use [Homebrew](https://brew.sh/) to install `kubectl` and the `aws` command-line utility by running the following command:

```bash
brew install kubernetes-cli awscli
```

Keep in mind that many important functions of Kubernetes _do not work_ if your client is outdated.
You can verify the version of `kubectl` you have installed is supported by running the following command:

```bash
kubectl version --short=true`
```

### Download and install the Konvoy package

You start the installation process by downloading the Konvoy package tarball.

To download the package, follow these steps:

1. Contact your account representative or [konvoy-beta@mesosphere.com](mailto:konvoy-beta@mesosphere.com) to get the latest release of Konvoy.

1. Download the tarball to your local Downloads directory.

    For example, if you are installing on macOS, download the compressed archive to the default `~/Downloads` directory.

1. Extract the tarball to your local system by running the following command:

    ```bash
    tar -xf ~/Downloads/konvoy_v0.0.15.tar.bz2
    cd ~/Downloads/konvoy_v0.0.15
    ```

1. Copy Konvoy package files to a directory in your user PATH to ensure you can invoke the `konvoy` command from any directory.

    For example, copy the package to the `/usr/local/bin/` directory by running the following command:

    ```bash
    sudo cp ~/Downloads/konvoy_v0.0.15/* /usr/local/bin/
    ```

1. Optionally, add `bash` autocompletion for `konvoy` by running the following command:

    ```bash
    source <(konvoy completion bash)
    ```

### Provision and deploy the cluster and addons

1. Verify you have valid **AWS security credentials** to deploy the cluster on AWS.

    This step is not required if you are installing Konvoy on an internal network.
    For information about installing onsite, see [Basic on-premise install]((./install-uninstall-upgrade/basic_onprem.md)).

1. Create a directory for storing state information for your cluster by running the following commands:

    ```bash
    mkdir konvoy-quickstart
    cd konvoy-quickstart
    ```

    This directory for state information is required for performing future operations on your cluster.
    For example, state files stored in this directory are required to tear down a cluster.
    If you were to delete the state information or this directory, destroying the cluster would require you to manually perform clean-up tasks.

1. Deploy with all of the default settings and addons by running the following command:

    ```bash
    konvoy up
    ```

The `konvoy up` command performs the following tasks:

* Provisions three control plane machines of `t3.large` (a highly-available control-plane API).
* Provisions four worker machines of `t3.xlarge` on AWS.
* Deploys all of the following default addons:
  * [Velero](https://velero.io/) to back up and restore Kubernetes cluster resources and persistent volumes.
  * [Calico](https://www.projectcalico.org/) to provide policy-driven, perimeter network security.
  * [Helm](https://helm.sh/) to help you manage Kubernetes applications and application lifecycles.
  * [AWS Container Storage Interface (CSI) driver](https://github.com/kubernetes-sigs/aws-ebs-csi-driver) and CSI driver storage class to support persistent storage for container orchestrators.
  * Operations portal to centralize access to addon dashboards.
  * [Elasticsearch](https://www.elastic.co/products/elastic-stack) and [Elasticsearch exporter](https://www.elastic.co/guide/en/elasticsearch/reference/7.2/es-monitoring-exporters.html) to enable scalable, high-performance search engine capabilities.
  * [Kibana](	www.elastic.co/products/kibana) to support data visualization for content indexed by Elasticsearch.
  * [Fluent Bit](https://fluentbit.io/) to collect and collate logs from different sources and send logged messages to multiple destinations.
  * [Prometheus](https://prometheus.io/) to collect and evaluate metrics for monitoring and alerting based on time series data and [Prometheus adapter](https://github.com/DirectXMan12/k8s-prometheus-adapter) to support collecting and querying custom metrics.
  * [Traefik](https://traefik.io/) to route network traffic as a reverse proxy and load balancer.
  * [Kubernetes dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/) to provide a general-purpose web-based user interface for Kubernetes clusters.

### Review deployment output and login information
The `konvoy up` command produces **a verbose stream of output** from Terraform and Ansible operations.

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

You should copy the cluster URL and login information and paste it into a text file, then save the file in a secured, shared location on your network. You can then use this information to access the operations portal and associated dashboards.

### Connect to the operations portal
Unless you manually disable it, the default deployment includes an _operations portal_ that links to several dashboards of the installed services, including:
* Grafana dashboards for metrics
* Kibana dashboardsfor logs
* Traefik dashboards for inbound HTTP traffic
* Kubernetes dashboard for cluster activity

Use the link provided in the deployment output to access the cluster's dashboards using the **operations portal**.
For example, navigate to the URL you copied from the deployment output (`https://lb_addr-12345.us-west-2.elb.amazonaws.com/ops/portal`) and log in using the automatically-generated credentials.

By default, the login credentials use self-signed SSL/TLS certificates.
It is possible to override Traefik [chart values](https://github.com/helm/charts/tree/master/stable/traefik#configuration) to use your own certificates or to use the ACME protocol to use certificates issued by Let's Encrypt if you provide your own domain.

After you log in to the operations portal, you can collect[diagnostic information](#cluster-diagnostics) about the cluster performance.
Although these are the most common next steps, you don't need to log in to the operations portal or run basic diagnostics to verify a successful installation.
If there were issues with installing or bringing the Kubernetes cluster online, the addons installation would fail.

For more information, see [Provision a customized cluster](#provision-a-customized-cluster).

### Merge the kubeconfig

Once the cluster is provisioned and functional, you should store its access configuration information in your main `kubeconfig` file before using `kubectl` to interact with the cluster.

The access configuration contains certificate credentials and the API server endpoint for accessing the cluster.
The `konvoy` cluster stores this information internally as `admin.conf`, but you can merge it into your "home" `kubeconfig` file, so you can access the cluster from other working directories on your machine.

To merge the access configuration, use the following command:

```bash
konvoy apply kubeconfig
```

#### Specify the kubeconfig location

By default, the `konvoy apply kubeconfig` command uses the value of the `KUBECONFIG` environment variable to declare the path to the correct configuration file.
If the `KUBECONFIG` environment variable is not defined, the default path of `~/.kube/config` is used.

You can override the default Kubernetes configuration path in one of two ways:

- By specifying an alternate path before running the `konvoy apply kubeconfig` command. For example:

  ```bash
  export KUBECONFIG="${HOME}/.kube/konvoy.conf"
  konvoy apply kubeconfig
  ```

- By setting `KUBECONFIG` to the path of the current configuration file created and used within `konvoy`. For example:

  ```bash
  export KUBECONFIG="${PWD}/admin.conf"
  ```

#### Validate a merged configuration

To validate the merged configuration, you should be able to list nodes in the Kubernetes cluster by running the following command:

```bash
kubectl get nodes
```

The command returns output similar to the following:

```
NAME                                         STATUS   ROLES    AGE   VERSION
ip-10-0-129-3.us-west-2.compute.internal     Ready    <none>   24m   v1.15.0
ip-10-0-131-215.us-west-2.compute.internal   Ready    <none>   24m   v1.15.0
ip-10-0-131-239.us-west-2.compute.internal   Ready    <none>   24m   v1.15.0
ip-10-0-131-24.us-west-2.compute.internal    Ready    <none>   24m   v1.15.0
ip-10-0-192-174.us-west-2.compute.internal   Ready    master   25m   v1.15.0
ip-10-0-194-137.us-west-2.compute.internal   Ready    master   26m   v1.15.0
ip-10-0-195-215.us-west-2.compute.internal   Ready    master   26m   v1.15.0
```

### Deploy a sample application
Now that you have a basic Konvoy cluster installed and ready to use, you might want to test operations by deploying a simple, sample application.
This task is **optional** and is only intended to demonstrate the basic steps for deploying applications in a production environment.
If you are configuring the Konvoy cluster for a production deployment, you can use this section to learn the deployment process.
However, deploying applications on a production cluster typically involves more planning and custom configuration than covered in this example.

The sample application used in this section is a condensed form of the Kubernetes sample [guestbook][guestbook] application.

To deploy the sample application:

1. Deploy the Redis master pods and service by running the following commands:

    ```bash
    kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml
    kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml
    ```

1. Deploy the Redis agents by running the following commands:

    ```bash
    kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-deployment.yaml
    kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-service.yaml
    ```

1. Deploy the webapp frontend by running the following command:

    ```bash
    kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml
    ```

1. Deploy the load balancer for the sample application using a cloud `LoadBalancer` service type instead of a `NodePort` service type by running the following command:

    ```bash
    curl -L https://k8s.io/examples/application/guestbook/frontend-service.yaml | sed "s@NodePort@LoadBalancer@" | kubectl apply -f -
    ```

    This step has been specifically modified to optimize load balancing for a default Konvoy cluster.

1. Check the availability of the deployed service by running the following command:

    ```bash
    kubectl get pods -l app=guestbook -l tier=frontend  # check the app pods
    kubectl get service frontend                        # check the load balancer
    ```

    The service properties provide the name of the load balancer. You can connect to the application by accessing that load balancer address in your web browser.

    Because this sample deployment creates a **cloud load balancer**,  you should keep in mind that creating the load balancer can up to a few minutes.
    You also might experience a slight delay before it is running properly due to DNS propagation and synchronization.

1. Remove the sample application by running the following commands:

    ```bash
    kubectl delete service frontend
    kubectl delete service redis-master
    kubectl delete service redis-slave
    kubectl delete deployment frontend
    kubectl delete deployment redis-master
    kubectl delete deployment redis-slave
    ```

    You should note that this step is **required** because the sample deployment attaches a **cloud provider load balancer** to the Konvoy cluster.
    Therefore, you **must delete** the sample application before tearing down the cluster.

1. Tear down the cluster by running the following command:

    ```bash
    konvoy down
    ```

    This command destroys the Kubernetes cluster and the infrastructure it runs on.

### Provision a customized cluster

1. Generate the configuration files by running the following command:

    ```bash
    konvoy init --provisioner=aws
    ```

1. Edit the provisioner configuration settings in the `cluster.yaml` cluster configuration file.

    You can edit the cluster configuration settings to suit your needs.
    For example, you can change the node count or add custom tags to all resources created by the installer by modifying the corresponding settings in the `cluster.yaml` file under the `ClusterProvisioner` section.

    The following example illustrates the `ClusterProvisioner` settings defined in the `cluster.yaml` cluster configuration file:

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
    ```

    As illustrated in this example, you can modify the `nodePools` section to configure the nodes of your cluster by changing the `nodePools.count` from `4` to `5` or the node type by changing the `nodePools.machine.type` from `t3.xlarge` to `t3.large`.

    You can also modify the `tags` section to extend the lifetime of your cluster.
    This change might be useful, for example, if your AWS administrator has created a job to remove cloud resources based on AWS resource tags.
    For example:

    ```yaml
    ### needs both tags
    tags:
      owner: luxi
      expiration: 24h
    ```

1. Edit the `ClusterConfiguration` section of `cluster.yaml` configuration file to change which addons you want to enable or disable.

    The following example illustrates the `ClusterConfiguration` settings defined in the `cluster.yaml` cluster configuration file:

    ```yaml
    kind: ClusterConfiguration
    apiVersion: konvoy.mesosphere.io/v1alpha1
    metadata:
      name: konvoy
      creationTimestamp: "2019-05-31T18:00:00.844964-04:00"
    spec:
      kubernetes:
        version: 1.15.0
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
        - name: helm
          enabled: true
        - name: awsebsprovisioner
          enabled: false
        - name: awsebscsiprovisioner
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
    ```

    In this example, you can disable the `fluentbit` addon by changing the `enabled` from `true` to `false`.

1. Provision the cluster with your customized settings by running the following command:

    ```bash
    konvoy up
    ```

The `konvoy up` command provisions the cluster similar to how it is provisioned using the default settings as described in [Provision and deploy the cluster and addons](#provision-and-deploy-the-cluster-and-addons).

However, customized provisioning creates a `cluster.tmp.yaml` file that contains the default values merged with any your user-provided overrides.
The `cluster.tmp.yaml` file is the file that Ansible uses during its execution.
You can delete this file after the cluster is created because it will be regenerated on every execution of the `konvoy up` command.

## Generate cluster diagnostics

After your cluster is running, you can generate diagnostic information for the Kubernetes cluster, nodes, and addons.
Checking cluster components is optional, but can help you quickly verify the state of the cluster and ensure it is operating correctly.
For more information about checking cluster components, see [Checking component integrity](./troubleshooting/check.md).

## Troubleshooting

In general, Konvoy is designed to be _idempotent_, which means you can run the tools multiple times to achieve the same desired configuration under most conditions.
This capability enables Konvoy to be resilient in recovering from transient errors.

To see other commands available in `konvoy`, you can run `konvoy` (with no commands) or `konvoy <command> --help`.

For more information about troubleshooting common issues and specific errors, see [Troubleshooting](./troubleshooting/failed_installations.md).

[aws_credentials]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html
[install_aws]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
[install_docker]: https://www.docker.com/products/docker-desktop
[install_kubectl]: https://kubernetes.io/docs/tasks/tools/install-kubectl/
[guestbook]: https://kubernetes.io/docs/tutorials/stateless-application/guestbook/