---
layout: layout.pug
navigationTitle: Operations Portal
title: Operations Portal
menuWeight: 1
excerpt: 
enterprise: false


---

The Konvoy operations portal (Ops Portal) is a webpage directory of administrative interfaces for the cluster add-ons.
Through the operations portal, you can authenticate your identity and perform the administrative activities that help you manage your cluster.
For example, you can use the Konvoy operations portal to access add-on utilities that monitor network traffic, collect metrics for dashboards and reports,or track application performance.

Currently, the Konvoy operations portal uses self-signed SSL/TLS certificates. Future releases will offer signed certificates.

## Access

To access the Konvoy operations portal, you can use the credentials provided in the output at the end of your deployment.

For example:

```
Kubernetes cluster and addons deployed successfully!

Run `konvoy apply kubeconfig` to update kubectl credentials.

Navigate to the URL below to access various services running in the cluster.
  https://lb_addr-12345.us-west-2.elb.amazonaws.com/ops/portal
And login using the credentials below.
  Username: AUTO_GENERATED_USERNAME
  Password: SOME_AUTO_GENERATED_PASSWORD_12345

The dashboard and services may take a few minutes to be accessible.
```

If you've lost these credentials, you can retrieve them again by running:

```bash
konvoy get ops-portal
```

## Dashboards

The following add-on dashboards are provided in the Konvoy operations portal:

- [Kubernetes Dashboard][kubernetes_dashboard] - This dashboard provides a general purpose, web-based interface for Kubernetes clusters. It allows you to manage applications running in the cluster and troubleshoot them, as well as manage the cluster itself.
- [Grafana Metrics][grafana] - Grafana provides user interfaces for supported data sources. Currently, only Prometheus can be used as a data source to monitor your Konvoy cluster.
  If there are no Grafana metrics displayed in the dashboard, complete the following steps to view the pre-installed dashboards:
  1. Hover over the the "4 boxes" on the left to display a drawer popup.
  2. Click **Manage** to display all of the pre-installed Grafana dashboards available.
- [Kibana Logs][kibana] - Kibana enables visual exploration and real-time analysis of your data in [Elasticsearch][es]. The data flow is as follows:
  - Kubernetes pod container and `systemd` logs send data to [Fluent Bit][fluentbit].
  - Fluent Bit retrieves and stores the data to Elasticsearch.
  - Elasticsearch data is retrieved by Kibana for visualization.
- [Prometheus][prometheus_graph] - Prometheus provides a monitoring solution for your cluster. The Konvoy operations portal Prometheus link opens
  the [Prometheus Expression Browser][prometheus_graph]. You can use this browser to see alerts and get details about the Prometheus configuration. You can also graph and visualize monitoring data using Prometheus, but Mesosphere recommends using Grafana instead.
- [Prometheus Alert Manager][prometheus_alert_manager] - The Alert Manager allows you to
  manage noisy alerts by grouping, silencing, and filtering alerts.
- [Traefik][traefik] - Traefik is a reverse-proxy and load balancer. It directs requests from outside of the cluster through a frontend to the correct backend. You can use the Traefik dashboard to check the status, response time, and response codes of these web endpoints.

[kubectl]: ./kubectl_basics.md
[kubernetes_dashboard]: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
[grafana]: https://grafana.com
[kibana]: https://www.elastic.co/products/kibana
[es]: https://en.wikipedia.org/wiki/Elasticsearch
[fluentbit]: https://fluentbit.io
[prometheus]: https://prometheus.io/
[prometheus_graph]: https://prometheus.io/docs/visualization/browser/
[prometheus_alert_manager]: https://prometheus.io/docs/alerting/alertmanager/
[traefik]: https://traefik.io/
