# Helm chart cloudsql-backup-check

This chart was written to check backups of CloudSQL PG instances from S3 compatible buckets.
It creates CronJob, which creates Jobs where `ansible-playbook ... main.yml` runs.

Overview of what `ansible-playbook ... main.yml` does:
- Add ssh key from chart values to Digital Ocean project
- Create droplet
- Connect to created droplet via ssh
	- Install PostgreSQL and restic
	- Run `restic dump ... | pg_restore ...`
	- Run SQL query/queries to check database integrity
- Delete droplet
- Delete ssh key from Digital Ocean project

## Dependencies

* Helm **v3**

## Installation

Use values file like this `example-values.yaml`:

```yaml
databases:
- name: example
  schedule: "0 2 * * 6"
  timeout: 14400
  nodeSelector: {}
  affinity: {}
  resources:
    limits:
      cpu: 100m
      memory: 256Mi
    requests:
      cpu: 100m
      memory: 256Mi
  tolerations: []
  # ssh key which will be added to root user on created droplet (change it!)
  # this key must be unique across all databases to prevent conficts
  # during addition/deletion key through digital ocean API
  ssh_key:
    public: "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICKMe79IL5vMt0FyavQctc1pTdBnzhV4JqcOSzxU0TqB"
    private: |
      -----BEGIN OPENSSH PRIVATE KEY-----
      b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
      QyNTUxOQAAACAijHu/SC+bzLdBcmr0HLXNaU3QZ84VeCanDks8VNE6gQAAAIjrMumi6zLp
      ogAAAAtzc2gtZWQyNTUxOQAAACAijHu/SC+bzLdBcmr0HLXNaU3QZ84VeCanDks8VNE6gQ
      AAAECPIbREy8DIfG9EF6bmpPa1v13R6RysIm6b+TxRUJk8nSKMe79IL5vMt0FyavQctc1p
      TdBnzhV4JqcOSzxU0TqBAAAAAAECAwQF
      -----END OPENSSH PRIVATE KEY-----
  # these variables will be added as --extra-vars to ansible-playbook
  ansible_variables:
    # REQUIRED variables:

    # digital ocean
    do_oauth_token: "digital-ocean-api-token-with-write-permission"
    do_size: "use 'doctl compute size list' to choose"
    do_region: "use 'doctl compute region list' to choose"
    do_image: "use 'doctl compute image list --public' to choose"
    # database
    database_name: "name"
    # restic credentials
    aws_access_key_id: ""
    aws_secret_access_key: ""
    restic_password: ""
    restic_repository: ""

    # optional variables:

    # postgresql
    postgresql_version: "13"
    postgresql_apt_key_url: "https://www.postgresql.org/media/keys/ACCC4CF8.asc"

    # restic
    snapshot: "latest"
    restic_url: "https://github.com/restic/restic/releases/download/v0.12.0/restic_0.12.0_linux_amd64.bz2"
    restic_hash: "63d13d53834ea8aa4d461f0bfe32a89c70ec47e239b91f029ed10bd88b8f4b80"

ansible_backup_check:
  image:
    repository: quay.io/evl.ms/ansible-postgresql-backup-check
    tag: 20210319-alpine
    pullPolicy: IfNotPresent
```

```shell
helm repo add evilmartians https://helm.evilmartians.net

helm install cloudsql-backup-check evilmartians/cloudsql-backup-check -f example-values.yaml
```

## Values

| Value | Description | Default |
|-------|:-----------:|--------:|
|**databases**|An array of databases' backups. (See an example above)||
|**ansible\_backup\_check.image.repository**|Docker repository for the docker image with ansible playbooks|`quay.io/evl.ms/ansible-postgresql-backup-check`|
|**ansible\_backup\_check.image.tag**|Docker image tag for the docker image with ansible playbooks|`20210319-alpine`|
|**ansible\_backup\_check.image.pullPolicy**|Docker image pull policy for the ansible pods|`IfNotPresent`|
