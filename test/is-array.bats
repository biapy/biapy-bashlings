#!/usr/bin/env bats
# is-array.bats
# Test is-array.bash:is-array function.

# shellcheck source-path=SCRIPTDIR../src

# Setup test environment.
setup() {
    # Load bats libraries.
    load 'test_helper/common-setup'
    _common_setup

    # Sourcing is-array.bash
    source "${PROJECT_ROOT}/src/is-array.bash"
}

# Teardown test environment.
teardown() {
    _common_teardown
}

# bats file_tags=function:is-array,scope:public

@test "fail with error on missing argument" {
    run is-array
    assert_failure
    assert_output "Error: is-array requires one and only one argument."
}

@test "fail with error on more than one argument" {
    run is-array "var1" "var2"
    assert_failure
    assert_output "Error: is-array requires one and only one argument."
}

@test "fail for string with space" {
    run is-array "a string"
    assert_failure
    assert_output ""
}

@test "fail for unset variable" {
    run is-array "unset_variable"
    assert_failure
    assert_output ""
}

@test "fail for set variable (int)" {
    set_variable=10
    run is-array "set_variable"
    assert_failure
    assert_output ""
}

@test "fail for set variable (string)" {
    set_variable="string"
    run is-array "set_variable"
    assert_failure
    assert_output ""
}

@test "success for set variable (empty array)" {
    set_variable=()
    run is-array "set_variable"
    assert_success
    assert_output ""
}

@test "success for set variable (array)" {
    # Disable SC2034 false positive.
    # shellcheck disable=SC2034
    set_variable=(1 "2" "three")
    run is-array "set_variable"
    assert_success
    assert_output ""
}
