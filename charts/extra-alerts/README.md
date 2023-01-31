# Helm chart extra-alerts

This chart contains a collection of extra `PrometheusRule` manifests in addition to [kube-prometheus-stack chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack).

## Dependencies

* Helm **v3**

## How to use this chart

1. Add repository:

```shell
helm repo add evilmartians https://helm.evilmartians.net
```

2. Install:

```shell
helm install extra-alerts evilmartians/extra-alerts -f values.yaml
```

Some of the rules have the same names as in the `kube-prometheus-stack` chart, so you should disable those:

```yaml
# this is inside values.yaml for kube-prometheus-stack chart
defaultRules:
  # . . .
  disabled:
    KubePodCrashLooping: true # replaced
    KubeContainerWaiting: true # replaced
    KubePersistentVolumeFillingUp: true # replaced
```
