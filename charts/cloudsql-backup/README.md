# Helm chart cloudsql-backup

This chart was written to backup CloudSQL PG instance outside the Google Cloud using the S3 compatible buckets.

## Dependencies

* Helm **v3**

## Installation

Use values file like this `example-values.yaml`:

```yaml
apps:
- name: example
  backupSchedule: "0 2 * * *"
  backupTimeout: 7200
  cleanupSchedule: "0 7 * * *"
  cleanupTimeout: 7200
  checkSchedule: "0 12 * * *"
  checkTimeout: 3600
  pruneSchedule: "0 20 * * *"
  pruneTimeout: 14400
  unlockSchedule: "0 15 * * *"
  unlockTimeout: 60
  resources:
    limits:
      cpu: 1
      memory: 1Gi
    requests:
      cpu: 1
      memory: 1Gi
  resticCredentialsSecretName: example-restic-credentials
  postgresCredentialsSecretName: example-postgres-credentials
  configFilesSecretName: example-config-files

proxy:
  credentialsJson: ""
  enabled: true
  instances: "example-project:zone:example-db-instance"
```

```shell
helm repo add evilmartians https://helm.evilmartians.net

helm install cloudsql-backup evilmartians/cloudsql-backup -f example-values.yaml
```

## Secrets

You must create two secrets:
- secret with restic credentials
- secret with postgres credentials

You can create two optional secrets:
- secret with config files (for example `gs-secret-restic-key.json` for Google Cloud Storage access)
- secret for CloudSQL proxy

Example of restic credentials secret:

```yaml
---
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: example-restic-credentials
stringData:
  RESTIC_REPOSITORY: s3:fra1.digitaloceanspaces.com/example/example
  RESTIC_PASSWORD: CHANGEME
  AWS_ACCESS_KEY_ID: CHANGEME
  AWS_SECRET_ACCESS_KEY: CHANGEME
  GOOGLE_PROJECT_ID: CHANGEME
  GOOGLE_APPLICATION_CREDENTIALS: /config/gs-secret-restic-key.json
```

Example of PostgreSQL credentials secret:

```yaml
---
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: example-postgres-credentials
stringData:
  PGDATABASE: example_db
  PGUSER: example_user
  PGPASSWORD: example_password
  PGHOST: pg.example.com
```

Example of secret with configs:

```yaml
---
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: example-config-files
data:
  gs-secret-restic-key.json: <base64-encoded gcloud json file>
```

Example of CloudSQL proxy secret:

```yaml
---
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: example-cloudsql-proxy
data:
  credentials.json: <base64-encoded credentials json>
```

## Values

| Value | Description | Default |
|-------|:-----------:|--------:|
|**apps**|An array of databases to backup and credentials to use for that. (See an example above)||
|**proxy.affinity**|Affinity section for the cloudsql proxy deployment||
|**proxy.credentialsJson**|JSON service account key cloudsql proxy will use to connect to a database||
|**proxy.enabled**|Should the cloudsql proxy be enabled|`false`|
|**proxy.image.repository**|Docker repository to use for cloudsql proxy image|`gcr.io/cloudsql-docker/gce-proxy`|
|**proxy.image.tag**|Docker image tag for cloudsql proxy|`1.16`|
|**proxy.image.pullPolicy**|Docker image pull policy for cloudsql proxy|`IfNotPresent`|
|**proxy.instances**|CloudSQL instances name for the cloudsql proxy to connect to|`""`|
|**proxy.nodeSelector**|A node seletor for the cloudsql proxy deployment||
|**proxy.resources**|Resources requests and limits for the cloudsql proxy deployment||
|**proxy.secretName**|Kubernetes secret name for the cloudsql proxy credentials.json key||
|**proxy.service.type**|Type of the service for the cloudsql proxy|`ClusterIP`|
|**proxy.service.port**|Port of the cloudsql proxy|`5432`|
|**proxy.tolerations**|Tolerations for the cloudsql proxy deployment||
|**restic.affinity**|Affinity section for the restic pods||
|**restic.image.repository**|Docker repository for the restic image|`quay.io/evl.ms/pgrestic`|
|**restic.image.tag**|Docker image tag for the restic image|`0.9.6-r0-alpine`|
|**restic.image.pullPolicy**|Docker image pull policy for the restic pods|`IfNotPresent`|
|**restic.nodeSelector**|A node selector for the restic backup pods||
|**restic.resources**|Resources requests and limits for the restic backup pods||
|**restic.tolerations**|Tolerations for the restic backup pods||
