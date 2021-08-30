# Helm chart cloudsql-backup-check

This chart was written to check backups of CloudSQL PG instances from S3 compatible buckets.
It creates CronJob, which creates Jobs where `ansible-playbook ... name-of-cloud-here.yml` runs.

Overview of what `ansible-playbook ... name-of-cloud-here.yml` does:
- Add ssh key from chart values to cloud (Digital Ocean or AWS)
- Create instance
- Connect to created instance via ssh
	- Install PostgreSQL and restic
	- Run `restic dump ... | pg_restore ...`
	- Run SQL query/queries to check database integrity
- Delete instance
- Delete ssh key from cloud

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
  # name of cloud where instance will be created
  # supported values are: "aws" and "digital-ocean"
  cloud: "aws"
  # user which will be used to ssh on created instance
  # for Digital Ocean this is "root"
  # for AWS you should check chosen AMI documentation
  ssh_user: root
  # kubernetes secret which contains ssh key which will be added to user on created instance (change it!)
  # this key must be unique across all databases in the same cloud to prevent conficts
  # during addition/deletion key through cloud API
  # you can use RSA or ed25519 key for Digital Ocean
  # for AWS only RSA key is supported
  # (see details below)
  sshKeysSecretName: example-ssh-keys
  # variables from this secret will be added as --extra-vars to ansible-playbook
  # (see details below)
  ansibleVariablesSecretName: example-ansible-variables

ansible_backup_check:
  image:
    repository: quay.io/evl.ms/ansible-postgresql-backup-check
    tag: 20210705-alpine
    pullPolicy: IfNotPresent
```

```shell
helm repo add evilmartians https://helm.evilmartians.net

helm install cloudsql-backup-check evilmartians/cloudsql-backup-check -f example-values.yaml
```

## Secrets

You need to create two secrets: one for ssh keys and the other for ansible variables.

Example of ssh keys secret:

```yaml
---
apiVersion: v1
kind: Secret
type: kubernetes.io/ssh-auth
metadata:
  name: example-ssh-key
stringData:
  ssh-publickey: "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICKMe79IL5vMt0FyavQctc1pTdBnzhV4JqcOSzxU0TqB"
  ssh-privatekey: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
    QyNTUxOQAAACAijHu/SC+bzLdBcmr0HLXNaU3QZ84VeCanDks8VNE6gQAAAIjrMumi6zLp
    ogAAAAtzc2gtZWQyNTUxOQAAACAijHu/SC+bzLdBcmr0HLXNaU3QZ84VeCanDks8VNE6gQ
    AAAECPIbREy8DIfG9EF6bmpPa1v13R6RysIm6b+TxRUJk8nSKMe79IL5vMt0FyavQctc1p
    TdBnzhV4JqcOSzxU0TqBAAAAAAECAwQF
    -----END OPENSSH PRIVATE KEY-----
```

Of course you must change public and private key with your own. This key must be unique across all databases in the same cloud to prevent conflicts during addition/deletion key through cloud API. You can use RSA or ed25519 key for Digital Ocean, but only RSA for AWS.

Example of ansible variables secret:

```yaml
---
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: example-ansible-variables
stringData:
  variables.yml: |
    # REQUIRED variables:

    # general
    database_name: "name"
    restoration_timeout: "must be the same as timeout from chart values"

    # restic credentials
    restic_aws_access_key: ""
    restic_aws_secret_key: ""
    restic_password: ""
    restic_repository: ""

    # digital ocean only
    do_oauth_token: "digital-ocean-api-token-with-write-permission"
    do_size: "use 'doctl compute size list' to choose"
    do_region: "use 'doctl compute region list' to choose"
    do_image: "use 'doctl compute image list --public' to choose; tested only with Ubuntu 20.04"

    # aws only
    aws_access_key: "access key"
    aws_secret_key: "secret key"
    aws_region: "eu-west-1, us-east-1, etc."
    aws_instance_type: "t2.nano, i3.large, etc."
    aws_image: "ami-***, only Ubuntu 20.04 tested"
    aws_security_group: "name of security group with allowed inbound TCP traffic on port 22"
    aws_subnet: "subnet-***"

    # OPTIONAL variables:

    # postgresql
    postgresql_version: "13"
    postgresql_apt_key_url: "https://www.postgresql.org/media/keys/ACCC4CF8.asc"
    # list of apt packages of postgresql extensions
    postgresql_extensions:
      - postgresql-13-repack
      - postgresql-13-postgis-3

    # restic
    snapshot: "latest"
    restic_url: "https://github.com/restic/restic/releases/download/v0.12.0/restic_0.12.0_linux_amd64.bz2"
    restic_hash: "63d13d53834ea8aa4d461f0bfe32a89c70ec47e239b91f029ed10bd88b8f4b80"
```

These variables will be added as `--extra-vars` to `ansible-playbook` command.

## Values

| Value | Description | Default |
|-------|:-----------:|--------:|
|**databases**|An array of databases' backups. (See an example above)||
|**ansible\_backup\_check.image.repository**|Docker repository for the docker image with ansible playbooks|`quay.io/evl.ms/ansible-postgresql-backup-check`|
|**ansible\_backup\_check.image.tag**|Docker image tag for the docker image with ansible playbooks|`20210705-alpine`|
|**ansible\_backup\_check.image.pullPolicy**|Docker image pull policy for the ansible pods|`IfNotPresent`|
