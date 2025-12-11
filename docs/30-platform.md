# Internal Developer Platform (IDP)

## Google Cloud Platform projects

- [gogcp-main-7](https://console.cloud.google.com/home/dashboard?project=gogcp-main-7)
- [gogcp-test-7](https://console.cloud.google.com/home/dashboard?project=gogcp-test-7)
- [gogcp-prod-7](https://console.cloud.google.com/home/dashboard?project=gogcp-prod-7)

```
$ gcloud config set project "gogcp-main-7"
$ gcloud config set compute/region "europe-central2"
$ gcloud config set compute/zone "europe-central2-a"
```

## Terraform state buckets

- [gogcp-main-7-terraform-state](https://console.cloud.google.com/storage/browser/gogcp-main-7-terraform-state?project=gogcp-main-7)

## Docker images registries

- [europe-central2-docker.pkg.dev/gogcp-main-7/public-docker-images](https://console.cloud.google.com/artifacts/docker/gogcp-main-7/europe-central2/public-docker-images?project=gogcp-main-7)
- [europe-central2-docker.pkg.dev/gogcp-main-7/private-docker-images](https://console.cloud.google.com/artifacts/docker/gogcp-main-7/europe-central2/private-docker-images?project=gogcp-main-7)

```
$ gcloud auth configure-docker "europe-central2-docker.pkg.dev"
```

## Helm charts registries

- [oci://europe-central2-docker.pkg.dev/gogcp-main-7/public-helm-charts](https://console.cloud.google.com/artifacts/docker/gogcp-main-7/europe-central2/public-helm-charts?project=gogcp-main-7)
- [oci://europe-central2-docker.pkg.dev/gogcp-main-7/private-helm-charts](https://console.cloud.google.com/artifacts/docker/gogcp-main-7/europe-central2/private-helm-charts?project=gogcp-main-7)

```
$ gcloud auth print-access-token | helm registry login --username="oauth2accesstoken" --password-stdin "europe-central2-docker.pkg.dev"
```

## Terraform submodules registries

- [gogcp-main-7-public-terraform-modules](https://console.cloud.google.com/storage/browser/gogcp-main-7-public-terraform-modules?project=gogcp-main-7)
- [gogcp-main-7-private-terraform-modules](https://console.cloud.google.com/storage/browser/gogcp-main-7-private-terraform-modules?project=gogcp-main-7)

## Kubernetes clusters

- [gke_gogcp-test-7_europe-central2-a_gogke-test-7](https://console.cloud.google.com/kubernetes/clusters/details/europe-central2-a/gogke-test-7/details?project=gogcp-test-7)

```
$ gcloud --project="gogcp-test-7" container clusters --region="europe-central2-a" get-credentials "gogke-test-7"
$ kubectl config set-context "gke_gogcp-test-7_europe-central2-a_gogke-test-7"
$ kubectl config set-context --current --namespace="gomod-test-7"
```

## Kubeflow platforms

- [kubeflow.gogke-test-7.damianagape.pl](https://kubeflow.gogke-test-7.damianagape.pl)
