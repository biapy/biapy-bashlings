#!/usr/bin/env ./test/bats/bin/bats
# test/download.bats
# Test src/download.bash:download function.

# Setup test environment.
setup() {
    # Load bats libraries.
    load "test_helper/bats-file/load"
    load 'test_helper/common-setup'
    load 'test_helper/files-setup'

    _common_setup
    _files_setup

    # Sourcing download.bash
    source "${PROJECT_ROOT}/src/download.bash"

    # Create a random User Agent
    # RANDOM_USER_AGENT="$( command tr --complement --delete \
    #         '[:alnum:]#%(),-' \
    #         2>'/dev/null' < '/dev/urandom' \
    #     | command head --bytes=64
    # )"
    RANDOM_USER_AGENT="cshqS1u%0q(MwSF2HAJtqwpdHqAFkcxhANNqcULOT4X(-O7YOE))t)arVVBV#8y"
}

# Teardown test environment.
teardown() {
    _common_teardown
}

# bats file_tags=function:download,scope:public

@test "fail for missing URL" {
    run download "https://github.com/404"
    assert_failure
    assert_output "Error: --url is missing."
}

@test "fail for 404 URL" {
    run download --url="https://github.com/404"
    assert_failure
    assert_output "Error: download failed."
}

@test "fail silently for missing URL (-q)" {
    run download -q "https://github.com/404"
    assert_failure
    assert_output ""
}

@test "fail silently for missing URL (--quiet)" {
    run download --quiet "https://github.com/404"
    assert_failure
    assert_output ""
}

@test "fail silentlty for 404 URL (-q)" {
    run download -q --url="https://github.com/404"
    assert_failure
    assert_output ""
}

@test "fail silentlty for 404 URL (--quiet)" {
    run download --quiet --url="https://github.com/404"
    assert_failure
    assert_output ""
}

@test "success for simple HTTPS URL" {
    bats_require_minimum_version '1.5.0'
    # Check specific commit content for small file.
    run --keep-empty-lines download \
        --url="https://raw.githubusercontent.com/github/gitignore/5342e13bc99d1e106b4d5f7bc9e9deaa0c58543e/Ada.gitignore"
    assert_success
    [ "${lines[0]}" = "# Object file" ]
    [ "${lines[1]}" = "*.o" ]
    [ "${lines[2]}" = "" ]
    [ "${lines[3]}" = "# Ada Library Information" ]
    [ "${lines[4]}" = "*.ali" ] 
}

@test "success for simple HTTPS URL with output to file" {
    # Check specific commit content for small file.
    run download \
        --output-path="${MISSING_FILE}" \
        --url="https://raw.githubusercontent.com/github/gitignore/5342e13bc99d1e106b4d5f7bc9e9deaa0c58543e/Ada.gitignore"
    assert_success
    assert_output ''
    assert_file_exists "${MISSING_FILE}"
    assert_file_not_empty "${MISSING_FILE}"
    mapfile -t "file_contents" < "${MISSING_FILE}"
    [ "${file_contents[0]}" = "# Object file" ]
    [ "${file_contents[1]}" = "*.o" ]
    [ "${file_contents[2]}" = "" ]
    [ "${file_contents[3]}" = "# Ada Library Information" ]
    [ "${file_contents[4]}" = "*.ali" ] 
}

@test "success for simple HTTPS URL with deprecated output to file" {
    # Check specific commit content for small file.
    run download \
        --outputPath="${MISSING_FILE}" \
        --url="https://raw.githubusercontent.com/github/gitignore/5342e13bc99d1e106b4d5f7bc9e9deaa0c58543e/Ada.gitignore"
    assert_success
    assert_output ''
    assert_file_exists "${MISSING_FILE}"
    assert_file_not_empty "${MISSING_FILE}"
    mapfile -t "file_contents" < "${MISSING_FILE}"
    [ "${file_contents[0]}" = "# Object file" ]
    [ "${file_contents[1]}" = "*.o" ]
    [ "${file_contents[2]}" = "" ]
    [ "${file_contents[3]}" = "# Ada Library Information" ]
    [ "${file_contents[4]}" = "*.ali" ] 
}

@test "fail for 404 URL and remove file" {
    run download \
        --output-path="${EXISTING_FILE}" \
        --url="https://github.com/404"
    assert_failure
    assert_output 'Error: download failed.'
    assert_file_not_exists "${EXISTING_FILE}"
}

@test "success for user agent change" {
    # Use a user-agent checking web service.
    run download --user-agent="${RANDOM_USER_AGENT}" \
        --url="https://www.whatsmyua.info/"
    assert_success
    assert_output --partial "${RANDOM_USER_AGENT}"
}

@test "success for deprecated user agent change" {
    # Use a user-agent checking web service.
    run download --userAgent="${RANDOM_USER_AGENT}" \
        --url="https://www.whatsmyua.info/"
    assert_success
    assert_output --partial "${RANDOM_USER_AGENT}"
}
