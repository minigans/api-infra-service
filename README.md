# API infrastructure service

Service owners may host their services on the API infrastructure running on `Kubernetes`. It provides the following 
features:

## Authentication to API and authorization for individual API routes

The API infrastructure service currently only supports basic authentication. It leverages the `kong` ingress 
controller configured with appropriate plugins for both authentication and authorization purposes. The `basic-auth` 
`kong` plugin is used for authentication and the `acl` plugin for authorization.

The `Kubernetes` manifests under the example [devteam-2](k8s/devteam-2) directory show how to declaratively create 
users and basic authentication credentials for those users. For authorization, the users are assigned to specific 
groups, and permissions are granted at the group level. 

A `KongConsumer` custom resource is set up for each user with the `basic-auth` and `acl` credentials giving them 
authentication credentials and memberships to groups, respectively. The `acl` `KongPlugin` resource configures an 
allow-list of groups. Finally, the ingress is configured with the auth/acl plugins to apply using the 
`konghq.com/plugins` annotation. In the example, only admin users are allowed to send POST requests to the service, 
but both admin and non-admin users are allowed to send GET requests.  

Reference: https://docs.konghq.com/kubernetes-ingress-controller/latest/guides/configure-acl-plugin

## Ingress/route management

The API infrastructure service provides the ability to route different parts of an API to different resources or 
services. This functionality is automatically provided by the `kong` ingress controller.

The `Kubernetes` manifests under the example [devteam-1](k8s/devteam-1) directory show how to declaratively create 
ingresses of various kinds.

- The [grpc-ingress.yaml](k8s/devteam-1/grpc-ingress.yaml) shows how to route to a gRPC service.
- The [http-ingress.yaml](k8s/devteam-1/http-ingress.yaml) shows how different paths can route to the same backend 
  service and how different host headers can route to different backend services.
- The [multi-protocol-ingress.yaml](k8s/devteam-1/multi-protocol-ingress.yaml) shows how different paths can route to 
  different backend services using different protocols (one REST and the other gRPC).

Reference: https://docs.konghq.com/kubernetes-ingress-controller/latest/guides/getting-started

## Support for both grpc-based and REST-based connections

The API infrastructure service supports both REST and gRPC APIs. This functionality is automatically provided by the 
`kong` ingress controller. The `Kubernetes` manifests under the example [devteam-1](k8s/devteam-1) directory show how 
to declaratively create ingresses of both kinds.

Reference: https://docs.konghq.com/kubernetes-ingress-controller/latest/guides/using-ingress-with-grpc

## PKI and Certificate management

The API infrastructure service leverages ACME for certificate management using `cert-manager` as the ACME client and 
`Let's Encrypt` as the ACME server. Automatic certificate issuance works by proving to the certificate issuer that 
the service owns the domain for its endpoints. ACME allows different ways to prove domain ownership, with the HTTP 
and DNS solvers being the two most popular ones. Both solvers start off with the ACME server generating a token. In 
the HTTP case, the token must be hosted within a `.well-known` endpoint under the domain. In the DNS case, it must 
be hosted in an `_acme-challenge` TXT record under the domain. If the ACME server can read the token from the 
well-known endpoint or the TXT record, then domain ownership is proven, and it can proceed to issuing a certificate.

The `cert-manager` deployment uses a DNS solver using the `mini.ping-fuji.com` hosted zone on `Google Cloud DNS`. Any 
ingresses using hostnames under this domain will automatically get a valid CA certificate from `Let's Encrypt` when 
configured with the annotation `cert-manager.io/cluster-issuer: letsencrypt`.

Reference: https://cert-manager.io/docs/usage/ingress

## API documentation generation

The API infrastructure service provides tooling (via `GitHub Actions`) to auto-generate API docs for a service. 
Currently, only protobuf/gRPC API spec is supported. The [host-api-docs](actions/host-api-docs/action.yaml) action will 
generate HTML docs for `.proto` files under a specified directory as long as they are tagged with appropriate comments 
per IDL specifications. An example is available in the [Vehicle.proto](sample-proto-files/Vehicle.proto) file. The 
generated docs are then hosted on the repo's GitHub pages.

A service needing docs generated/hosted in its repo's GitHub pages may do so by invoking this action from a GitHub 
workflow as show below:

```
jobs:
  publish-api-docs:
    name: Publish API docs for service to repo GitHub pages
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy API docs to GitHub pages
        uses: minigans/api-infra-service/actions/host-api-docs@main
        with:
          proto-root-dir: sample-proto-files
```

For example, the example API docs for this repo are available at https://minigans.github.io/api-infra-service. They 
were generated and published by the [publish-api-docs.yaml](.github/workflows/publish-api-docs.yaml) GitHub workflow.

References:
- https://github.com/pseudomuto/protoc-gen-doc
- https://github.com/marketplace/actions/deploy-to-github-pages