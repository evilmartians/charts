# Helm chart infrastructure-alerts

This chart contains a collection of `PrometheusRule` manifests from [kube-prometheus-stack chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) adjusted to our needs.

## Dependencies

* Helm **v3**
* Kubernetes **>=1.14.0**

## How to use this chart

1. Add repository:

```shell
helm repo add evilmartians https://helm.evilmartians.net
```

2. Enable/disable rule groups and individual rules in `values.yaml`.

3. Install:

```shell
helm install infrastructure-alerts evilmartians/infrastructure-alerts -f values.yaml
```

If you enable some rule group in this chart then, of course, you have to disable it in `values.yaml` for `kube-prometheus-stack` chart to avoid overlapping of rules. This chart doesn't replace all rule groups from `kube-prometheus-stack`. There are groups which contain only `record` prometheus rules and you should keep them enabled because default dashboards from `kube-prometheus-stack` use those records to graph metrics about Kubernetes cluster. The list of rules which can and cannot be replaced is below.

```yaml
defaultRules:
  create: true
  rules:
    # these rule groups contain only "record" rules
    # and they should always be enabled
    k8s: true
    kubeApiserverAvailability: true
    kubeApiserverBurnrate: true
    kubeApiserverHistogram: true
    kubePrometheusGeneral: true
    kubePrometheusNodeRecording: true
    kubeSchedulerRecording: true
    kubelet: true
    node: true
    nodeExporterRecording: true

    # these rule groups can be disabled in kube-prometheus-stack chart
    # and replaced by rules from this chart
    alertmanager: false
    configReloaders: false
    etcd: false
    general: false
    kubeApiserverSlos: false
    kubeProxy: false
    kubeSchedulerAlerting: false
    kubeStateMetrics: false
    kubernetesApps: false
    kubernetesResources: false
    kubernetesStorage: false
    kubernetesSystem: false
    network: false
    nodeExporterAlerting: false
    prometheus: false
    prometheusOperator: false
```

## Important notes
- Set of rules in this chart is not identical to one in `kube-prometheus-stack`. There are both completely new rules and modified ones.
- Set of severity levels were changed from `info -> warning -> critical` to `warning -> dangerous -> critical` to meet requirements of our current agreement about monitoring system : `warning` alerts are sent to Slack, `dangerous` alerts are sent to Opsgenie, but it can call only at daytime and `critical` alerts are sent to Opsgenie, but it can call anytime.
