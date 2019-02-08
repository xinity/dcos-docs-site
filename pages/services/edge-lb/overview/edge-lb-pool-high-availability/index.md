---
layout: layout.pug
navigationTitle: Edge-LB Pools for High-Availability
title: Edge-LB pools for high-availability
menuWeight: 15
excerpt: Describes how to use multiple Edge-LB instances to support high-availability for services
enterprise: false
---

Multiple Edge-LB pools can be configured across multiple DC/OS public nodes to create a highly-available load balancing environment and to support increased throughput. There are two primary external architectures that support this:

- External Load Balancer: Configures multiple Edge-LB pools such that the Edge-LB load balancers that are on DC/OS public nodes are behind an external load balancer. Direct end users or clients to the external load balancer device, which will then load balance the traffic between the multiple Edge-LB pools. The external load balancer can be a cloud-based load balancer, such as an AWS Elastic Load Balancer (ELB), an Azure Load Balancer, or a physical load balancer such as an F5 or Cisco ACE device.

- Round Robin DNS: Configures DNS such that a single DNS entry responds with IP addresses corresponding to a different Edge-LB pool. The DNS will round robin between the VIPs for each Edge-LB pool.

The following diagram illustrates multiple load balancers in an Edge-LB pool distributing requests to services running on a DC/OS cluster.

<p>
<img src="/services/edge-lb/img/Edge-LB-3.png" alt="Using multiple Edge-LB load balancers in a pool">
</p>