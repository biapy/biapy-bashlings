#!/usr/bin/env bats
# repeat-string.bats
# Test repeat-string.bash:repeat-string function.

# shellcheck source-path=SCRIPTDIR../src

# Setup test environment.
setup() {
  # Load bats libraries.
  load 'test_helper/common-setup'
  _common_setup

  # Sourcing repeat-string.bash
  source "${PROJECT_ROOT}/src/repeat-string.bash"
}

# Teardown test environment.
teardown() {
  _common_teardown
}

# bats file_tags=function:repeat-string,scope:public

@test "fail with error on missing argument" {
  run repeat-string 'first'
  assert_failure
  assert_output "Error: repeat-string requires two and only two arguments."
}

@test "fail with error on more than two arguments" {
  run repeat-string 'first' 'second' 'third'
  assert_failure
  assert_output "Error: repeat-string requires two and only two arguments."
}

@test "fail with error if first argument is empty" {
  run repeat-string '' 'repeat'
  assert_failure
  assert_output "Error: repeat-string's first argument is not an integer."
}

@test "fail with error if first argument is not an integer" {
  run repeat-string 'string' 'repeat'
  assert_failure
  assert_output "Error: repeat-string's first argument is not an integer."
}

@test "success in repeating a string" {
  run repeat-string '3' 'repeat'
  assert_success
  assert_output "repeatrepeatrepeat"
}

@test "success in repeating a string 0 times" {
  run repeat-string '0' 'repeat'
  assert_success
  assert_output ""
}

@test "success in repeating a string with line break" {
  run repeat-string '3' "$(printf '%b' "line\nnext ")"
  assert_success
  assert_line --index 0 "line"
  assert_line --index 1 "next line"
  assert_line --index 2 "next line"
  assert_line --index 3 "next "
}
