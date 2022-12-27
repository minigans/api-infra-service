#!/bin/bash

PROJECT_ID=api-service-sandbox-00

gcloud dns managed-zones create api-service-zone \
    --dns-name=api.ping-fuji.com \
    --description 'Public hosted zone for demo purposes' \
    --visibility=public \
    --project "${PROJECT_ID}"

# NOTE: The name servers for this zone (obtained from the NS record) were added to the parent domain ("ping-fuji.com"),
# which lives elsewhere to set up the DNS hierarchy.