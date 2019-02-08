---
layout: layout.pug
navigationTitle: Edge-LB Overview
title: Edge-LB overview
menuWeight: 5
excerpt: Edge-LB proxies and load balances traffic to all services that run on DC/OS.
enterprise: false
---

Edge-LB proxies and load balances traffic to all services that run on DC/OS. Edge-LB provides North-South (external to internal) load balancing, while [virtual networking](/latest/networking/load-balancing-vips/) provides East-West (internal to internal) load balancing.

Edge-LB leverages HAProxy, which provides the core load balancing and proxying features, such as load balancing for TCP and HTTP-based applications, SSL support, and health checking. In addition, Edge-LB provides first class support for zero downtime service deployment strategies, such as blue/green deployment. Edge-LB subscribes to Mesos and updates HAProxy configuration in real time.

The following diagram provides a simplified overview of Edge-LB load balancing.

<p>
<img src="/services/edge-lb/img/Edge-LB-1.png" alt="Simplified overview of Edge-LB architecture">
<p>