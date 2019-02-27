---
layout: layout.pug
navigationTitle: Edge-LB Overview
title: Edge-LB overview
menuWeight: 5
excerpt: Edge-LB proxies and load balances traffic to all services that run on DC/OS.
enterprise: false
---

# What is Edge-LB?
Edge-LB proxies and load balances traffic to all services that run on DC/OS. Edge-LB provides North-South (external to internal) load balancing, while [virtual networking](/latest/networking/load-balancing-vips/) provides East-West (internal to internal) load balancing.

# How Edge-LB works
Edge-LB leverages HAProxy, which provides the core load balancing and proxying features, such as load balancing for TCP and HTTP-based applications, SSL support, and health checking. In addition, Edge-LB provides first class support for zero downtime service deployment strategies, such as blue/green deployment. Edge-LB subscribes to Mesos and updates HAProxy configuration in real time.

The following diagram provides a simplified overview of Edge-LB load balancing.

<p>
<img src="/services/edge-lb/img/Edge-LB-1.png" alt="Simplified overview of Edge-LB architecture">
<p>

Depending on your network and cluster configuration, you might route outside traffic through a hardware load balancer, then to the Edge-LB load balancer pool. One of the Edge-LB load balancers within that pool then accepts the traffic and routes it to the appropriate service within the DC/OS cluster.

## Key components of the Edge-LB architecture

Edge-LB has three core architectural components:
- The [Edge-LB API server](#edge-lb-api-server).
- One or more [Edge-LB pool](#edge-lb-pool).
- The [load balancer](#edge-lb-load-balancer) service.

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

### Edge-LB Pool

Each **Edge-LB pool** is a group of identically configured load balancers. Traffic to any individual pool is distributed to the load balancers within that pool. 

The load balancer pool manages pool-specific properties such as the number of load balancer instances and their placement. The pool is the smallest unit of load balancer configuration within Edge-LB. The load balancers within the same pool are identical. You can configure Edge-LB to have multiple load balancer pools with different configurations.

From the perspective of Marathon, each Edge-LB pool is a DC/OS service.

<a name="edge-lb-load-balancer"></a>

### Edge-LB load balancers

The **Edge-LB load balancers** are the individual instances of the load balancing software (such as HAProxy). Individual load balancer instances accept traffic and route it to the appropriate services within the DC/OS cluster.

# Edge-LB pools for high-availability

Multiple Edge-LB pools can be configured across multiple DC/OS public nodes to create a highly-available load balancing environment and to support increased throughput. There are two primary external architectures that support this:

- External Load Balancer: Configures multiple Edge-LB pools such that the Edge-LB load balancers that are on DC/OS public nodes are behind an external load balancer. Direct end users or clients to the external load balancer device, which will then load balance the traffic between the multiple Edge-LB pools. The external load balancer can be a cloud-based load balancer, such as an AWS Elastic Load Balancer (ELB), an Azure Load Balancer, or a physical load balancer such as an F5 or Cisco ACE device.

- Round Robin DNS: Configures DNS such that a single DNS entry responds with IP addresses corresponding to a different Edge-LB pool. The DNS will round robin between the VIPs for each Edge-LB pool.

The following diagram illustrates multiple load balancers in an Edge-LB pool distributing requests to services running on a DC/OS cluster.

<p>
<img src="/services/edge-lb/img/Edge-LB-3.png" alt="Using multiple Edge-LB load balancers in a pool">
</p>

# Technical architecture deep-dive
The core Edge-LB components can support many complex load balancing scenarios and network topologies. The following diagram provides a more detailed representation of how you can deploy Edge-LB running on a DC/OS cluster.

<p>
<img src="/services/edge-lb/img/Edge-LB-4.png" alt="Detail view of Edge-LB components">
</p>