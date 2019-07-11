---
layout: layout.pug
excerpt: Guide for DC/OS on GCP using the Universal Installer
title: DC/OS on GCP using the Universal Installer
navigationTitle: GCP
menuWeight: 4
model: /dcos/1.11/installing/data.yml
render: mustache
---

#include /dcos/install-include/all-intro-and-prereqs.tmpl

#include /dcos/install-include/all-install-terraform.tmpl

#include /dcos/install-include/gcp-credentials.tmpl

#include /dcos/install-include/all-enterprise-license.tmpl

#include /dcos/install-include/gcp-cluster-setup.tmpl

#include /dcos/install-include/all-create-first-cluster.tmpl

#include /dcos/install-include/all-logging-in-dcos.tmpl

#include /dcos/install-include/all-scale-cluster.tmpl

#include /dcos/install-include/all-upgrade-cluster.tmpl

#include /dcos/install-include/all-destroy-cluster.tmpl