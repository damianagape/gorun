{{- define "grafana.selectorLabels" -}}
app.kubernetes.io/part-of: "{{ .Release.Namespace }}"
app.kubernetes.io/instance: "{{ .Release.Name }}"
app.kubernetes.io/name: "{{ .Values.image.repository | replace "/" "." }}"
app.kubernetes.io/component: grafana-server
{{- end -}}

{{- define "grafana.metadataLabels" -}}
{{ include "grafana.selectorLabels" . }}
app.kubernetes.io/version: "{{ .Values.image.tag }}"
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
{{- end -}}
