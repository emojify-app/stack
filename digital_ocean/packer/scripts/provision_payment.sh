#!/bin/bash -e
consul_version=1.4.0
payments_version=0.1.0

apt-get update
apt-get install -y curl default-jdk unzip

# Install Consul
wget -O /tmp/consul.zip "https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip"
cd /tmp
unzip -o ./consul.zip
mv -f ./consul /usr/local/bin/
mkdir -p /etc/consul.d
mkdir -p /etc/consul.d/data

tee /etc/systemd/system/consul.service > /dev/null <<"EOF"
  [Unit]
  Description = "Consul"
  
  [Service]
  KillSignal=INT
  ExecStart=/usr/local/bin/consul agent -retry-join 'provider=k8s label_selector="app=consul,component=server" kubeconfig=/home/ubuntu/.kube/config' -data-dir=/etc/consul.d/data -config-dir=/etc/consul.d
  Restart=always
EOF

systemctl enable consul.service
systemctl add-wants multi-user.target consul.service

# Provision payments service
mkdir /app
cd /app
wget -O /app/spring-boot-payments-${payments_version}.jar https://github.com/emojify-app/payments/releases/download/v${payments_version}/spring-boot-payments-${payments_version}.jar
tee /etc/systemd/system/payment.service > /dev/null <<"EOF"
  [Unit]
  Description = "Payments Service"
  
  [Service]
  KillSignal=INT
  ExecStart=/usr/bin/java -jar /app/spring-boot-payments-0.1.0.jar
  Restart=always
EOF

systemctl enable payment.service
systemctl add-wants multi-user.target payment.service

# Register the service with consul
tee /etc/consul.d/payment.hcl > /dev/null <<"EOF"
service {
  name = "payment"
  port = 8080
  check {
    id = "payment-check"
    name = "Payment Health Check"
    http = "http://localhost:8080/health"
    method = "GET"
    interval = "10s"
    timeout = "1s"
  }
}
EOF

# Add the consul connect proxy
tee /etc/systemd/system/payment-proxy.service > /dev/null <<"EOF"
  [Unit]
  Description = "Consul Connect Proxy"
  
  [Service]
  KillSignal=INT
  ExecStart=/usr/local/bin/consul connect proxy -log-level=DEBUG -service payment -http-addr localhost:8500 -listen :8443 -service-addr localhost:8080 -register
  Restart=always
EOF

systemctl enable payment-proxy.service
systemctl add-wants multi-user.target payment-proxy.service
