{{/* Template to generate affinity for preemptible instances */}}
{{- define "app.gke.nodeAffinity.preemptible" -}}
nodeAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
  - weight: 100
    preference:
      matchExpressions:
      - key: cloud.google.com/gke-preemptible
        operator: Exists
{{- end }}

{{/* Template to generate tolerations for preemptible instances */}}
{{- define "app.gke.tolerations.preemptible" -}}
- key: gke-preemptible
  operator: Equal
  value: "true"
  effect: NoSchedule
{{- end }}
