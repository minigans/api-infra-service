#!/bin/bash -e

function verify_api_code() {
  expected_code="$1"
  # shellcheck disable=SC2124
  request="${@:2}"
  # shellcheck disable=SC2086
  actual_code="$(curl -k -o /dev/null 2>/dev/null -w "%{http_code}" ${request})"
  echo "Request: ${request}; expected_code: ${expected_code}; actual_code: ${actual_code}"
  test "${actual_code}" = "${expected_code}"
}

# Test ingress with different host headers
verify_api_code 200 https://echo.mini.ping-fuji.com
verify_api_code 200 https://httpbin.mini.ping-fuji.com

# Test ingress with same host header but different paths
verify_api_code 200 https://svc.mini.ping-fuji.com/echo1
verify_api_code 200 https://svc.mini.ping-fuji.com/echo2

# Test http ingress in multi-protocol ingress
verify_api_code 200 https://all.mini.ping-fuji.com/echo

# Test POST requests
verify_api_code 200 -X POST https://httpbin.mini.ping-fuji.com/post

# Send request to non-existent path
verify_api_code 404 https://httpbin.mini.ping-fuji.com/does-not-exist

# Send request to /post resource with GET request
verify_api_code 405 -X GET https://httpbin.mini.ping-fuji.com/post

# Test 500 errors
verify_api_code 500 -X GET https://httpbin.mini.ping-fuji.com/status/500