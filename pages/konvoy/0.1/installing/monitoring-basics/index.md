---
layout: layout.pug
navigationTitle: Monitoring Basics
title: Monitoring Basics
menuWeight: 1
excerpt: 
enterprise: false


---

Ops tools for monitoring a Konvoy cluster can all be found via the [Ops Portal](../operations/ops_portal.md).
Important cluster metrics are scrapped via the [prometheus-operator](https://github.com/coreos/prometheus-operator) installed via the helm chart [stable/prometheus-operator](https://github.com/helm/charts/tree/master/stable/prometheus-operator) which includes the helm installation of [stable/grafana](https://github.com/helm/charts/tree/master/stable/grafana).
Here, you will find information regarding three technologies that are important with regards to monitoring your cluster:

- Prometheus
- Prometheus Alert Manager
- Grafana

The location for the collected efforts of upstream alerts and dashboards can be found in the repo [Kubernetes-Mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin).
It is recommended that contributions be made to this repo when possible but as stated this is primarily composed of other upstream projects, such as `etcd.io/etcd`, etc., and so some contributions must be made further upstream to land here.

## Prometheus

Prometheus is a metrics aggregator, it uses (but is not limited to using) a pull model for scraping metrics.
Prometheus must be configured to aggregate metrics for each desired service, but for Konvoy it is configured to collect metrics that can be used to determine the health state of your cluster.
The UI for prometheus, attainable via the the Ops Portal,

### Alerts

The list of items included here are prescribed alerts that will be triggered when certain conditions are met against key metrics and some time interval.
These are (for the most part) community recommended alerts that should not be ignored when firing.
The state of an alert is both color coded with information about the quantities of alerts that are active (in parenthesis):

``` bash
KubePodCrashLooping (1 active)
```

Where the above states that there is one alert that is active.
When you click on an alert you will find alert data which can be used to diagnose the problem.
Details include how the alert itself is designed, and a brief description of the alert.

``` bash
alert: KubePodCrashLooping
expr: rate(kube_pod_container_status_restarts_total{job="kube-state-metrics"}[15m])
  * 60 * 5 > 0
for: 1h
labels:
  severity: critical
annotations:
  message: Pod {{ $labels.namespace }}/{{ $labels.pod }} ({{ $labels.container }})
    is restarting {{ printf "%.2f" $value }} times / 5 minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepodcrashlooping
```

A `runbook` url is included which should link to the location for more details and possible actions one can take.
Most details for these alerts can be found by looking at this [Runbook](https://github.com/kubernetes-monitoring/kubernetes-mixin/blob/master/runbook.md), it is suggested one familiarize themselves with them.
Additional context and information can be found, including the source of the alert, `Labels`, the state, time stamps of activity, and `value` that triggered the alert.

The alerts, as mentioned earlier, are color coded:

| State    | Color  | Description                                                                     |
| -------- | ------ | ------------------------------------------------------------------------------- |
| inactive | green  | an alert has not been triggered                                                 |
| pending  | yellow | an alert is pending and may fire depending on the configured threshold duration |
| active   | red    | an alert has fired, a critical issue has occurred that may need your attention  |

### Graph

The primary page for prometheus.
It is possible to find any metrics that are collected from your cluster from clicking on the `- insert metric at cursor` button, or entering text in the `Expression` box.
The `Expression` text box is for entering queries, more details can be found [here](https://prometheus.io/docs/prometheus/latest/querying/basics/), once a query has been created it is possible to graph the query and get some time series view of the data.

It is recommended you start building dashboards and any additional important queries for your cluster using the `Expression` text box feature of Prometheus.

### Status

Under status there are additional items one may select, for brevity we shall not discuss all of them, but discuss those that are useful for debugging or monitoring your cluster.

#### Configuration

Here are located the configurations applied to prometheus for scrapping targets.
Information here includes, frequency of scraping, location, sources roles, etc...
Details for configurations can be found [here](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)

An example snippet of a configuration can be seen here:

```bash
global:
  scrape_interval: 30s
  scrape_timeout: 10s
  evaluation_interval: 30s
  external_labels:
    prometheus: kubeaddons/prometheus-kubeaddons-prom-prometheus
    prometheus_replica: prometheus-prometheus-kubeaddons-prom-prometheus-0
  ...
alerting:
  alert_relabel_configs:
  - separator: ;
    regex: prometheus_replica
    replacement: $1
    action: labeldrop
  alertmanagers:
  - kubernetes_sd_configs:
    - role: endpoints
      namespaces:
        names:
        - kubeaddons
  ...
scrape_configs:
- job_name: kubeaddons/prometheus-kubeaddons-prom-kube-etcd/0
  honor_timestamps: true
  scrape_interval: 30s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: https
  kubernetes_sd_configs:
  - role: endpoints
    namespaces:
      names:
      - kube-system
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
  tls_config:
    ca_file: /etc/prometheus/secrets/etcd-certs/ca.crt
    cert_file: /etc/prometheus/secrets/etcd-certs/server.crt
    key_file: /etc/prometheus/secrets/etcd-certs/server.key
    insecure_skip_verify: false
  ...
```

Important fields to consider are:
- `global` - which are global properties set agains all scrape jobs.
- `alerting` - which defines properties for alerting.
- `scrape_configs` - composed of `jobs` each defining what to scrape and how.


#### Rules

Here you will find all the alert rules that currently exist in prometheus.
All rules will have a heading, indicating what they are related to, or associated with, and each rule will be listed in a table form.
Each table entry will include the rule definition, its state , any errors, and how long it was evaluated and how long it took to evaluate it.

| Rule | State	| Error	| Last Evaluation	| Evaluation Time |
| -----| ------ | ----- | ----------------- | ----------------|
| `alert`: etcdInsufficientMembers <br>  `expr`: sum by(job) (up{job=~".*etcd.*"} == bool 1) < ((count by(job) (up{job=~".*etcd.*"}) + 1) / 2) <br> `for`: 3m <br> `labels`: <br>`severity`: critical <br>`annotations`: <br>   `message`: 'etcd cluster "{{ $labels.job }}": insufficient members ({{ $value }}).' | OK | | 17.737s ago | 447.8us |

#### Targets

Here you will find all endpoints that have been defined as sources of metrics to scrape.
The definitions of all of these scrape endpoints can be located under the prometheus configuration under `scrape_configs`.

All targets are under some predefined heading, such as `etcd`, and are followed by table entries with all necessary information about the endpoints being scrapped.
The information in each table contains details such as the endpoint being targeted for scrapping, the last known state, and even any error information.
It should also be stated that errors will show up in red/yellow colors while successes will always show up in green.

| Endpoint | State | Labels | Last Scrape |Scrape Duration | Error |
| ---------| ----- | ------ | ----------- | ---------------| ----- |
| https://10.0.195.116:2379/metrics | UP | endpoint="http-metrics" instance="10.0.195.116:2379"<br>job="kube-etcd" namespace="kube-system"<br>pod="etcd-ip-10-0-195-116.us-west-2.compute.internal"<br>service="prometheus-kubeaddons-prom-kube-etcd" |	1.633s ago | 10.43ms |

## Prometheus Alert Manager

Alerts are defined in prometheus via rules.
AlertManager allows you to control these alerts by allowing you control over alerts that are firing and active.
Each active alert will show up as a row in the main UI tab `alerts`, information for each active alert includes the `alertname` and associated labels.

You may take certain actions in each active alert:
- viewing additional information such as the alert `message` and `runbook_url`
- viewing the source of the data for the alert
- silencing an alert so it does not keep firing off to whatever alerting system you have in place

The last point sends you to another screen where you may select how much time to silence and alert, filters to match agains, and details about whoe and  why the alert is being silenced.

## Grafana

Currently there are several Dashboards which are responsible for monitoring core technologies in Kubernetes:

| Title                                              | Description                                                                                                 |
| -------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| CoreDNS                                            | requests counts to service in cluster                                                                       |
| etcd                                               | includes error counts, number of active members and leader elections                                        |
| Kubernetes/API server                              | active members, memory usage, cpu usage, rpc errors, etc...                                                 |
| Kubernetes/Compute Resources/Cluster               | cluster details about cpu utilization, requests, and memory related metrics                                 |
| Kubernetes/Compute Resources/Namespace (Pods)      | cpu usage and memory usage for pods per namespace                                                           |
| Kubernetes/Compute Resources/Namespace (Workloads) | cpu usage and memory usage for workloads (daemonset, deployment, statefulsets) in a namespace               |
| Kubernetes/Compute Resources/Pod                   | cpu usage and memory usage per pod per namespace                                                            |
| Kubernetes/Compute Resources/Workload              | cpu usage and memory usage per workload per namespace per type                                              |
| Kubernetes/Controller Manager                      | active members, memory usage, cpu usage, rpc errors, etc...                                                 |
| Kubernetes/Kubelet                                 | active members, memory usage, cpu usage, rpc errors, number of pods running containers volume counts etc... |
| Kubernetes/Nodes                                   | system load, cpu usage, memory usage, disk pressure network information per node                            |
| Kubernetes/Persistent Volumes                      | (currently not usable as metrics are depricated) volume usage per namespace per persistentvolumeclaim       |
| Kubernetes/Pods                                    | memory, network, and network usage per namespace per pod                                                    |
| Kubernetes/Scheduler                               | active members, memory usage, cpu usage, rpc errors, etc...                                                 |
| Kubernetes/StatefulSets                            | replica count, memory usage, cpu usage of statefulsets in a namespace                                       |
| Kubernetes/USE Method/Cluster                      | utilization and saturation of memory, cpu, and networking for the cluster                                   |
| Kubernetes/USE Method/Node                         | utilization and saturation of memory, cpu, and networking for the cluster per node                          |
