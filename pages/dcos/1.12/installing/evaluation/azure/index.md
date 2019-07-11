---
layout: layout.pug
excerpt: Guide for DC/OS on Azure using the Mesosphere Universal Installer
title: DC/OS on Azure using the Universal Installer
navigationTitle: Azure
menuWeight: 2
model: /dcos/1.12/installing/data.yml
render: mustache
---

#include /dcos/install-include/all-intro-and-prereqs.tmpl

#include /dcos/install-include/all-install-terraform.tmpl

#include /dcos/install-include/azure-credentials.tmpl

#include /dcos/install-include/all-ssh-keypair.tmpl

#include /dcos/install-include/all-enterprise-license.tmpl

#include /dcos/install-include/azure-cluster-setup.tmpl

#include /dcos/install-include/all-create-first-cluster.tmpl

#include /dcos/install-include/all-logging-in-dcos.tmpl

#include /dcos/install-include/all-scale-cluster.tmpl

#include /dcos/install-include/all-upgrade-cluster.tmpl

#include /dcos/install-include/all-destroy-cluster.tmpl