x; for ip in 10.0.2.{20..21}; do for port in {8080..9000}; do timeout 0.01s $(echo > /dev/tcp/${ip}/${port}) $> /dev/null && echo server ${ip} port ${port} open; done; done
