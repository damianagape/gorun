# Vaults

## Kubernetes secrets

```
$ kubectl \
  --context="gke_gogcp-test-8_europe-central2-a_gogke-test-8" \
  --namespace="vault-kuard" \
  create secret generic "example" \
  --from-literal="username=exampleAdmin" \
  --from-literal="password=exampleSecret123"
```
