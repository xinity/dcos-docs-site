---
layout: konvoy-docs-landing.pug
title: Konvoy Docs
navigationTitle: Documentation for Konvoy 0.1
menuWeight: 0
---
# Overview

**Note**: Konvoy is a completely standalone offering and does not depend on DC/OS or Apache Mesos.

Konvoy is a stand alone Kubernetes distribution. Konvoy includes an upstream Kubernetes deployment in addition to several best in class add-on applications pre-deployed to give you a complete Kubernetes ecosystem experience by using a single command installer.

In a nutshell, Konvoy provides a out of the box production ready Kubernetes distro and all the componenets required for operation and lifecycle management. Konvoy is fully integrated, tested and supported by Mesosphere.

## Features and Functionalities

Konvoy provides the following features and functionalities:

- Single command installer for CNCF certified HA Kubernetes on AWS. This feature is intended to support other cloud providers in future releases.
- Provision infrastructure on cloud provider using terraform (currently AWS) or pre-deploy the infrastructure (physical/virtual) and deploy using konvoy
- Out of the box installation of all core addons for a production cluster including the following:
    - Calico (Network Overlay)
    - CoreDNS (DNS)
    - Traefik (Ingress)
    - Local storage class (default)
- Out of the box installation and configuration of metrics and log tools and technologies  including the following:
    - Metrics: Prometheus/ Alertmanager/Grafana/Telegraf
    - Logging: Fluentbit/ Elasticsearch/ Kibana
- Deploy core addons for networking and storage
- Deploy operational addons including logging infrastructure, monitoring, and backup/restore using open source tools (CNCF stack)
- Configure cluster with best practices for security and operations
- Operational dashboard to access K8s dashboard, logging, and metrics
- Basic lifecycle management including scaling, patching, and upgrading

## Benefits

Konvoy has the following benefits:

- Provides a simple and flexible platform to build various applications
- Avoids the use of multiple instructions/commands to spin up a cluster and provides a single command to spin up a cluster
- Delivers an end-to-end solution with CNCF technologies
- Reduces the amount of time, expertise, cost, and resources spent in building and allowing on-premise deployments on multiple infrastructures
