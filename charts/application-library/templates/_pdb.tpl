{{- define "app.pdbs" -}}
{{- range $component, $map := .Values.components }}
{{- $currentType := set $ "currentType" $component -}}
{{- with $map.podDisruptionBudget -}}
{{- if .enabled }}
---
apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata: {{ include "app.metadata" $ | nindent 2 }}
spec:
  {{- if .minAvailable }}
  minAvailable: {{ .minAvailable }}
  {{- end }}
  {{- if .maxUnavailable }}
  maxUnavailable: {{ .maxUnavailable }}
  {{- end }}
  selector:
    matchLabels: {{- include "app.templateSelector" $ | nindent 6 }}
{{- end -}}
{{- end -}}
{{- end }}
{{- end }}
