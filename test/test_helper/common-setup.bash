#!/usr/bin/env bash

# Common test environment setup.
# Loads bats-support and bats-assert libraries.
# Set PROJECT_ROOT environment variable.
# Add PROJECT_ROOT/src to PATH.
_common_setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    PROJECT_ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )/.." >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$PROJECT_ROOT/src:$PATH"
}

# Common test environment teardown.
_common_teardown() {
    # Nothing to teardown.
    echo -n ""
}