---
layout: layout.pug
title: Installing DC/OS to form a Cluster
navigationTitle: Installing a DC/OS Cluster
menuWeight: 15
excerpt: Installing DC/OS on your infrastructure to create a cluster.
---

The following steps are performed to install DC/OS clusters:

*   Plan your infrastructure along DC/OS cluster guidelines for cloud, on-premise and hybrid cloud setups
*   Format each node according to DC/OS system requirements
*   Use a bootstrap node to configure the DC/OS Installer for your environment
*   Install DC/OS on each master node
*   Install DC/OS on each agent node

# Available methods for managing installation

## Managing infrastructure and your cluster with Terraform

(description needed)

## Using Ansible for cluster management

(description needed)

## Manual cluster operations
To install DC/OS, a generator script for the specific DC/OS version is used to create a customized DC/OS build according to your specifications. It contains a Bash install script and a Docker container that is loaded with everything you need to deploy your customized DC/OS build. The Docker container contains all of the elements for DC/OS so it can be used for offline installation. Using this method, you can package the DC/OS distribution and connect to every node manually to run the DC/OS installation commands. This installation method is recommended if you want to integrate with an existing system or if you do not have SSH access to your cluster.

# Downloading the DC/OS configuration generator

- For installing DC/OS Enterprise contact your sales representative or <sales@mesosphere.io>. You can access the DC/OS Enterprise download from the [support website](https://support.mesosphere.com/s/downloads) using a [login credential](https://support.mesosphere.com/s/login/). [enterprise type="inline" size="small" /]

- You can download the most recent, stable, open source DC/OS version [here](https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh) or find older versions of the file on the [open source project website](https://dcos.io/releases/). [oss type="inline" size="small" /]
