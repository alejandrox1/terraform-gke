# GKE - Kubernetes cluster via Terraform

The one tricky thing with GKE is that you'll need to run the following o
generate a `kubeconfig` file (easiest way):
```
$ export KUBECONFIG=./kubeconfig
$ gcloud container clusters get-credentials terraform-cluster --region us-east1-b
```
