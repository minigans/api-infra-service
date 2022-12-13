#!/bin/bash -e

trap 'popd &> /dev/null' EXIT

SCRIPT_DIR="$(cd "$(dirname "${0}")"; pwd)"
pushd "${SCRIPT_DIR}" &> /dev/null

source ../test-utils.sh

echo ---
echo "Running test ${SCRIPT_DIR}/$(basename "$0"):"
echo

grpcurl -d '{"greeting": "Kong Hello world using grcpbin ingress!"}' \
  -insecure \
  grcpbin.mini.ping-fuji.com:443 hello.HelloService.SayHello

grpcurl -d '{"greeting": "Kong Hello world using multi-protocol ingress!"}' \
  -insecure \
  all.mini.ping-fuji.com:443 hello.HelloService.SayHello