{{- define "app.servicemonitors" -}}
{{- range $component, $map := .Values.components }}
{{- $currentType := set $ "currentType" $component -}}
{{- if $map.serviceMonitor }}
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata: {{ include "app.metadata" $ | nindent 2 }}
spec:
  endpoints:
  - port: metrics
  namespaceSelector:
    matchNames:
    - {{ $.Release.Namespace }}
  selector:
    matchLabels: {{ include "app.templateSelector" $ | nindent 6 }}
{{- end -}}
{{- end }}
{{- end }}
