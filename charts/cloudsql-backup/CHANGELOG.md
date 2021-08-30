# UNRELEASED

# 0.7.0 (30.08.2021)
- Don't create secrets, just mount them

# 0.6.1 (02.03.2021)
- Update default `pgrestic` tag to `0.12.0-r0-13.2-alpine`
- Change path to restic in dockerfile from `/usr/local/bin/restic` to `/usr/bin/restic`

# 0.6.0 (01.03.2021)
- Update default `pgrestic` tag to `0.12.0-13.2-alpine`
- Update restic and postgresql versions in dockerfile

# 0.5.2 (19.08.2020)
- Apps: add explicit prune step

# 0.5.1 (18.08.2020)
- Apps: add resources
- Apps: add nodeSelector and tolerations

# 0.5.0 (04.08.2020)
- update default `pgrestic` tag to `0.9.6-r0-12.2-alpine`
- add `config-files` secret for additional configuration files. E.g. google cloud key json.

# 0.4.1 (15.05.2020)
- backup unlock cronjob
- backup check cronjob
