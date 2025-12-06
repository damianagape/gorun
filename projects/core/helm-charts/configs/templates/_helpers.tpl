{{- define "configs.selectorLabels" -}}
app.kubernetes.io/part-of: "{{ .Release.Namespace }}"
app.kubernetes.io/instance: "{{ .Release.Name }}"
app.kubernetes.io/component: configs
# TODO remove
app.kubernetes.io/teeeeeest: yeeeeeees
{{- end -}}

{{- define "configs.metadataLabels" -}}
{{ include "configs.selectorLabels" . }}
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
{{- end -}}

{{- define "configs.checksum" -}}
{{- list .Values.envs .Values.secretEnvs .Values.files .Values.secretFiles | toJson | sha256sum -}}
{{- end -}}

{{- define "configs.key" -}}
{{- . | trimPrefix "/" | replace "/" "." -}}
{{- end -}}
