UNAME := $(shell uname)


ifeq ($(UNAME),Darwin) #Mac OS
	OPEN = "open"
    echo "Darwin"
endif

ifeq ($(UNAME),Linux) #Linux based systems
	OPEN = "xdg-open"
endif

# Open the Kubernetes dashboard, runs kubectl proxy in the background
open_dashboard: get_k8s_config
	@KUBECONFIG=$(shell pwd)/kube_config.yml kubectl proxy --address="0.0.0.0" --accept-hosts="^*$$" & echo $$! > .pid_kube_proxy
	sleep 3
	@echo "Opening dashboard, To quit, press Ctrl-C"

	@$(shell $(OPEN) "http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/overview?namespace=default")
	@bash -c "trap 'pkill -F .pid_kube_proxy' SIGINT SIGTERM ERR EXIT; sleep 20000"

# Fetch the kubernetes config from the core state
get_k8s_config:
	@echo "Fetching kubernetes config from core state"
	$(call terraform_output, k8s_config) > ./kube_config.yml

# Open the Consul UI, runs kubectl port forward in the background
open_consul_ui: get_k8s_config
	@KUBECONFIG=$(shell pwd)/kube_config.yml kubectl port-forward --address 0.0.0.0 svc/consul-ui 8502:80 & echo $$! > .pid_kube_ports
	@echo "Opening Consul UI, To quit, press Ctrl-C"
	@sleep 3
	@$(shell $(OPEN) "http://localhost:8502/ui")
	@bash -c "trap 'pkill -F .pid_kube_ports' SIGINT SIGTERM ERR EXIT; sleep 20000"

ssh_payment: get_payment_private_key
	@echo "Logging into Payment server"
	ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ./payment_key.pem root@$(shell terraform output payment_host)

get_payment_private_key:
	$(call terraform_output, payment_key) > payment_key.pem
	@chmod 0600 ./payment_key.pem

define terraform_output
	@bash -c "terraform output $(1)"
endef
