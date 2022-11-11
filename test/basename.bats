#!/usr/bin/env ./test/bats/bin/bats
# basename.bats
# Test basename.bash:basename function.

# Setup test environment.
setup() {
    # Load bats libraries.
    load 'test_helper/common-setup'
    _common_setup

    # Sourcing basename.bash
    source "${PROJECT_ROOT}/src/basename.bash"
}

# Teardown test environment.
teardown() {
    _common_teardown
}

# bats file_tags=function:basename,scope:public

@test "get basename from complete path" {
    run basename "/path/to/file"
    assert_success
    assert_output "file"
}

@test "get basename from relative path" {
    run basename "../to/file"
    assert_success
    assert_output "file"
}

@test "get basename from filename" {
    run basename "file"
    assert_success
    assert_output "file"
}

@test "get basename from filename starting with -" {
    run basename "-file"
    assert_success
    assert_output "-file"
}

@test "fail on missing argument" {
    run basename
    assert_failure
    assert_output "Error: basename must have one and only one argument."
}

@test "pass on empty argument" {
    run basename ""
    assert_success
    assert_output ""
}

@test "fail on more than one argument" {
    run basename "/path/to/file" "/path/to/other-file"
    assert_failure
    assert_output "Error: basename must have one and only one argument."
}
