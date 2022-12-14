# API infrastructure service

Service owners may host their services on the API infrastructure service. It runs on `Kubernetes` and provides the 
following features.

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

### OAuth2 authentication

A better, more scalable approach to authentication is to use identity federation through the OAuth2 protocol. The 
`nginx-ingress-controller` and an OAuth2 proxy are set up on the cluster for this purpose. An application can configure 
its ingress to use the proxy for authentication. If a user is not authenticated, the proxy will intercept their request
and delegate it to the Google Identity Provider (IdP) for authentication. After authentication, the request is 
redirected back to the original application.

The `Kubernetes` manifests under the [oauth2-authentication-example](k8s/oauth2-authentication-example) directory 
show how this works using an `nginx` ingress. When a user browses to https://hello.api.ping-fuji.com, they will first 
be redirected to authenticate using their Google credentials. The app is only presented to the user after a successful 
login.

The picture on the left in the following diagram illustrates this flow:

![OAuth2 authentication](https://cloud.githubusercontent.com/assets/45028/8027702/bd040b7a-0d6a-11e5-85b9-f8d953d04f39.png)

While this works for authentication, the `nginx-ingress-controller` does not provide any mechanism to authorize a 
user for access to specific APIs.

References:
- https://github.com/oauth2-proxy/oauth2-proxy
- https://kubernetes.github.io/ingress-nginx/examples/auth/oauth-external-auth

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

## Support for both gRPC-based and REST-based connections

The API infrastructure service supports both REST and gRPC APIs. This functionality is automatically provided by the 
`kong` ingress controller. An ingress resource must be annotated with `konghq.com/protocols` to configure it with the 
API types to use on the backend. This may be a comma-separated list of any combination of `http,https,grpc,grpcs`. The 
`Kubernetes` manifests under the example [devteam-1](k8s/devteam-1) directory show how to declaratively create 
ingresses of both kinds.

Reference: https://docs.konghq.com/kubernetes-ingress-controller/latest/guides/using-ingress-with-grpc

## PKI and certificate management

The API infrastructure service leverages ACME for certificate management using `cert-manager` as the ACME client and 
`Let's Encrypt` as the ACME server. Automatic certificate issuance works by proving to the certificate issuer that 
the service owns the domain for its endpoints. ACME allows different ways to prove domain ownership, with the HTTP 
and DNS solvers being the two most popular ones. Both solvers start off with the ACME server generating a token. In 
the HTTP case, the token must be hosted within a `.well-known` endpoint under the domain. In the DNS case, it must 
be hosted in an `_acme-challenge` TXT record under the domain. If the ACME server can read the token from the 
well-known endpoint or the TXT record, then domain ownership is proven, and it can proceed to issuing a certificate.

The `cert-manager` deployment uses a DNS solver using the `api.ping-fuji.com` hosted zone on `Google Cloud DNS`. Any 
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
workflow as shown below:

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
were generated and published by this repo's [publish-api-docs.yaml](.github/workflows/publish-api-docs.yaml) `GitHub 
Actions` workflow.

References:
- https://github.com/pseudomuto/protoc-gen-doc
- https://github.com/marketplace/actions/deploy-to-github-pages