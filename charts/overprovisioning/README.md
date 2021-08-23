# Helm chart overprovisioning

This chart creates deployment(s) for cluster overprovisioning.

## How to use this chart

1. Add repository:

```shell
helm repo add evilmartians https://helm.evilmartians.net
```

2. Describe deployments in `values.yaml`.

3. Install:

```shell
helm install overprovisioning evilmartians/overprovisioning -f values.yaml
```
