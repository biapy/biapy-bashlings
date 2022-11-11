#!/usr/bin/env ./test/bats/bin/bats
# realpath_check.bats
# Test realpath_check.bash:realpath_check legacy alias function.

# Setup test environment.
setup() {
    # Load bats libraries.
    load 'test_helper/common-setup'
    load 'test_helper/files-setup'
    _common_setup
    _files_setup

    # Sourcing realpath_check.bash
    source "${PROJECT_ROOT}/src/realpath_check.bash"
}

# Teardown test environment.
teardown() {
    _common_teardown
    _files_teardown
}

# bats file_tags=function:realpath_check,scope:deprecated,alias:realpath-check

@test "get realpath_check from complete path" {
    run realpath_check "${EXISTING_FILE}"
    assert_success
    assert_output "${EXISTING_FILE}"
}

@test "get realpath_check from relative path" {
    run realpath_check "${EXISTING_FILE_RELATIVE_PATH}"
    assert_success
    assert_output "${EXISTING_FILE}"
}

@test "get realpath_check from filename" {
    source "${PROJECT_ROOT}/src/basename.bash"

    cd "$( dirname "${EXISTING_FILE}")"
    run realpath_check "$( basename "${EXISTING_FILE}")"
    assert_success
    assert_output "${EXISTING_FILE}"
}

@test "get realpath_check from filename starting with -" {
    source "${PROJECT_ROOT}/src/basename.bash"

    cd "$( dirname "${EXISTING_DASH_FILE}")"
    run realpath_check -- "$( basename "${EXISTING_DASH_FILE}")"
    assert_success
    assert_output "${EXISTING_DASH_FILE}"
}

@test "fail on empty argument" {
    run realpath_check ""
    assert_failure
    assert_output "Error: File '' does not exists."
}

@test "fail on missing argument" {
    run realpath
    assert_failure
}

@test "fail on more than one argument" {
    run realpath_check "/path/to/file" "/path/to/other-file"
    assert_failure
}
