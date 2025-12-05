{{- define "clickhouse.selectorLabels" -}}
app.kubernetes.io/part-of: "{{ .Release.Namespace }}"
app.kubernetes.io/instance: "{{ .Release.Name }}"
app.kubernetes.io/name: "{{ .Values.image.repository }}"
{{- end -}}

{{- define "clickhouse.metadataLabels" -}}
{{ include "clickhouse.selectorLabels" $ }}
app.kubernetes.io/version: "{{ .Values.image.tag }}"
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
{{- end -}}

{{- define "clickhouse.configsChecksum" -}}
{{- list .Values.configEnvs .Values.secretConfigEnvs | toJson | sha256sum -}}
{{- end -}}
