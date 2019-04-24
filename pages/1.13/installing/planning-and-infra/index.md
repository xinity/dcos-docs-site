---
layout: layout.pug
navigationTitle: Planning your Infrastructure
title: Planning and Setting Up Your Infrastructure
menuWeight: 5
excerpt: Discussion of node operating systems, formatting and best practices.
---
A DC/OS cluster consists of two types of nodes **master nodes** and **agent nodes**.  The agent nodes can be either **public agent nodes** or **private agent nodes**. Public agent nodes provide north-south (external to internal) access to services in the cluster through load balancers. Private agents host the containers and services that are deployed on the cluster. In addition to the master and agent cluster nodes, each DC/OS installation includes a separate **bootstrap node** for DC/OS installation and upgrade files. Some of the hardware and software requirements apply to all nodes. Other requirements are specific to the type of node being deployed.

# Hardware prerequisites

The hardware prerequisites are a single bootstrap node, Mesos master nodes, and Mesos agent nodes.

## Bootstrap node

*  DC/OS installation is run on a single **Bootstrap node** with two cores, 16 GB RAM, and 60 GB HDD.
*  The bootstrap node is only used during the installation and upgrade process, so there are no specific recommendations for high performance storage or separated mount points.

<p class="message--note"><strong>NOTE: </strong>The bootstrap node must be separate from your cluster nodes.</p>

<a name="CommonReqs">

## All master and agent nodes in the cluster

The DC/OS cluster nodes are designated Mesos masters and agents during installation. The supported operating systems and environments are listed on the [version policy page](https://docs.mesosphere.com/version-policy/).

When you install DC/OS on the cluster nodes, the required files are installed in the `/opt/mesosphere` directory. You can create the `/opt/mesosphere` directory prior to installing DC/OS, but it must be either an empty directory or a link to an empty directory. DC/OS can be installed on a separate volume mount by creating an empty directory on the mounted volume, creating a link at `/opt/mesosphere` that targets the empty directory, and then installing DC/OS.

You should verify the following requirements for all master and agent nodes in the cluster:
- Every node must have network access to a public Docker repository or to an internal Docker registry.
- If the node operating system is RHEL 7 or CentOS 7, the `firewalld` daemon must be stopped and disabled. For more information, see [Disabling the firewall daemon on Red Hat or CentOS](#FirewallDaemon).
- The DNSmasq process must be stopped and disabled so that DC/OS has access to port 53. For more information, see [Stopping the DNSmasq process](#StopDNSmasq).
- You are not using `noexec` to mount the `/tmp` directory on any system where you intend to use the DC/OS CLI.
-  You have sufficient disk to store persistent information for the cluster in the `var/lib/mesos` directory.
- You should not remotely mount the `/var/lib/mesos` or Docker storage `/var/lib/docker` directory.

<a name="FirewallDaemon">

### Disabling the firewall daemon on Red Hat or CentOS
There is a known <a href="https://github.com/docker/docker/issues/16137" target="_blank">Docker issue</a> that the `firewalld` process interacts poorly with Docker. For more information about this issue, see the <a href="https://docs.docker.com/v1.6/installation/centos/#firewalld" target="_blank">Docker CentOS firewalld</a> documentation.

To stop and disable the `firewalld`, run the following command:
```bash
sudo systemctl stop firewalld && sudo systemctl disable firewalld
```
<a name="StopDNSmasq">

### Stopping the DNSmasq process
The DC/OS cluster requires access to port 53. To prevent port conflicts, you should stop and disable the `dnsmasq` process by running the following command:
```bash
sudo systemctl stop dnsmasq && sudo systemctl disable dnsmasq.service
```

## Master node requirements

The following table lists the master node hardware requirements:

|             | Minimum   | Recommended |
|-------------|-----------|-------------|
| Nodes       | 1*         | 3 or 5     |
| Processor   | 4 cores   | 4 cores     |
| Memory      | 32 GB RAM | 32 GB RAM   |
| Hard disk   | 120 GB    | 120 GB      |
&ast; For business critical deployments, three master nodes are required rather than one master node.

There are many mixed workloads on the masters. Workloads that are expected to be continuously available or considered business-critical should only be run on a DC/OS cluster with at least three masters. For more information about high availability requirements see the [High Availability documentation][0].

[0]: /1.12/overview/high-availability/

Examples of mixed workloads on the masters are Mesos replicated logs and ZooKeeper. In some cases, mixed workloads require synchronizing with `fsync` periodically, which can generate a lot of expensive random I/O. We recommend the following:

- Solid-state drive (SSD)
- RAID controllers with a BBU
- RAID controller cache configured in writeback mode
- If separation of storage mount points is possible, the following storage mount points are recommended on the master node. These recommendations will optimize the performance of a busy DC/OS cluster by isolating the I/O of various services.
  | Directory Path | Description |
  |:-------------- | :---------- |
  | _/var/lib/dcos_ | A majority of the I/O on the master nodes will occur within this directory structure. If you are planning a cluster with hundreds of nodes or intend to have a high rate of deploying and deleting workloads, isolating this directory to dedicated SSD storage is recommended.

- Further breaking down this directory structure into individual mount points for specific services is recommended for a cluster which will grow to thousands of nodes.

  | Directory Path | Description |
  |:-------------- | :---------- |
  | _/var/lib/dcos/mesos/master_ | logging directories |
  | _/var/lib/dcos/cockroach_ | CockroachDB [enterprise type="inline" size="small" /] |
  | _/var/lib/dcos/navstar_ | for Mnesia database |
  | _/var/lib/dcos/secrets_ | secrets vault [enterprise type="inline" size="small" /] |
  | _/var/lib/dcos/exhibitor_ | Zookeeper database |

## Agent node requirements

The table below shows the agent node hardware requirements.

|             | Minimum   | Recommended |
|-------------|-----------|-------------|
| Nodes       | 1         | 6 or more   |
| Processor   | 2 cores   | 2 cores     |
| Memory      | 16 GB RAM | 16 GB RAM   |
| Hard disk   | 60 GB     | 60 GB       |

In addition to the requirements described in [All master and agent nodes in the cluster](#CommonReqs), the agent nodes must have:
- A `/var` directory with 20 GB or more of free space. This directory is used by the sandbox for both [Docker and DC/OS Universal container runtime](/1.12/deploying-services/containerizers/).

-   Do not use `noexec` to mount the `/tmp` directory on any system where you intend to use the DC/OS CLI unless a TMPDIR environment variable is set to something other than `/tmp/`. Mounting the `/tmp` directory using the `noexec` option could break CLI functionality.

-   If you are planning a cluster with hundreds of agent nodes or intend to have a high rate of deploying and deleting services, isolating this directory to dedicated SSD storage is recommended.

    | Directory Path | Description |
    |:-------------- | :---------- |
    | _/var/lib/mesos/_ | Most of the I/O from the Agent nodes will be directed at this directory. Also, The disk space that Apache Mesos advertises in its UI is the sum of the space advertised by filesystem(s) underpinning _/var/lib/mesos_ |

-  Further breaking down this directory structure into individual mount points for specific services is recommended for a cluster which will grow to thousands of nodes.

   | Directory path | Description |
   |:-------------- |:----------- |
   | _/var/lib/mesos/slave/slaves_ | Sandbox directories for tasks |
   | _/var/lib/mesos/slave/volumes_ | Used by frameworks that consume ROOT persistent volumes |
   | _/var/lib/mesos/docker/store_ | Stores Docker image layers that are used to provision URC containers |
   | _/var/lib/docker_ | Stores Docker image layers that are used to provision Docker containers |

## <a name="port-and-protocol"></a>Port and protocol configuration

-   Secure shell (SSH) must be enabled on all nodes.
-   Internet Control Message Protocol (ICMP) must be enabled on all nodes.
-   All hostnames (FQDN and short hostnames) must be resolvable in DNS; both forward and reverse lookups must succeed. [enterprise type="inline" size="small" /]
-   Each node is network accessible from the bootstrap node.
-   Each node has unfettered IP-to-IP connectivity from itself to all nodes in the DC/OS cluster.
-   All ports should be open for communication from the master nodes to the agent nodes and vice versa. [enterprise type="inline" size="small" /]
-   UDP must be open for ingress to port 53 on the masters. To attach to a cluster, the Mesos agent node service (`dcos-mesos-slave`) uses this port to find `leader.mesos`.

Requirements for intermediaries (e.g., reverse proxies performing SSL termination) between DC/OS users and the master nodes:

- No intermediary must buffer the entire response before sending any data to the client.
- Upon detecting that its client goes away, the intermediary should also close the corresponding upstream TCP connection (i.e., the intermediary
should not reuse upstream HTTP connections).

## High-speed internet access

High speed internet access is recommended for DC/OS installations. A minimum 10 MBit per second is required for DC/OS services. The installation of some DC/OS services will fail if the artifact download time exceeds the value of MESOS_EXECUTOR_REGISTRATION_TIMEOUT within the file `/opt/mesosphere/etc/mesos-slave-common`. The default value for MESOS_EXECUTOR_REGISTRATION_TIMEOUT is 10 minutes.

# Software prerequisites

* Refer to the [install_prereqs.sh](https://raw.githubusercontent.com/dcos/dcos/1.10/cloud_images/centos7/install_prereqs.sh) script for an example of how to install the software requirements for DC/OS masters and agents on a CentOS 7 host.[enterprise type="inline" size="small" /]

* When using OverlayFS over XFS, the XFS volume should be created with the -n ftype=1 flag. Please see the [Red Hat](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/7.2_release_notes/technology-preview-file_systems) and [Mesos](http://mesos.apache.org/documentation/latest/container-image/#provisioner-backends) documentation for more details.

## Docker requirements

Docker must be installed on all bootstrap and cluster nodes. The supported Docker versions are listed on [version policy page](https://docs.mesosphere.com/version-policy/).

## Requirements and Recommendations

Be sure that Docker's [`live-restore` setting is disabled](https://docs.docker.com/config/containers/live-restore/). It should be absent or set to false in a Docker configuration file.

Before installing Docker on CentOS/RHEL, review the general [requirements and recommendations for running Docker on DC/OS][1] and the following CentOS/RHEL-specific recommendations:

* OverlayFS is now the default in Docker CE. There is no longer a need to specify or configure the overlay driver. Prefer the OverlayFS storage driver. OverlayFS avoids known issues with `devicemapper` in `loop-lvm` mode and allows containers to use docker-in-docker, if they want.

* Format node storage as XFS with the `ftype=1` option. As of CentOS/RHEL 7.2, [only XFS is currently supported for use as a lower layer file system][2].

    <p class="message--note"><strong>NOTE: </strong> In modern versions of Centos and RHEL, <code>ftype=1</code> is the default. The <code>xfs_info</code> utility can be used to verify that <code>ftype=1</code>.</p>

    ```bash
    mkfs -t xfs -n ftype=1 /dev/sdc1
    ```
## Example: Installing Docker on CentOS

The following instructions demonstrate how to install Docker on CentOS 7.

1. Uninstall the newer version of Docker (if present):

    ```bash
    sudo yum remove docker-ce
    ```

1. Install Docker:

    ```bash
    sudo yum install docker
    ```

1. Start Docker:

    ```bash
    sudo systemctl start docker
    ```

1. Verify that Docker version 1.13 was installed:

    ```bash
    docker version --format '{{.Server.Version}}'
    ```

To continue setting up DC/OS, [please jump to the Advanced Installer][4]

For more generic Docker requirements, see [System Requirements: Docker][1].

[1]: /1.13/installing/production/system-requirements/#docker
[2]: https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/7.2_Release_Notes/technology-preview-file_systems.html
[3]: https://docs.docker.com/install/linux/docker-ee/rhel
[4]: /1.13/installing/production/deploying-dcos/installation/

### Recommendations

- Do not use Docker `devicemapper` storage driver in `loop-lvm` mode. For more information, see [Docker and the Device Mapper storage driver](https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/).

- Prefer `OverlayFS` or `devicemapper` in `direct-lvm` mode when choosing a production storage driver. For more information, see Docker's <a href="https://docs.docker.com/engine/userguide/storagedriver/selectadriver/" target="_blank">Select a Storage Driver</a>.

- Manage Docker on CentOS with `systemd`. The `systemd` handles will start Docker and helps to restart Dcoker, when it crashes.

- Run Docker commands as the root user (with `sudo`) or as a user in the <a href="https://docs.docker.com/engine/installation/linux/centos/#create-a-docker-group" target="_blank">docker user group</a>.

### Distribution-specific installation

Each Linux distribution requires Docker to be installed in a specific way:

- **CentOS/RHEL** - [Install Docker from Docker's yum repository][1].
- **CoreOS** - Comes with Docker pre-installed and pre-configured.

For more more information, see Docker's <a href="https://docs.docker.com/install/" target="_blank">distribution-specific installation instructions</a>.

## Disable sudo password prompts

To disable the `sudo` password prompt, you must add the following line to your `/etc/sudoers` file.

```bash
%wheel ALL=(ALL) NOPASSWD: ALL
```

Alternatively, you can SSH as the `root` user.

## Synchronize time for all nodes in the cluster

You must enable Network Time Protocol (NTP) on all nodes in the cluster for clock synchronization. By default, during DC/OS startup you will receive an error if this is not enabled. You can check if NTP is enabled by running one of these commands, depending on your OS and configuration:

```bash
ntptime
adjtimex -p
timedatectl
```

## Bootstrap node

Before installing DC/OS, you **must** ensure that your bootstrap node has the following prerequisites.

<p class="message--important"><strong>IMPORTANT: </strong>If you specify `exhibitor_storage_backend: zookeeper`, the bootstrap node is a permanent part of your cluster. With `exhibitor_storage_backend: zookeeper`, the leader state and leader election of your Mesos masters is maintained in Exhibitor ZooKeeper on the bootstrap node. For more information, see the <a href="/1.12/installing/production/advanced-configuration/configuration-reference/">configuration parameter documentation</a>.</p>


- The bootstrap node must be separate from your cluster nodes.

### <a name="setup-file"></a>DC/OS configuration file

- Download and save the [dcos_generate_config file](https://support.mesosphere.com/hc/en-us/articles/213198586-Mesosphere-Enterprise-DC-OS-Downloads) to your bootstrap node. This file is used to create your customized DC/OS build file. Contact your sales representative or <a href="mailto:sales@mesosphere.com">sales@mesosphere.com</a> for access to this file. [enterprise type="inline" size="small" /]

- Download and save the [dcos_generate_config file](https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh) to your bootstrap node. This file is used to create your customized DC/OS build file. [oss type="inline" size="small" /]

### Docker NGINX (production installation)

For production installations only, install the Docker NGINX image with this command:

```bash
sudo docker pull nginx
```

## Cluster nodes

For production installations only, your cluster nodes must have the following prerequisites. The cluster nodes are designated as Mesos masters and agents during installation.

### Data compression (production installation)

You must have the <a href="http://www.info-zip.org/UnZip.html" target="_blank">UnZip</a>, <a href="https://www.gnu.org/software/tar/" target="_blank">GNU tar</a>, and <a href="http://tukaani.org/xz/" target="_blank">XZ Utils</a> data compression utilities installed on your cluster nodes.

To install these utilities on CentOS7 and RHEL7:

```bash
sudo yum install -y tar xz unzip curl ipset
```

### Cluster permissions (production installation)

On each of your cluster nodes, follow the below instructions:

*   Make sure that SELinux is in one of the supported modes.

    To review the current SELinux status and configuration run the following command:

    ```bash
    sudo sestatus
    ```

    DC/OS supports the following SELinux configurations:

    * Current mode: `disabled`
    * Current mode: `permissive`
    * Current mode: `enforcing`, given that `Loaded policy name` is `targeted`
      This mode is not supported on CoreOS.

    To change the mode from `enforcing` to `permissive` run the following command:

    ```bash
    sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
    ```

    Or, if `sestatus` shows a "Current mode" which is `enforcing` with a `Loaded policy name` which is not `targeted`, run the following command to change the `Loaded policy name` to `targeted`:

    ```bash
    sudo sed -i 's/SELINUXTYPE=.*/SELINUXTYPE=targeted/g' /etc/selinux/config
    ```

    <p class="message--note"><strong>NOTE: </strong>Ensure that all services running on every node can be run in the chosen SELinux configuration.</p>

*   Add `nogroup` and `docker` groups:

    ```bash
    sudo groupadd nogroup &&
    sudo groupadd docker
    ```

*   Reboot your cluster for the changes to take effect.

    ```bash
    sudo reboot
    ```

    <p class="message--note"><strong>NOTE: </strong>It may take a few minutes for your node to come back online after reboot.</p>

### Locale requirements
You must set the `LC_ALL` and `LANG` environment variables to `en_US.utf-8`.

- For information on how to set these variables in Red Hat, see [How to change system locale on RHEL](https://access.redhat.com/solutions/974273)

- On Linux:
````
localectl set-locale LANG=en_US.utf8
````

- For information on how to set on these variables in CentOS7, see [How to set up system locale on CentOS 7](https://www.rosehosting.com/blog/how-to-set-up-system-locale-on-centos-7/).

# Next steps
- [Install Docker from Docker’s yum repository][1]
- [DC/OS Installation Guide][2]

[1]: /1.12/installing/production/system-requirements/docker-centos/

[2]: /1.12/installing/production/deploying-dcos/installation/

You can use customized [AWS Machine Images (AMI)](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) based on CentOS 7, CoreOS, and RHEL to launch DC/OS with the advanced templates.

- A custom AMI can be used to integrate DC/OS installation with your own in-house configuration management tools.
- A custom AMI can be used if you want kernel or driver customization.

To get started, build a custom AMI and then install DC/OS using the advanced templates.

# Build a custom AMI
This is the recommended method for building your own AMI.

## Build DC/OS cloud_images AMI

1.  Use the DC/OS [cloud_images](https://github.com/dcos/dcos/tree/master/cloud_images) scripts as a template. These scripts build a CentOS7 AMI with all of the DC/OS prerequisites installed.

    Verify that you can build and deploy an AMI using these scripts as-is, without modification. An AMI must be deployed to every region where a cluster will be launched. The DC/OS Packer build script [create_dcos_ami.sh](https://github.com/dcos/dcos/blob/master/cloud_images/centos7/create_dcos_ami.sh) can deploy the AMI to multiple regions by setting the environment variable `DEPLOY_REGIONS` before running the script.

1.  Launch the DC/OS advanced template using the AWS CloudFormation web console and specify the DC/OS cloud_images AMI. Verify that the cluster launched successfully. For more information, see the [documentation](/1.13/installing/evaluation/aws/).

## Modify the DC/OS cloud_images AMI

After you have successfully built and deployed the unmodified DC/OS cloud_images AMI using the AWS CloudFormation web console:

1.  Modify the DC/OS [cloud_images](https://github.com/dcos/dcos/tree/master/cloud_images) AMI scripts with your own AMI customizations. Your AMI must satisfy all of the DC/OS AMI prerequisites as shown in the template.

1.  Launch the DC/OS advanced templates using the AWS CloudFormation web console and specify your customized AMI. Verify that DC/OS starts as expected and that services can be launched on the DC/OS cluster.

1.  Complete your installation by following [these instructions](/1.13/installing/evaluation/aws/).

## Troubleshooting

- Familiarize yourself with the DC/OS service startup [process](/1.13/overview/architecture/boot-sequence/).
- See the installation troubleshooting [documentation](/1.13/installing/troubleshooting/). To troubleshoot you must have [SSH access](/1.13/administering-clusters/sshcluster/) to all of the cluster nodes.
- The [DC/OS Slack](https://support.mesosphere.com) community is another a good place to get help.

# Azure Production-Ready Cluster Configurations

These recommendations are based on the operation of multiple DC/OS clusters over many years, scaling a mix of stateful and stateless services under a live production load. Your service mix may perform differently, but the principles and lessons discussed herein still apply.

## General Machine Configurations
We recommend disabling swap on your VMs, which is typically the default for the Azure Linux images. We have found that using the ephemeral SSDs for swap (via WAAgent configuration) can conflict with the disk caching configuration of the `D` series of VMs. For other series of VMs, such as the L series, it may be possible to use the SSDs for swap and other purposes.

See the following section for details on disk configuration. Monitoring (such as Node Exporter with Prometheus) should be used to identify and alert when workloads are nearing Azure defined limits.

## Networking
On Azure, raw network performance is roughly determined by VM size. VMs with 8 or more cores, such as `Standard_D8_v3`, are eligible for [Azure Accelerated Networking (SR-IOV)](https://docs.microsoft.com/en-us/azure/virtual-network/create-vm-accelerated-networking-cli). We have seen much lower latency and more available and stable bandwidth using SR-IOV, as opposed to relying on the Azure hypervisor vswitches. For example, in our testing, a `Standard_D16s_v3` without SR-IOV can push approximately 450MB/s of data between two VMs, while the same size machines can push closer to 1000MB/s of data using SR-IOV. Thus, SR-IOV should be employed when possible and you should benchmark your instance sizes (e.g. using [iperf3](https://github.com/esnet/iperf)) to make sure your network requirements are met.

Additionally, while multiple NICs are supported per virtual machine, the amount of bandwidth is per VM, not per NIC. Thus, while segmenting your network into control and data planes (or other networks) may be useful for organizational or security purposes, Linux level traffic shaping is required in order to achieve bandwidth control.

## Disk Configurations
In order to achieve performant, reliable cluster operation on Azure, premium SSDs are recommended in particular disk configurations. Managed disks (MDs) are preferred over unmanaged disks (UMDs) to avoid storage account limitations: The Azure fabric will place the managed disks appropriately to meet the guaranteed SLAs. Storage account limitations for UMDs are documented [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-performance-checklist).

On Azure, premium SSDs have a limited number of synchronous IOPs possible limited by the latency of the underlying disk fabric. Services such as etcd, Zookeeper and databases which utilize a write-ahead-log (WAL) are particularly sensitive to this I/O configuration. Thus, much of the system engineering described herein is focused on minimizing and/or eliminating I/O contention on the Azure disks. Additionally, exceeding the I/O allocation on a machine will result in throttling. You should study this article on [Azure VM Storage Performance and Throttling Demystified](https://blogs.technet.microsoft.com/xiangwu/2017/05/14/azure-vm-storage-performance-and-throttling-demystify/)
in detail to understand the theoretical background of the recommendations herein.

Given the need to separate synchronous from asynchronous I/O loads in order to maintain performance, we recommend the following disk mounting configuration:
- Masters:
    - / - P10
    - /var/lib/etcd - (for those running etcd on CoreOS) - P10
    - /var/log - P10
    - /var/lib/dcos/exhibitor - P10
- Public Agents:
    - / - P10
    - /var/log - P10
    - /var/lib/docker - P10
    - /var/lib/mesos/slave - P10
- Private Agents:
    - / - P10
    - /var/log - P10
    - /var/lib/docker - P10
    - /var/lib/mesos/slave - P20

It is certainly possible to run clusters with smaller and/or fewer disks, but for production use, the above configuration has proven to have substantial advantages for any non-trivial cluster sizes. Additionally, we recommend attaching appropriate premium SSDs to `/dcos/volume0 ... /dcos/volumeN` using Mesos MOUNT disk resources, which can then be dedicated to data intensive services without I/O contention. For data intensive services such as postgres or mysql, you should consider attaching LVM RAID stripes to those MOUNT resources to increase the possible transactions per second of the databases.

With respect to configuring the disk caches, the following general rules apply:
- OS disks should be set to `ReadWrite`.
- Data disks with a mixed or read heavy load (database bulk storage, etc) should be set to `ReadOnly`.
- Data disks with high sequential write loads (WAL disks) should be set to `None`.
