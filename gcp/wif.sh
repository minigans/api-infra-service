#!/bin/bash

# Ref: https://cloud.google.com/iam/docs/configuring-workload-identity-federation#gcloud
PROJECT_ID=api-service-sandbox-00
PROJECT_NUMBER=709671997536

REPO=minigans/api-infra-service

## Create the workload identity pool and provider for GitHub actions.
gcloud iam workload-identity-pools create oidc-pool \
    --location=global \
    --display-name='OIDC pool' \
    --project "${PROJECT_ID}"

gcloud iam workload-identity-pools providers create-oidc github-provider \
    --location=global \
    --display-name='GitHub provider' \
    --workload-identity-pool=oidc-pool \
    --issuer-uri=https://token.actions.githubusercontent.com/ \
    --attribute-mapping="attribute.actor=assertion.actor,attribute.repository=assertion.repository,google.subject=assertion.sub" \
    --project "${PROJECT_ID}"

## Create a "github" GCP SA and grant it permissions to deploy to GKE.
gcloud iam service-accounts create github --project "${PROJECT_ID}"
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member=serviceAccount:github@"${PROJECT_ID}".iam.gserviceaccount.com \
    --role=roles/container.admin

## Allow this GitHub repo to impersonate the "github" GCP service account.
gcloud iam service-accounts add-iam-policy-binding --project "${PROJECT_ID}" \
    --role roles/iam.workloadIdentityUser \
    --member "principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/oidc-pool/attribute.repository/${REPO}" \
    github@"${PROJECT_ID}".iam.gserviceaccount.com