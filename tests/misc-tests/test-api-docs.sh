#!/bin/bash -e

trap 'popd &> /dev/null' EXIT

SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
pushd "${SCRIPT_DIR}" &> /dev/null

source ../test-utils.sh

echo ---
echo "Running test ${SCRIPT_DIR}/$(basename "$0"):"
echo

verify_http_code 301 https://minigans.github.io/api-infra-service