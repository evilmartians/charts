{{/* Template to generate affinity for spot instances */}}
{{- define "app.aws.nodeAffinity.spot" -}}
preferredDuringSchedulingIgnoredDuringExecution:
- weight: 100
  preference:
    matchExpressions:
    - key: lifecycle
      operator: In
      values:
      - spot
{{- end }}

{{/* Template to generate tolerations for spot instances */}}
{{- define "app.aws.tolerations.spot" -}}
- key: lifecycle
  operator: Equal
  value: "spot"
  effect: NoSchedule
{{- end }}
