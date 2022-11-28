#!/usr/bin/env bats
# realpath.bats
# Test realpath.bash:realpath function.

# shellcheck source-path=SCRIPTDIR../src

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
    cd "${EXISTING_FILE%/*}"
    run realpath "${EXISTING_FILE##*/}"
    assert_success
    assert_output "${EXISTING_FILE}"
}

@test "get realpath from filename starting with -" {
    cd "${EXISTING_DASH_FILE%/*}"
    run realpath "${EXISTING_DASH_FILE##*/}"
    assert_success
    assert_output "${EXISTING_DASH_FILE}"
}

@test "success on missing file" {
    cd "${MISSING_FILE%/*}"
    run realpath "${MISSING_FILE##*/}"
    assert_success
    assert_output "${MISSING_FILE}"
}

@test "failure on random relative path" {
    run realpath "random/path/to/file"
    assert_failure
    assert_output ""
}

@test "success on symbolic link to missing file" {
    cd "${LN_TO_MISSING_FILE%/*}"
    run realpath "${LN_TO_MISSING_FILE##*/}"
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

@test "get realpath from complete path using pure bash" {
    run realpath --pure-bash "${EXISTING_FILE}"
    assert_success
    assert_output "${EXISTING_FILE}"
}

@test "get realpath from relative path using pure bash" {
    run realpath --pure-bash "${EXISTING_FILE_RELATIVE_PATH}"
    assert_success
    assert_output "${EXISTING_FILE}"
}

@test "get realpath from filename using pure bash" {
    cd "${EXISTING_FILE%/*}"
    run realpath --pure-bash "${EXISTING_FILE##*/}"
    assert_success
    assert_output "${EXISTING_FILE}"
}

@test "get realpath from filename starting with - using pure bash" {
    cd "${EXISTING_DASH_FILE%/*}"
    run realpath --pure-bash "${EXISTING_DASH_FILE##*/}"
    assert_success
    assert_output "${EXISTING_DASH_FILE}"
}

@test "success on missing file using pure bash" {
    cd "${MISSING_FILE%/*}"
    run realpath --pure-bash "${MISSING_FILE##*/}"
    assert_success
    assert_output "${MISSING_FILE}"
}

@test "failure on random relative path using pure bash" {
    run realpath --pure-bash "random/path/to/file"
    assert_failure
    assert_output ""
}

@test "success on symbolic link to missing file using pure bash" {
    cd "${LN_TO_MISSING_FILE%/*}"
    run realpath --pure-bash "${LN_TO_MISSING_FILE##*/}"
    assert_success
    assert_output "${MISSING_FILE}"
}

@test "fail on empty argument using pure bash" {
    run realpath --pure-bash ""
    assert_failure
    assert_output ""
}

@test "fail on non existing root path using pure bash" {
    run realpath --pure-bash "${MISSING_ABSOLUTE_PATH}"
    assert_failure
    assert_output ""
}

@test "fail on missing argument using pure bash" {
    run realpath --pure-bash
    assert_failure
    assert_output "Error: realpath must have one and only one argument."
}

@test "fail on more than one argument using pure bash" {
    run realpath --pure-bash "/path/to/file" "/path/to/other-file"
    assert_failure
    assert_output "Error: realpath must have one and only one argument."
}
