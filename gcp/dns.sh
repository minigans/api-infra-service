#!/bin/bash

PROJECT_ID=savitha-sandbox

gcloud dns managed-zones create savitha \
    --dns-name=mini.ping-fuji.com \
    --description 'Public hosted zone for demo purposes' \
    --visibility=public \
    --project "${PROJECT_ID}"

# NOTE: The name servers for this zone (obtained from the NS record) were added to the parent domain ("ping-fuji.com"),
# which lives elsewhere to set up the DNS hierarchy.