FROM grafana/grafana:12.3

RUN grafana cli plugins install grafana-clickhouse-datasource \
&& grafana cli plugins install googlecloud-logging-datasource \
&& grafana cli plugins install googlecloud-trace-datasource
