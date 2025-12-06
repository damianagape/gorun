{{- define "postgres.selectorLabels" -}}
app.kubernetes.io/part-of: "{{ .Release.Namespace }}"
app.kubernetes.io/instance: "{{ .Release.Name }}"
app.kubernetes.io/name: "{{ .Values.image.repository | replace "/" "." }}"
app.kubernetes.io/component: postgres-server
{{- end -}}

{{- define "postgres.metadataLabels" -}}
{{ include "postgres.selectorLabels" . }}
app.kubernetes.io/version: "{{ .Values.image.tag }}"
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
{{- end -}}

{{- define "postgres.configsChecksum" -}}
{{- list .Values.configEnvs .Values.secretConfigEnvs | toJson | sha256sum -}}
{{- end -}}
