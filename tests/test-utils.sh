#!/bin/bash

function verify_http_code() {
  expected_code="$1"
  # shellcheck disable=SC2124
  request="${@:2}"
  # shellcheck disable=SC2086
  actual_code="$(curl -k -o /dev/null 2>/dev/null -w "%{http_code}" ${request})"
  echo "Request: ${request}; expected_code: ${expected_code}; actual_code: ${actual_code}"
  test "${actual_code}" = "${expected_code}"
}