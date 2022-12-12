#!/bin/bash

# Ref: https://cloud.google.com/iam/docs/configuring-workload-identity-federation#gcloud
PROJECT_ID=savitha-sandbox
PROJECT_NUMBER=841033157812

REPO=minigans/api-infra-service

## Create the workload identity pool and provider for Github actions.
gcloud iam workload-identity-pools create oidc-pool \
    --location=global \
    --display-name='OIDC pool' \
    --project "${PROJECT_ID}"

gcloud iam workload-identity-pools providers create-oidc github-provider \
    --location=global \
    --display-name='Github provider' \
    --workload-identity-pool=oidc-pool \
    --issuer-uri=https://token.actions.githubusercontent.com/ \
    --attribute-mapping="attribute.actor=assertion.actor,attribute.repository=assertion.repository,google.subject=assertion.sub" \
    --project "${PROJECT_ID}"

## Allow this Github repo to impersonate the "github" GCP service account.
gcloud iam service-accounts create github --project "${PROJECT_ID}"
gcloud iam service-accounts add-iam-policy-binding --project "${PROJECT_ID}" \
    --role roles/iam.workloadIdentityUser \
    --member "principalSet://iam.googleapis.com/projects/"${PROJECT_NUMBER}"/locations/global/workloadIdentityPools/oidc-pool/attribute.repository/${REPO}" \
    github@"${PROJECT_ID}".iam.gserviceaccount.com
