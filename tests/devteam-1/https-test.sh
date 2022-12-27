#!/bin/bash -e

trap 'popd &> /dev/null' EXIT

SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
pushd "${SCRIPT_DIR}" &> /dev/null

source ../test-utils.sh

echo ---
echo "Running test ${SCRIPT_DIR}/$(basename "$0"):"
echo

# Test ingress with different host headers
verify_http_code 200 https://echo.api.ping-fuji.com
verify_http_code 200 https://httpbin.api.ping-fuji.com

# Test ingress with same host header but different paths
verify_http_code 200 https://svc.api.ping-fuji.com/echo1
verify_http_code 200 https://svc.api.ping-fuji.com/echo2

# Test http ingress in multi-protocol ingress
verify_http_code 200 https://all.api.ping-fuji.com/echo

# Test POST requests
verify_http_code 200 -X POST https://httpbin.api.ping-fuji.com/post

# Send request to non-existent path
verify_http_code 404 https://httpbin.api.ping-fuji.com/does-not-exist

# Send request to /post resource with GET request
verify_http_code 405 -X GET https://httpbin.api.ping-fuji.com/post

# Test 500 errors
verify_http_code 500 -X GET https://httpbin.api.ping-fuji.com/status/500