#!/bin/bash -e

SCRIPT_DIR="$(cd "$(dirname "${0}")"; pwd)"
TEST_SCRIPTS="$(find "${SCRIPT_DIR}" -name '*.sh' -mindepth 2)"

for TEST_SCRIPT in ${TEST_SCRIPTS}; do
  ${TEST_SCRIPT}
done