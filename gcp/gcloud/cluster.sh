#!/bin/bash

PROJECT_ID=api-service-sandbox-00
CLUSTER=api-infra-service

gcloud projects create "${PROJECT_ID}"
gcloud container clusters create "${CLUSTER}" \
    --project "${PROJECT_ID}" \
    --workload-pool "${PROJECT_ID}".svc.id.goog