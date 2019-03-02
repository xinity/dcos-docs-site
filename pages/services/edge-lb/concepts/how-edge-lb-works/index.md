---
layout: layout.pug
navigationTitle: How Edge-LB works
title: How Edge-LB works
menuWeight: 10
excerpt: Edge-LB proxies and load balances traffic to all services that run on DC/OS.
enterprise: true
---

Edge-LB leverages HAProxy, which provides the core load balancing and proxying features, such as load balancing for TCP and HTTP-based applications, SSL support, and health checking. In addition, Edge-LB provides first class support for zero downtime service deployment strategies, such as blue/green deployment. Edge-LB subscribes to Mesos and updates HAProxy configuration in real time.

Depending on your network and cluster configuration, you might route outside traffic through a hardware load balancer, then to the Edge-LB load balancer pool. One of the Edge-LB load balancers within that pool then accepts the traffic and routes it to the appropriate service within the DC/OS cluster.

Edge-LB leverages HAProxy for its core load balancing and proxying features. Every time there is a Edge-LB pool is launched, it launches the HAProxy instances inside the pool instance to do it proxying and load balancing functionality. Thus all features and functionality are automatically supported in Edge-LB.

Edge-LB can be deployed on any node. Its typically deployed on Public nodes for Ingress. Operators can deploy individual pool servers and load balancers specific to tenants and groups of applications. Its designed to scale and provide granular control. Pool configs are added for specific backend service by deploying a new pool configuration by operators.

As a public load balancer, Edge-LB can provide outbound connections for containers running on DC/OS cluster by translating their Private IP addresses to Public IP addresses.

Edge-LB can be used to: 
- Load-balance incoming internet traffic to the containers through a public load balancer (external load balancing).
- Load-balance traffic across containers inside the DC/OS cluster (internal load balancing).
- Provide outbound connectivity for containers inside the DC/OS cluster by using a public load balancer.
  
## Key components of the Edge-LB architecture

Edge-LB has two core architectural components:
- The [Edge-LB API server](#edge-lb-api-server).
- One or more [Edge-LB pool](#edge-lb-pool).

The following diagram illustrates the relationship between these core components running on a DC/OS cluster.

<p>
<img src="/services/edge-lb/img/Edge-LB-2.png" alt="Core components of the Edge-LB architecture">
</p>

Outside requests are received through the public-facing agent node and distributed through HAProxy to the application backend tasks.

<a name="edge-lb-api-server"></a>

### Edge-LB API server

The **Edge-LB API Server** is the service that responds to CLI commands and manages pools.

Edge-LB runs as a DC/OS service launched by [Marathon](/latest/deploying-services/). The Edge-LB API server processes requests and configuration details in response to Edge-LB commands, launches Edge-LB load balancer pools, and manages the creation and removal of Edge-LB pools. 

<a name="edge-lb-pool"></a>

### Edge-LB pools

Each **Edge-LB pool** is a group of identically configured load balancers. Traffic to any individual pool is distributed to the load balancers within that pool. 

The load balancer pool manages pool-specific properties such as the number of load balancer instances and their placement. The pool is the smallest unit of load balancer configuration within Edge-LB. The load balancers within the same pool are identical. You can configure Edge-LB to have multiple load balancer pools with different configurations.

From the perspective of Marathon, each Edge-LB pool is a DC/OS service.
