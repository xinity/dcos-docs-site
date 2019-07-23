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
  * [Before you begin](#before-you-begin)
  * [Download and extract the Konvoy package](#download)
* [Provision and deploy the cluster and addons](#provision-and-deploy)
* [Review deployment output and login information](#review-deployment-output-and-login-information)
* [Connect to the operations portal](#connect-to-the-operations-portal)
* [Merge the kubeconfig](#merge-the-kubeconfig)
  * [Specify the kubeconfig location](#specify-the-kubeconfig-location)
  * [Validate a merged configuration](#validate-a-merged-configuration)
* [Next steps](#next-steps)
  * [Deploy a sample application](#deploy-a-sample-application)
  * [Provision a customized cluster](#provision-a-customized-cluster)
  * [Generate cluster diagnostics](#generate-cluster-diagnostics)
  * [Additional troubleshooting](#additional-troubleshooting)

<a name="prepare-for-installation"></a>

## Prepare for installation

Currently, all the runtime dependencies for Konvoy are bundled in a Docker container.
The Konvoy runtime dependencies include:
* Terraform
* Ansible
* Kubectl
* Helm

Each release of Konvoy is accompanied by a wrapper that executes the container and manages these dependencies.

<a name="before-you-begin"></a>

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
<a name="download"></a>

### Download and extract the Konvoy package

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
<a name="provision-and-deploy"></a>

## Provision and deploy the cluster and addons

1. Verify you have valid **AWS security credentials** to deploy the cluster on AWS.

    This step is not required if you are installing Konvoy on an internal (on-prem) network.
    For information about installing onsite, see [Install on an internal network](../install-upgrade/install_onprem/).

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

## Review deployment output and login information
The `konvoy up` command produces **a verbose stream of output** from Terraform and Ansible operations.

You will see the following when the deployment succeeds:

```text
Kubernetes cluster and addons deployed successfully!

Run `konvoy apply kubeconfig` to update kubectl credentials.

Navigate to the URL below to access various services running in the cluster.
  https://lb_addr-12345.us-west-2.elb.amazonaws.com/ops/landing
And login using the credentials below.
  Username: AUTO_GENERATED_USERNAME
  Password: SOME_AUTO_GENERATED_PASSWORD_12345

The dashboard and services may take a few minutes to be accessible.
```

You should copy the cluster URL and login information and paste it into a text file, then save the file in a secured, shared location on your network. You can then use this information to access the operations portal and associated dashboards.

## Connect to the operations portal
Unless you manually disable it, the default deployment includes an _operations portal_ that links to several dashboards of the installed services, including:
* Grafana dashboards for metrics
* Kibana dashboardsfor logs
* Traefik dashboards for inbound HTTP traffic
* Kubernetes dashboard for cluster activity

Use the link provided in the deployment output to access the cluster's dashboards using the **operations portal**.
For example, navigate to the URL you copied from the deployment output (`https://lb_addr-12345.us-west-2.elb.amazonaws.com/ops/landing`) and log in using the automatically-generated credentials.

By default, the login credentials use self-signed SSL/TLS certificates.
It is possible to override Traefik [chart values](https://github.com/helm/charts/tree/master/stable/traefik#configuration) to use your own certificates or to use the ACME protocol to use certificates issued by Let's Encrypt if you provide your own domain.

After you log in to the operations portal, you can view [diagnostic information](#generate-cluster-diagnostics) and [dashboards](../operations/accessing-the-cluster/#ops-portal-dashboards) about the cluster performance.
Although these are the most common next steps, you don't need to log in to the operations portal or run basic diagnostics to verify a successful installation.
If there were issues with installing or bringing the Kubernetes cluster online, the addons installation would fail.

For more information, see [Next steps](#next-steps).

## Merge the kubeconfig

Once the cluster is provisioned and functional, you should store its access configuration information in your main `kubeconfig` file before using `kubectl` to interact with the cluster.

The access configuration contains certificate credentials and the API server endpoint for accessing the cluster.
The `konvoy` cluster stores this information internally as `admin.conf`, but you can merge it into your "home" `kubeconfig` file, so you can access the cluster from other working directories on your machine.

To merge the access configuration, use the following command:

```bash
konvoy apply kubeconfig
```

### Specify the kubeconfig location

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

### Validate a merged configuration

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

## Next steps
Now that you have a basic Konvoy cluster installed and ready to use, you might want to test operations by deploying a simple, sample application, customizing the cluster configuration, or checking the status of cluster components.

### Deploy a sample application
Deploying a sample application is an **optional** task.
It is only intended to demonstrate the most basic steps for deploying applications in a production environment.
For an introduction to deploying applications, see the [Deploy a sample application](../tutorials/deploy-sample-app/) tutorial.

### Provision a customized cluster
Provisioning a customized cluster is an **optional** task.
However, it is one of the most common tasks you perform when deploying in a production environment.

Provisioning a customized cluster involves editing the cluster configuration settings in the `cluster.yaml` file to suit your needs.
For example, you can change the node count or addons enabled by modifying the appropriate settings in the `cluster.yaml` file.

For an introduction to modifying the cluster configuration and provisioning settings in the `cluster.yaml` file, see the [Provision a customized cluster](../tutorials/provision-a-custom-cluster/) tutorial.

### Generate cluster diagnostics

After your cluster is running, you can generate diagnostic information for the Kubernetes cluster, nodes, and addons.
Checking cluster components is **optional**, but can help you quickly verify the state of the cluster and ensure it is operating correctly.
For more information about checking cluster components, see [Checking component integrity](../troubleshooting/check-components/).

### Additional troubleshooting

In general, Konvoy is designed to be _idempotent_, which means you can run the tools multiple times to achieve the same desired configuration under most conditions.
This capability enables Konvoy to be resilient in recovering from transient errors.

To see other commands available in `konvoy`, you can run `konvoy` (with no commands) or `konvoy <command> --help`.

For more information about troubleshooting common issues and specific errors, see [Troubleshooting](../troubleshooting/).

[aws_credentials]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html
[install_aws]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
[install_docker]: https://www.docker.com/products/docker-desktop
[install_kubectl]: https://kubernetes.io/docs/tasks/tools/install-kubectl/
[guestbook]: https://kubernetes.io/docs/tutorials/stateless-application/guestbook/