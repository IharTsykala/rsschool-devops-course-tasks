{{- define "my-wordpress.fullname" -}}
{{- printf "%s-%s" .Release.Name "wordpress" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "my-wordpress.name" -}}
{{- printf "%s" .Release.Name -}}
{{- end -}}
