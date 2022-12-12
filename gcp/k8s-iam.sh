#!/bin/bash

PROJECT_ID=savitha-sandbox

## Create GCP service accounts for external-dns and cert-manager.
gcloud iam service-accounts create external-dns --project "${PROJECT_ID}"
gcloud iam service-accounts create cert-manager --project "${PROJECT_ID}"

## Grant the service account CloudDNS admin role.
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member=serviceAccount:external-dns@"${PROJECT_ID}".iam.gserviceaccount.com \
    --role=roles/dns.admin
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member=serviceAccount:cert-manager@"${PROJECT_ID}".iam.gserviceaccount.com \
    --role=roles/dns.admin

## Allow the Kubernetes service accounts to impersonate the GCP service account as a workload identity user.
gcloud iam service-accounts add-iam-policy-binding --project "${PROJECT_ID}" \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:${PROJECT_ID}.svc.id.goog[external-dns/external-dns]" \
    external-dns@"${PROJECT_ID}".iam.gserviceaccount.com
gcloud iam service-accounts add-iam-policy-binding --project "${PROJECT_ID}" \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:${PROJECT_ID}.svc.id.goog[cert-manager/cert-manager]" \
    cert-manager@"${PROJECT_ID}".iam.gserviceaccount.com