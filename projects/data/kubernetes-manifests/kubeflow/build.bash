#!/bin/bash
set -e

function main {
  kubectl kustomize ./projects/data/kubernetes-manifests/kubeflow \
    --output=./projects/data/kubernetes-manifests/kubeflow/build.yaml
}

main "$@"
