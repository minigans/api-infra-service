# GCP Setup

## Cluster

The [cluster.sh](cluster.sh) script was used to create a sandbox `Google Cloud` project and a simple `Kubernetes` 
cluster within the project. This is intended to simulate the environment provided by the API infrastructure service. 

## Kubernetes IAM

The [k8s-iam.sh](k8s-iam.sh) script was used to set up IAM permissions for the `external-dns` and `cert-manager` 
`Kubernetes` service accounts to impersonate the corresponding `Google Cloud` service accounts using workload 
identity federation. Both GCP service accounts are granted the `Cloud DNS Admin` role on the sandbox project.

Reference: https://cloud.google.com/iam/docs/configuring-workload-identity-federation#gcloud

## DNS

The [dns.sh](dns.sh) script was used to set up a public hosted zone (`mini.ping-fuji.com`) on `Google Cloud DNS`. 
This zone is managed by the `external-dns` service running within `Kubernetes`. The `cert-manager` service also uses 
it to solve the ACME challenge from `Let's Encrypt` to automatically obtain valid CA certificates for endpoints under 
this domain.