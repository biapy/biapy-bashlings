#!/usr/bin/env ./test/bats/bin/bats
# test/internals/process-long-option.bats
# Test src/internals/process-long-option.bash:process-long-option function.

# Setup test environment.
setup() {
    # Load bats libraries.
    load '../test_helper/common-setup'
    _common_setup

    # Sourcing process-options.bash
    source "${PROJECT_ROOT}/src/internals/process-long-option.bash"
}

# Teardown test environment.
teardown() {
    _common_teardown
}

# bats file_tags=function:process-options,scope:private

@test "fail on no arguments" {
    run process-long-option
    assert_failure 1
    assert_output "Error: process-long-option must have only one argument."
}

@test "fail on 3 arguments" {
    run process-long-option 1 2
    assert_failure 1
    assert_output "Error: process-long-option must have only one argument."
}

@test "fail on missing allowed_options environment variable" {
    run process-long-option "--option"
    assert_failure 1
    assert_output "Error: validate-option requires allowed_options variable to be set."
}

@test "fail on allowed_options environment variable not an array" {
    allowed_options="not an array"
    run process-long-option "--option"
    assert_failure 1
    assert_output "Error: validate-option requires allowed_options variable to be an array."
}

@test "fail on value without dash" {
    allowed_options=( "o*" "option-with-value" )
    run process-long-option "value"
    assert_failure 2
    assert_output ""
}

@test "fail on unallowed long option" {
    allowed_options=( "o" "option" )
    run process-long-option "--some-option"
    assert_failure 1
    assert_output "Error: option '--some-option' is not recognised."
}

@test "fail on long option with unallowed value" {
    allowed_options=( "o" "option-with-value" )
    run process-long-option "--option-with-value=value"
    assert_failure 1
    assert_output "Error: --option-with-value does not accept arguments."
}

@test "fail on long option with missing mandatory value" {
    allowed_options=( "o" "option-with-value+" )
    run process-long-option "--option-with-value"
    assert_failure 1
    assert_output "Error: --option-with-value requires an argument."
}

@test "success on long option with mandatory value" {
    allowed_options=( "o" "option-with-value+" )
    run process-long-option "--option-with-value=some value"
    assert_success
    assert_output ""
}

@test "success on long option with mandatory value (assignation test)" {
    allowed_options=( "o" "option-with-value+" )
    option_with_value=""
    process-long-option "--option-with-value=some value"
    assert_equal "${option_with_value}" 'some value'
}

@test "success on long option with optional value" {
    allowed_options=( "o" "option-with-value*" )
    run process-long-option "--option-with-value=some value"
    assert_success
    assert_output ""
}

@test "success on long option with optional value (assignation test)" {
    allowed_options=( "o" "option-with-value*" )
    option_with_value=""
    process-long-option "--option-with-value=some value"
    assert_equal "${option_with_value}" 'some value'
}

@test "success on long option without optional value" {
    allowed_options=( "o" "option-with-value*" )
    run process-long-option "--option-with-value"
    assert_success
    assert_output ""
}

@test "success on long option without optional value (assignation test)" {
    allowed_options=( "o" "option-with-value*" )
    option_with_value=""
    process-long-option "--option-with-value"
    assert_equal "${option_with_value}" 1
}

@test "success on long option without value" {
    allowed_options=( "o" "option-with-value" )
    run process-long-option "--option-with-value"
    assert_success
    assert_output ""
}

@test "success on long option without value (assignation test)" {
    allowed_options=( "o" "option-with-value" )
    option_with_value=""
    process-long-option "--option-with-value"
    assert_equal "${option_with_value}" 1
}

@test "success on short option with double dash without value" {
    allowed_options=( "o" "option-with-value" )
    run process-long-option "--o"
    assert_success
    assert_output ""
}

@test "success on short option with double dash without value (assignation test)" {
    allowed_options=( "o" "option-with-value" )
    o=""
    process-long-option "--o"
    assert_equal "${o}" 1
}
