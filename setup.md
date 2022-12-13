### Set up GCP resources

Set up GCP resources using the [README.doc](gcp/README.md) in the [gcp](gcp) directory. The `gcloud` CLI tool and 
a `Google` account are required pre-requisites for this step. 

References:
- [Install gcloud CLI](https://cloud.google.com/sdk/docs/install)
- [GCloud SDK cheat sheet](https://cloud.google.com/sdk/docs/cheatsheet)

### Install skaffold

The `skaffold` CLI facilitates continuous development for container based and `Kubernetes` applications. We will 
leverage it to deploy manifests and `Helm` charts onto the cluster. The following command shows how to install 
`skaffold` on `MacOS`. For other platforms, check out the installation guide at https://skaffold.dev/docs/install.

```bash
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-darwin-amd64 && \
    sudo install skaffold /usr/local/bin/
```

Reference: https://skaffold.dev/docs

### Set up the API infrastructure service

The [skaffold.yaml](skaffold.yaml) file declares the `Kubernetes` manifests and `Helm` charts to install in the 
cluster to configure and test the API infrastructure service. To bring up the infrastructure service, simply run the 
following command from the root directory of this repo:

```bash
skaffold deploy
````

### Testing the service

A few basic tests are available under the [tests](tests) directory. Use these steps to run them all:

```bash
cd tests
./test-all.sh
```

The [test-all.out](tests/test-all.out) file shows sample output for the currently deployed ingresses and docs.