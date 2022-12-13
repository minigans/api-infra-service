#!/bin/bash -e

trap 'popd &> /dev/null' EXIT

SCRIPT_DIR="$(cd "$(dirname "${0}")"; pwd)"
pushd "${SCRIPT_DIR}" &> /dev/null

source ../test-utils.sh

echo ---
echo "Running test ${SCRIPT_DIR}/$(basename "$0"):"
echo

# Service requires authentication for GET/POST requests
verify_http_code 401 https://dev2-httpbin.mini.ping-fuji.com/get
verify_http_code 401 -X POST https://dev2-httpbin.mini.ping-fuji.com/post

# Incorrect password for user
verify_http_code 401 -u 'user:password-not-right' https://dev2-httpbin.mini.ping-fuji.com/get

# User 'user' has the right password and is authorized to send GET requests
verify_http_code 200 -u 'user:user' https://dev2-httpbin.mini.ping-fuji.com/get

# User 'user' is not authorized to send POST requests
verify_http_code 403 -u 'user:user' -X POST https://dev2-httpbin.mini.ping-fuji.com/post

# User 'admin' has the right password and is authorized to send GET/POST requests
verify_http_code 200 -u 'admin:admin' https://dev2-httpbin.mini.ping-fuji.com/get
verify_http_code 200 -u 'admin:admin' -X POST https://dev2-httpbin.mini.ping-fuji.com/post