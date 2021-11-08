{{/* Expand the name of the application. */}}
{{- define "app.name" -}}
{{ .Chart.Name | replace "." "-" }}
{{- end -}}

{{/* Expand the name of the chart. */}}
{{- define "app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Expand the name of the current resource */}}
{{/* The `.currentType` stands for the type of the current pod */}}
{{- define "app.resourceName" -}}
{{ .currentType }}
{{- end -}}

{{/* Expand the name of the app secrets. */}}
{{- define "app.appSecret" -}}
{{ include "app.name" . }}-app-secret
{{- end -}}

{{/* Expand the name of the autocreated secret. */}}
{{- define "app.letsEncryptSecret" -}}
{{ include "app.name" . }}-lets-encrypt-secret
{{- end -}}

{{/* Expand the name of the tls secrets resource. */}}
{{- define "app.tlsSecret" -}}
{{ include "app.name" . }}-tls-secret
{{- end -}}

{{/* Expand the name of the pull secrets resource. */}}
{{- define "app.pullSecret" -}}
{{ include "app.name" . }}-pull-secret
{{- end -}}

{{/* Template for spec selectors */}}
{{/* the `.currentType` stands for the type of current pod */}}
{{- define "app.templateSelector" -}}
app: {{ include "app.name" . }}
component: {{ .currentType }}
{{- end }}

{{/* Labels for metadata of deployments */}}
{{/* the `.currentType` stands for the type of current pod */}}
{{- define "app.templateLabels" -}}
app: {{ include "app.name" . }}
component: {{ .currentType }}
chart: {{ include "app.chart" . }}
revision: v{{ .Release.Revision }}
{{- end }}

{{/* Template metadata for deployments and services */}}
{{/* The `.currentType` stands for the type of the current pod */}}
{{- define "app.metadata" -}}
name: {{ include "app.resourceName" . }}
labels: {{- include "app.templateLabels" . | nindent 2 }}
{{- end }}

{{/* Template for the recreate strategy of deployment */}}
{{/* to be used for pods that must have ONE replica only */}}
{{- define "app.singleRevision" -}}
replicas: {{ if .Values.components.maintenance.enabled }}0{{ else }}1{{ end }}
revisionHistoryLimit: 3
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 1
    maxSurge: 0
{{- end }}

{{/* Template for the recreate strategy of deployment */}}
{{/* to be used for pods that have more than ONE replica */}}
{{/* The `.replicasCount` stands for the configured number of replicas */}}
{{- define "app.multipleRevision" -}}
replicas: {{ if .Values.components.maintenance.enabled }}0{{ else }}{{ .replicasCount }}{{ end }}
revisionHistoryLimit: 3
strategy:
  type: RollingUpdate
  rollingUpdate:
  {{- with .strategy }}
    maxUnavailable: {{ .maxUnavailable }}
    maxSurge: {{ .maxSurge }}
  {{- end }}
{{- end }}

{{- define "app.podAntiAffinity" -}}
podAntiAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchExpressions:
            - key: app
              operator: In
              values:
                - {{ include "app.name" . }}
            - key: component
              operator: In
              values:
                - {{ .currentType }}
        topologyKey: "kubernetes.io/hostname"
{{- end }}

{{/* Template to generate payload for Slack notification */}}
{{- define "app.release.slack.payload" -}}
{{- if .Values.components.maintenance.enabled -}}
{{- printf "{\"attachments\": [{\"text\": \"Bad news, everyone! @%s released *%s* v%d *in maintenance mode* :construction:\", \"color\": \"warning\", \"mrkdwn_in\": [\"text\"]}], \"username\": \"Professor Helmsworth\", \"icon_emoji\": \":goodnews:\"}" .Values.deployment.release.username .Release.Name .Release.Revision -}}
{{- else }}
{{- printf "{\"attachments\": [{\"text\": \"Good news, everyone! @%s released *%s* v%d\", \"color\": \"good\", \"mrkdwn_in\": [\"text\"]}], \"username\": \"Professor Helmsworth\", \"icon_emoji\": \":goodnews:\"}" .Values.deployment.release.username .Release.Name .Release.Revision -}}
{{- end -}}
{{- end -}}
