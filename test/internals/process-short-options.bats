#!/usr/bin/env bats
# test/internals/process-short-options.bats
# Test src/internals/process-short-options.bash:process-short-options function.

# Setup test environment.
setup() {
    # Load bats libraries.
    load '../test_helper/common-setup'
    _common_setup

    # Sourcing process-options.bash
    source "${PROJECT_ROOT}/src/internals/process-short-options.bash"
}

# Teardown test environment.
teardown() {
    _common_teardown
}

# bats file_tags=function:process-short-options,scope:private

@test "fail on no arguments" {
    run process-short-options
    assert_failure 1
    assert_output "Error: process-short-options must have only one argument."
}

@test "fail on 3 arguments" {
    run process-short-options 1 2
    assert_failure 1
    assert_output "Error: process-short-options must have only one argument."
}

@test "fail on missing allowed_options environment variable" {
    run process-short-options "-option"
    assert_failure 1
    assert_output "Error: validate-option requires allowed_options variable to be set."
}

@test "fail on allowed_options environment variable not an array" {
    allowed_options="not an array"
    run process-short-options "-option"
    assert_failure 1
    assert_output "Error: validate-option requires allowed_options variable to be an array."
}

@test "fail on value without dash" {
    allowed_options=("o*" "option-with-value")
    run process-short-options "value"
    assert_failure 2
    assert_output ""
}

@test "fail on short option with value" {
    allowed_options=("o*" "option-with-value")
    run process-short-options "-o=value"
    assert_failure 2
    assert_output ""
}

@test "fail on unallowed short option" {
    allowed_options=("o" "option")
    run process-short-options "-os"
    assert_failure 1
    assert_output "Error: option '-s' is not recognised."
}

@test "fail on long option without double dash" {
    allowed_options=("o" "option-with-value")
    run process-short-options "-option-with-value"
    assert_failure
    assert_output ""
}

@test "success on short option without value" {
    allowed_options=("o" "k" "option-with-value")
    run process-short-options "-ok"
    assert_success
    assert_output ""
}

@test "success on short option without value (assignation test)" {
    # Disable SC2034 false positive.
    # shellcheck disable=SC2034
    allowed_options=("o" "k" "option-with-value")
    o=""
    k=""
    process-short-options "-ok"
    assert_equal "${o}" 1
    assert_equal "${k}" 1
}
