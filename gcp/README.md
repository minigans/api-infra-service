# GCP Setup

## Cluster

The [cluster.sh](cluster.sh) script was used to create a simple `Kubernetes` cluster in the sandbox project. This is 
intended to simulate the environment provided by the API infrastructure service. 

## Workload identity federation

The [wif.sh](wif.sh) script was used to set up a workload identity pool and a `Github` provider within the pool. 
Workload identity federation allows the `Github Actions` runners (which is used for CI/CD) to impersonate the 
`github@savitha-sandbox.iam.gserviceaccount.com` GCP service account and exchange the `GitHub` ID token for a 
short-lived `Google Cloud` access token. This GCP service account gives the runners the appropriate access to `Google 
Cloud` resources.

Reference: https://cloud.google.com/iam/docs/configuring-workload-identity-federation#gcloud

## Kubernetes IAM

The [k8s-iam.sh](k8s-iam.sh) script was used to set up IAM permissions for the `external-dns` and `cert-manager` 
`Kubernetes` service accounts to impersonate the corresponding `Google Cloud` service accounts, which have the 
`Cloud DNS Admin` role on the sandbox project.

## DNS

The [dns.sh](dns.sh) script was used to set up a public hosted zone (`mini.ping-fuji.com`) on `Google Cloud DNS`. 
This zone is managed by the `external-dns` service running within `Kubernetes`. The `cert-manager` service also uses 
it to solve the ACME challenge from `Let's Encrypt` to automatically obtain valid CA certificates for endpoints under 
this domain.