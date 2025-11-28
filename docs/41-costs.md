# Costs

## Google Cloud Platform billing accounts

- [XXXXXX-XXXXXX-XXXXXX](https://console.cloud.google.com/billing/XXXXXX-XXXXXX-XXXXXX)
- [YYYYYY-YYYYYY-YYYYYY](https://console.cloud.google.com/billing/YYYYYY-YYYYYY-YYYYYY)
- [ZZZZZZ-ZZZZZZ-ZZZZZZ](https://console.cloud.google.com/billing/ZZZZZZ-ZZZZZZ-ZZZZZZ)

## Kubernetes resources

Get containers CPU and memory requests:

```
$ kubectl get pods -A -o custom-columns="NAMESPACE:.metadata.namespace,POD:.metadata.name,CONTAINER:.spec.containers[*].name,CPU_REQUEST:.spec.containers[*].resources.requests.cpu,MEM_REQUEST:.spec.containers[*].resources.requests.memory"
```
