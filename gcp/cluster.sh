#!/bin/bash

PROJECT_ID=savitha-sandbox

gcloud projects create "${PROJECT_ID}"
gcloud container clusters create savitha \
    --project "${PROJECT_ID}" \
    --workload-pool="${PROJECT_ID}".svc.id.goog