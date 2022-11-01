#!/usr/bin/env bash

# Common test environment setup.
# Loads bats-support and bats-assert libraries.
# Set PROJECT_ROOT environment variable.
# Add PROJECT_ROOT/src to PATH.
_common_setup() {
    load "${BASH_SOURCE[0]%/*}/bats-support/load"
    load "${BASH_SOURCE[0]%/*}/bats-assert/load"
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    # shellcheck disable=SC2154
    PROJECT_ROOT="$( cd "${BATS_TEST_FILENAME%\/test\/*}/" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="${PROJECT_ROOT}/src:${PATH}"
}

# Common test environment teardown.
_common_teardown() {
    # Nothing to teardown.
    echo -n ""
}
