#!/usr/bin/env bats
# process-options.bats
# Test process-options.bash:process-options function.

# shellcheck source-path=SCRIPTDIR../src
# shellcheck source-path=SCRIPTDIR../src/internals

# Setup test environment.
setup() {
  # Load bats libraries.
  load 'test_helper/common-setup'
  _common_setup

  # Sourcing process-options.bash
  source "${PROJECT_ROOT}/src/process-options.bash"
}

# Teardown test environment.
teardown() {
  _common_teardown
}

# bats file_tags=function:process-options,scope:public

@test "fail on missing argument" {
  run process-options
  assert_failure
  assert_output "Error: process-options requires at least one argument."
}

@test "process short option without value and two arguments" {
  run process-options "o option other-option" -o "argument1" "argument2"
  assert_success
  assert_output ""
}

@test "process short option without value and two arguments (assignation test)" {
  local arguments=()
  local o=0
  process-options "o option other-option" -o "argument1" "argument2"
  assert_equal "${o}" '1'
  assert_equal "${arguments[*]}" "argument1 argument2"
}

@test "process long option without value and two arguments" {
  run process-options "option other-option" --option "argument1" "argument2"
  assert_success
  assert_output ""
}

@test "process long option without value and two arguments (assignation test)" {
  local arguments=()
  local option=0
  process-options "option other-option" --option "argument1" "argument2"
  assert_equal "${option}" '1'
  assert_equal "${arguments[*]}" "argument1 argument2"
}

@test "process long option with value and two arguments" {
  run process-options "option* other-option" --option="value with spaces" \
    "argument1" "argument2"
  assert_success
  assert_output ""
}

@test "process long option with value and two arguments (assignation test)" {
  local arguments=()
  local option=0
  process-options "option* other-option" --option="value with spaces" \
    "argument1" "argument2"
  assert_equal "${option}" 'value with spaces'
  assert_equal "${arguments[*]}" "argument1 argument2"
}

@test "process mandatory option with arguments" {
  run process-options "option+ test set" --option="value with spaces" \
    "argument1" "argument2"
  assert_success
  assert_output ""
}

@test "process mandatory value option with arguments" {
  run process-options "option& test set" --option="value with spaces" \
    "argument1" "argument2"
  assert_success
  assert_output ""
}

@test "process mandatory value option with arguments (assignation test)" {
  local arguments=()
  local option=0
  process-options "option+ test set" --option="value with spaces" \
    "argument1" "argument2"
  assert_equal "${option}" 'value with spaces'
  assert_equal "${arguments[*]}" "argument1 argument2"
}

@test "fail on missing mandatory option" {
  run process-options "option+ test set" --test \
    "argument1" "argument2"
  assert_failure
  assert_output "Error: --option is missing."
}

@test "fail on mandatory value option without value" {
  run process-options "option& test set" --option \
    "argument1" "argument2"
  assert_failure
  assert_output "Error: --option requires an argument."
}

@test "fail on mandatory option without value" {
  run process-options "option+ test set" --option \
    "argument1" "argument2"
  assert_failure
  assert_output "Error: --option requires an argument."
}

@test "fail on unallowed short option." {
  run process-options "o option" -oi --option
  assert_failure
  assert_output "Error: option '-i' is not recognized."
}

@test "fail on unallowed long option." {
  run process-options "o i option" -oi --oi9 --option
  assert_failure
  assert_output "Error: option '--oi9' is not recognized."
}

@test "Allow for no arguments beside allowed option list." {
  run process-options ""
  assert_success
  assert_output ""
}
