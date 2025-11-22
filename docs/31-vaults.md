# Vaults

## Kubernetes secrets

```
$ kubectl \
  --context="gke_gogcp-test-7_europe-central2-a_gogke-test-7" \
  --namespace="vault-kuard" \
  create secret generic "example" \
  --from-literal="username=exampleAdmin" \
  --from-literal="password=exampleSecret123"
```
