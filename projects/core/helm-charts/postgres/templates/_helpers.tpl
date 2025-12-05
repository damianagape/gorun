{{- define "postgres.selectorLabels" -}}
app.kubernetes.io/part-of: "{{ .Release.Namespace }}"
app.kubernetes.io/instance: "{{ .Release.Name }}"
app.kubernetes.io/name: "{{ join "." (splitList "/" .Values.image.repository) }}"
{{- end -}}

{{- define "postgres.metadataLabels" -}}
{{ include "postgres.selectorLabels" $ }}
app.kubernetes.io/version: "{{ .Values.image.tag }}"
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
{{- end -}}

{{- define "postgres.configsChecksum" -}}
{{- list .Values.configEnvs .Values.secretConfigEnvs | toJson | sha256sum -}}
{{- end -}}
