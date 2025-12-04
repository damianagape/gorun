{{- define "otelcol.selectorLabels" -}}
app.kubernetes.io/part-of: "{{ .Release.Namespace }}"
app.kubernetes.io/instance: "{{ .Release.Name }}"
app.kubernetes.io/name: ""
{{- end -}}

{{- define "otelcol.metadataLabels" -}}
{{ include "otelcol.selectorLabels" $ }}
app.kubernetes.io/version: ""
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
{{- end -}}

{{- define "otelcol.collector.envsChecksum" -}}
{{- list .Values.collector.envs .Values.collector.secretEnvs | toJson | sha256sum -}}
{{- end -}}
