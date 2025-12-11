#!/bin/bash
set -e

function main {
  kubectl apply --filename=./projects/data/kubernetes-manifests/kubeflow/build.yaml
}

main "$@"
