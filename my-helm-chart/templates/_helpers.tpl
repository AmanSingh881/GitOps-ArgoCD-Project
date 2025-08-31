{{- define "my-helm-chart.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "my-helm-chart.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end }}
