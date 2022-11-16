#!/usr/bin/env bats
# realpath-check.bats
# Test realpath-check.bash:realpath-check function.

# shellcheck source-path=SCRIPTDIR../src

# Setup test environment.
setup() {
    # Load bats libraries.
    load 'test_helper/common-setup'
    load 'test_helper/files-setup'
    _common_setup
    _files_setup

    # Sourcing realpath-check.bash
    source "${PROJECT_ROOT}/src/realpath-check.bash"
}

# Teardown test environment.
teardown() {
    _common_teardown
    _files_teardown
}

# bats file_tags=function:realpath-check,scope:public

@test "get realpath-check from complete path" {
    run realpath-check "${EXISTING_FILE}"
    assert_success
    assert_output "${EXISTING_FILE}"
}

@test "get realpath-check from relative path" {
    run realpath-check "${EXISTING_FILE_RELATIVE_PATH}"
    assert_success
    assert_output "${EXISTING_FILE}"
}

@test "get realpath-check from filename" {
    source "${PROJECT_ROOT}/src/basename.bash"

    cd "$( dirname "${EXISTING_FILE}")"
    run realpath-check "$( basename "${EXISTING_FILE}")"
    assert_success
    assert_output "${EXISTING_FILE}"
}

@test "get realpath-check from filename starting with -" {
    source "${PROJECT_ROOT}/src/basename.bash"

    cd "$( dirname "${EXISTING_DASH_FILE}")"
    run realpath-check -- "$( basename "${EXISTING_DASH_FILE}")"
    assert_success
    assert_output "${EXISTING_DASH_FILE}"
}

@test "fail on empty argument" {
    run realpath-check ""
    assert_failure
    assert_output "Error: File '' does not exists."
}

@test "Error message disabled by --quiet" {
    run realpath-check --quiet ""
    assert_failure
    assert_output ""
}

@test "Error message disabled by -q" {
    run realpath-check -q --q ""
    assert_failure
    assert_output ""
}

@test "Error message disabled by -q and --quiet" {
    run realpath-check -q --quiet ""
    assert_failure
    assert_output ""
}

@test "fail on missing argument" {
    run realpath-check
    assert_failure
}

@test "fail on more than one argument" {
    run realpath-check "/path/to/file" "/path/to/other-file"
    assert_failure
}
