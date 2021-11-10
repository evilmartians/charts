{{/* 
Template to generate environment variables
*/}}
{{- define "app.env" -}}
- name: RAILS_ENV
  value: {{ .Values.rails.rails_env | quote }}
- name: RAILS_MAX_THREADS
  value: {{ .Values.rails.rails_max_threads | quote }}
- name: WEB_CONCURRENCY
  value: {{ .Values.rails.web_concurrency | quote }}
- name: DATABASE_POOL
  value: {{ .Values.rails.database_pool | quote }}
- name: DATABASE_URL
  valueFrom:
    secretKeyRef:
      name: {{ include "app.appSecret" . }}
      key: databaseUrl
{{- end }}
