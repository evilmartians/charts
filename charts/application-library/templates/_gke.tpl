{{/* Template to generate affinity settings */}}
{{/* The `.currentType` stands for the type of the current pod */}}
{{- define "app.gke.nodeAffinity" -}}
nodeAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      preference:
        matchExpressions:
          - key: cloud.google.com/gke-preemptible
            operator: Exists
{{- end }}

{{/* Template to generate tolerations settings */}}
{{- define "app.gke.tolerations" -}}
- key: gke-preemptible
  operator: Equal
  value: "true"
  effect: NoSchedule
{{- end }}
