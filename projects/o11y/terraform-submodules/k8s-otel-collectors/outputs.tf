output "otlp_grpc_endpoint" {
  value = "${local.otlp_collector_host}:4317"
}

output "otlp_http_endpoint" {
  value = "http://${local.otlp_collector_host}:4318"
}
