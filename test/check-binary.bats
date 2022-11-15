#!/usr/bin/env ./test/bats/bin/bats
# check-binary.bats
# Test check-binary.bash:check-binary function.

# shellcheck source-path=SCRIPTDIR../src

# Setup test environment.
setup() {
    # Load bats libraries.
    load 'test_helper/common-setup'
    load 'test_helper/files-setup'
    _common_setup
    _files_setup

    # Sourcing check-binary.bash
    source "${PROJECT_ROOT}/src/check-binary.bash"
}

# Teardown test environment.
teardown() {
    _common_teardown
    _files_teardown
}

# bats file_tags=function:check-binary,scope:public

@test "fail on missing argument" {
    run check-binary "first-arg"
    assert_failure
    assert_output "Error: check-binary must have two and only two arguments."
}

@test "fail on more than two arguments" {
    run check-binary "first-arg" "second-arg" "third-arg"
    assert_failure
    assert_output "Error: check-binary must have two and only two arguments."
}

@test "get existing binary path" {
    run check-binary "sh" "package-name"
    assert_success
    assert_output "/usr/bin/sh"
}

@test "get alternative existing binary path" {
    run check-binary "dummy-non-existant-binary;sh" "package-name"
    assert_success
    assert_output "/usr/bin/sh"
}

@test "get package name prompt for missing binary" {
    run check-binary "dummy-non-existant-binary" "package-name"
    assert_failure
    assert_output "Error: 'dummy-non-existant-binary' is missing. Please install package 'package-name'."
}
