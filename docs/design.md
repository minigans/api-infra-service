# API infrastructure service architecture

The API infrastructure services runs on `Kubernetes`. The platform comprises 3 services running in the cluster:

- kong-ingress-controller
- external-dns
- cert-manager

In addition, a `ClusterIssuer` custom resource is configured to automatically issue and renew certificates from `Let's 
Encrypt`. These are valid CA certificates that are trusted by all browsers.

On the `Google Cloud` side, it uses `Cloud DNS` and `Load Balancer` services as shown in the below diagram.

## Architecture



