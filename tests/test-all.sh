#!/bin/bash -e

TEST_SCRIPTS="$(find . -name '*.sh' -mindepth 2)"
for TEST_SCRIPT in ${TEST_SCRIPTS}; do
  ${TEST_SCRIPT}
done