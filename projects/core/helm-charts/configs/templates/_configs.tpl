{{- define "configs.annotations" -}}
checksum/configs: "{{ include "configs.checksum" . }}"
{{- end -}}

{{- define "configs.envFrom" -}}
- configMapRef:
    name: "{{ .Release.Name }}-config-envs"
- secretRef:
    name: "{{ .Release.Name }}-config-envs"
{{- end -}}

{{- define "configs.volumeMounts" -}}
- name: config-files
  mountPath: "{{ .Values.mountPath }}"
  readOnly: true
{{- end -}}

{{- define "configs.volumes" -}}
- name: config-files
  projected:
    sources:
      - configMap:
          name: "{{ .Release.Name }}-config-files"
          {{- if .Values.files }}
          items:
            {{- range $key, $_ := .Values.files }}
            - key: "{{ include "configs.key" $key }}"
              path: "{{ $key }}"
            {{- end }}
          {{- end }}
      - secret:
          name: "{{ .Release.Name }}-config-files"
          {{- if .Values.secretFiles }}
          items:
            {{- range $key, $_ := .Values.secretFiles }}
            - key: "{{ include "configs.key" $key }}"
              path: "{{ $key }}"
            {{- end }}
          {{- end }}
{{- end -}}
