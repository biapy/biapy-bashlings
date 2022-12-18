#!/usr/bin/env bats
# available-fd.bats
# Test available-fd.bash:available-fd function.

# shellcheck source-path=SCRIPTDIR../src

# Setup test environment.
setup() {
  # Load bats libraries.
  load 'test_helper/common-setup'
  _common_setup

  # Sourcing available-fd.bash
  source "${PROJECT_ROOT}/src/available-fd.bash"
}

# Teardown test environment.
teardown() {
  _common_teardown
}

# bats file_tags=function:available-fd,scope:public

@test "fail with error on argument present" {
  run available-fd '2' 'forbidden'
  assert_failure
  assert_output "Error: available-fd accepts only one argument."
}

@test "fail with error if first argument is not an integer" {
  run available-fd 'string'
  assert_failure
  assert_output "Error: available-fd's first argument is not an integer."
}

@test "detect an available file descriptor" {
  run available-fd
  assert_success
  assert_output --regexp '^[0-9]+$'
}

@test "detect next available file descriptor when an file descriptor is used" {
  # Open an available fd.
  # shellcheck disable=SC2119 # $(available-fd) does not need arguments
  available_fd="$(available-fd)"
  eval "exec ${available_fd}>/dev/null"

  run available-fd
  assert_success
  refute_output "${available_fd}"
  assert_output --regexp '^[0-9]+$'

  # Close opened fd.
  eval "exec ${available_fd}>&-"
}

@test "return default fd when no fd is available." {
  # Exaust all available fds.
  declare -a opened_fds
  opened_fds=()
  # shellcheck disable=SC2119 # $(available-fd) does not need arguments
  while available_fd="$(available-fd)"; do
    eval "exec ${available_fd}>/dev/null"
    opened_fds+=("${available_fd}")
  done

  run available-fd '2'
  assert_failure
  assert_output '2'

  # Close opened fds.
  for opened_fd in ${opened_fds[@]+"${opened_fds[@]}"}; do
    eval "exec ${opened_fd}>&-"
  done
}
