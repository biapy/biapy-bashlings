#!/usr/bin/env ./test/bats/bin/bats
# isUrl.bats
# Test isUrl.bash:isUrl function.

# shellcheck source-path=SCRIPTDIR../src

# Setup test environment.
setup() {
    # Load bats libraries.
    load 'test_helper/common-setup'
    _common_setup

    # Sourcing isUrl.bash
    source "${PROJECT_ROOT}/src/isUrl.bash"
}

# Teardown test environment.
teardown() {
    _common_teardown
}

# bats file_tags=function:isUrl,scope:deprecated,alias:is-url

@test "success for simple HTTPS URL" {
    run isUrl "http://www.google.com/" 2>&1
    assert_success
    assert_output ""
}

@test "success for HTTPS URL with one argument" {
    run isUrl "https://www.google.com/search?q=biapy" 2>&1
    assert_success
    assert_output ""
}

@test "success for HTTPS URL with two arguments" {
    run isUrl "https://www.google.com/search?q=biapy&hl=en" 2>&1
    assert_success
    assert_output ""
}

@test "success for well formatted unexistant URL" {
    run isUrl "https://www.my-random-broken-and-inexistant-site.bogus/" 2>&1
    assert_success
    assert_output ""
}

@test "success for simple HTTP url" {
    run isUrl "http://www.google.com/" 2>&1
    assert_success
    assert_output ""
}

@test "success for simple FTP url" {
    run isUrl "ftp://www.google.com/" 2>&1
    assert_success
    assert_output ""
}

@test "success for simple HTTPS url with login and password" {
    run isUrl "https://username:password@www.google.com/" 2>&1
    assert_success
    assert_output ""
}

@test "success for simple FILE url" {
    run isUrl "file:///home/" 2>&1
    assert_success
    assert_output ""
}

@test "fail on simple SSH url" {
    run isUrl "ssh://www.google.com/" 2>&1
    assert_failure
    assert_output ""
}

@test "fail on simple git url" {
    run isUrl "git://github.com/biapy/biapy-bashlings.git" 2>&1
    assert_failure
    assert_output ""
}

@test "success on HTTP url with escaped spaces" {
    run isUrl "http://www.google.com/some%20spaces%20please"
    assert_success
    assert_output ""
}

@test "fail on HTTP url with spaces" {
    run isUrl "http://www.google.com/some spaces please"
    assert_failure
    assert_output ""
}

@test "fail on vscode url" {
    run isUrl "vscode://"
    assert_failure
    assert_output ""
}

@test "fail without error on domain name without protocol" {
    run isUrl "google.com"
    assert_failure
    assert_output ""
}

@test "fail with error on missing argument" {
    run isUrl 2>&1
    assert_failure
    assert_output "Error: is-url must have one and only one argument."
}

@test "fail with error on more than one argument" {
    run isUrl "http://" "https://" 2>&1
    assert_failure
    assert_output "Error: is-url must have one and only one argument."
}
