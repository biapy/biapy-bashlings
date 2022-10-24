#!/usr/bin/env ./test/bats/bin/bats
# realpath.bats
# Test realpath.bash:realpath function.

# Setup test environment.
setup() {
    # Load bats libraries.
    load 'test_helper/common-setup'
    load 'test_helper/files-setup'
    _common_setup
    _files_setup

    # Sourcing realpath.bash
    source "${PROJECT_ROOT}/src/realpath.bash"
}

# Teardown test environment.
teardown() {
    _common_teardown
    _files_teardown
}

# bats file_tags=function:realpath

@test "get realpath from complete path" {
    run realpath "${EXISTING_FILE}"
    assert_success
    assert_output "${EXISTING_FILE}"
}

@test "get realpath from relative path" {
    run realpath "${EXISTING_FILE_RELATIVE_PATH}"
    assert_success
    assert_output "${EXISTING_FILE}"
}

@test "get realpath from filename" {
    source "${PROJECT_ROOT}/src/basename.bash"

    cd "$( dirname "${EXISTING_FILE}" )"
    run realpath "$( basename "${EXISTING_FILE}" )"
    assert_success
    assert_output "${EXISTING_FILE}"
}

@test "get realpath from filename starting with -" {
    source "${PROJECT_ROOT}/src/basename.bash"

    cd "$( dirname "${EXISTING_DASH_FILE}" )"
    run realpath "$( basename "${EXISTING_DASH_FILE}" )"
    assert_success
    assert_output "${EXISTING_DASH_FILE}"
}

@test "pass on empty argument" {
    run realpath ""
    assert_success
    assert_output ""
}

@test "fail on missing argument" {
    run realpath
    assert_failure
}

@test "fail on more than one argument" {
    run realpath "/path/to/file" "/path/to/other-file"
    assert_failure
}