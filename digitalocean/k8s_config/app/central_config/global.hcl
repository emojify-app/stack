Kind = "proxy-defaults"
Name = "global"
Config {
	local_connect_timeout_ms = 1000
	handshake_timeout_ms = 10000
	envoy_dogstatsd_url = "udp://127.0.0.1:9125"
  envoy_extra_static_clusters_json = <<EOL
    {
      "connect_timeout": "3.000s",
      "dns_lookup_family": "V4_ONLY",
      "lb_policy": "ROUND_ROBIN",
      "load_assignment": {
          "cluster_name": "cluster_tracing_honeycomb_opentracing_proxy_9411",
          "endpoints": [
              {
                  "lb_endpoints": [
                      {
                          "endpoint": {
                              "address": {
                                  "socket_address": {
                                      "address": "honeycomb-opentracing-proxy",
                                      "port_value": 9411,
                                      "protocol": "TCP"
                                  }
                              }
                          }
                      }
                  ]
              }
          ]
      },
      "name": "cluster_tracing_honeycomb_opentracing_proxy_9411",
      "type": "STRICT_DNS"
    }
  EOL

  envoy_tracing_json = <<EOL
    {
        "http": {
            "config": {
                "collector_cluster": "cluster_tracing_honeycomb_opentracing_proxy_9411",
                "collector_endpoint": "/api/v1/spans"
            },
            "name": "envoy.zipkin"
        }
    }
  EOL
 }
