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

    cd "$( dirname "${EXISTING_FILE}")"
    run realpath "$( basename "${EXISTING_FILE}")"
    assert_success
    assert_output "${EXISTING_FILE}"
}

@test "get realpath from filename starting with -" {
    source "${PROJECT_ROOT}/src/basename.bash"

    cd "$( dirname "${EXISTING_DASH_FILE}")"
    run realpath "$( basename "${EXISTING_DASH_FILE}")"
    assert_success
    assert_output "${EXISTING_DASH_FILE}"
}

@test "success on missing file" {
    source "${PROJECT_ROOT}/src/basename.bash"

    cd "$( dirname "${MISSING_FILE}")"
    run realpath "$( basename "${MISSING_FILE}")"
    assert_success
    assert_output "${MISSING_FILE}"
}

@test "failure on random relative path" {
    run realpath "random/path/to/file"
    assert_failure
    assert_output ""
}

@test "success on symbolic link to missing file" {
    source "${PROJECT_ROOT}/src/basename.bash"

    cd "$( dirname "${LN_TO_MISSING_FILE}")"
    run realpath "$( basename "${LN_TO_MISSING_FILE}")"
    assert_success
    assert_output "${MISSING_FILE}"
}

@test "fail on empty argument" {
    run realpath ""
    assert_failure
    assert_output ""
}

@test "fail on missing argument" {
    run realpath
    assert_failure
    assert_output "Error: realpath must have one and only one argument."
}

@test "fail on more than one argument" {
    run realpath "/path/to/file" "/path/to/other-file"
    assert_failure
    assert_output "Error: realpath must have one and only one argument."
}
