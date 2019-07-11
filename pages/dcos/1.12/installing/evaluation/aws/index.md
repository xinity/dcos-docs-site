---
layout: layout.pug
excerpt: Guide for DC/OS on AWS using the Universal Installer
title: DC/OS on AWS using the Universal Installer
navigationTitle: AWS
menuWeight: 0
model: /dcos/1.12/installing/data.yml
render: mustache
---
#include /dcos/install-include/aws-intro-and-prereqs.tmpl

#include /dcos/install-include/all-install-terraform.tmpl

#include /dcos/install-include/aws-credentials.tmpl

#include /dcos/install-include/all-ssh-keypair.tmpl

#include /dcos/install-include/all-enterprise-license.tmpl

#include /dcos/install-include/aws-cluster-setup.tmpl

#include /dcos/install-include/all-create-first-cluster.tmpl

#include /dcos/install-include/all-logging-in-dcos.tmpl

#include /dcos/install-include/all-scale-cluster.tmpl

#include /dcos/install-include/all-upgrade-cluster.tmpl

#include /dcos/install-include/all-destroy-cluster.tmpl

#include /dcos/install-include/aws-v02-modules-update.tmpl