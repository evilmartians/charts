{{/* Template to generate affinity settings */}}
{{/* The `.currentType` stands for the type of the current pod */}}
{{- define "app.aws.nodeAffinity" -}}
nodeAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
  - weight: 100
    preference:
      matchExpressions:
      - key: lifecycle
        operator: In
        values:
        - spot
{{- end }}

{{/* Template to generate tolerations settings */}}
{{- define "app.aws.tolerations" -}}
- key: lifecycle
  operator: Equal
  value: "spot"
  effect: NoSchedule
{{- end }}
