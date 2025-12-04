output "otlp_grpc_endpoint" {
  value = "otlp-collector.o11y-otlp-collector.svc.cluster.local:4317"
}

output "otlp_http_endpoint" {
  value = "http://otlp-collector.o11y-otlp-collector.svc.cluster.local:4318"
}
