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

# Service requires authentication for GET/POST requests
verify_api_code 401 https://dev2-httpbin.mini.ping-fuji.com/get
verify_api_code 401 -X POST https://dev2-httpbin.mini.ping-fuji.com/post

# Incorrect password for user
verify_api_code 401 -u 'user:password-not-right' https://dev2-httpbin.mini.ping-fuji.com/get

# User 'user' has the right password and is authorized to send GET requests
verify_api_code 200 -u 'user:user' https://dev2-httpbin.mini.ping-fuji.com/get

# User 'user' is not authorized to send POST requests
verify_api_code 403 -u 'user:user' -X POST https://dev2-httpbin.mini.ping-fuji.com/post

# User 'admin' has the right password and is authorized to send GET/POST requests
verify_api_code 200 -u 'admin:admin' https://dev2-httpbin.mini.ping-fuji.com/get
verify_api_code 200 -u 'admin:admin' -X POST https://dev2-httpbin.mini.ping-fuji.com/post