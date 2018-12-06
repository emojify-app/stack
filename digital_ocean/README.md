# Consul Connect on Digital Ocean Example

To set up the Kubernetes cluster on Digital Ocean set your `DIGTALOCEAN_TOKEN` environment variable, then apply the Terraform configuration in this folder.

```bash
$ terraform apply
```

The config will create a cluster and install `Consul` and the `Kubernetes Dashboard`.

## Install the application

There is a demo application in the `demo_files` folder which should be self contained, to install the application.

You will need a machinebox API key which can be obtained from [https://machinebox.io](https://machinebox.io), once you have this create a `demo_files/secret.yml` file with the following contents:

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: emojify
type: Opaque
data:
  mb_key: YOUR_MACHINEBOX_KEY 
```

```bash
# fetch the kube config
make get_k8s_config

# set the kubeconfig env var
export KUBECONFIG=$(pwd)/kube_config.yml

# install the app
kubectl apply -f demo_files/api-with-payment.yml
kubectl apply -f demo_files/facebox.yml
kubectl apply -f demo_files/ingress.yml
kubectl apply -f demo_files/secret.yml
kubectl apply -f demo_files/website-with-payment.yml
```

The application will create a load balancer in Digital Ocean which exposes the application, the IP address can be found in the kubernetes dashboard.

```bash
make open_dashboard
```

## Consul UI
To open the Consul UI run the following command:

```bash
make open_consul_ui
```
