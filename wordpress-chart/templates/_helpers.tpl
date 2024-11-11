{{- define "wordpress.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end -}}

{{- define "wordpress.name" -}}
{{ .Release.Name }}
{{- end -}}

{{- define "my-wordpress.fullname" -}}
{{ .Release.Name }}-wordpress
{{- end -}}

{{- define "my-wordpress.name" -}}
{{ .Release.Name }}
{{- end -}}
