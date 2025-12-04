{{- define "otel-collectors.selectorLabels" -}}
app.kubernetes.io/part-of: otel-collectors
{{- end -}}

{{- define "otel-collectors.metadataLabels" -}}
{{ include "otel-collectors.selectorLabels" $ }}
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
{{- end -}}

{{- define "otel-collectors.envs" -}}
CLICKSTACK_API_KEY: {{ .Values.clickstack_api_key | b64enc | quote }}
{{- end -}}

{{- define "otel-collectors.envsChecksum" -}}
{{- include "otel-collectors.envs" $ | sha256sum -}}
{{- end -}}
