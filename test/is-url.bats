#!/usr/bin/env ./test/bats/bin/bats
# is-url.bats
# Test is-url.bash:is-url function.

# Setup test environment.
setup() {
    # Load bats libraries.
    load 'test_helper/common-setup'
    _common_setup

    # Sourcing is-url.bash
    source "${PROJECT_ROOT}/src/is-url.bash"
}

# Teardown test environment.
teardown() {
    _common_teardown
}

# bats file_tags=function:is-url

@test "success for simple HTTPS URL" {
    run is-url "http://www.google.com/"
    assert_success
    assert_output ""
}

@test "success for HTTPS URL with one argument" {
    run is-url "https://www.google.com/search?q=biapy"
    assert_success
    assert_output ""
}

@test "success for HTTPS URL with two arguments" {
    run is-url "https://www.google.com/search?q=biapy&hl=en"
    assert_success
    assert_output ""
}

@test "success for well formatted unexistant URL" {
    run is-url "https://www.my-random-broken-and-inexistant-site.bogus/"
    assert_success
    assert_output ""
}

@test "success for simple HTTP url" {
    run is-url "http://www.google.com/"
    assert_success
    assert_output ""
}

@test "success for simple FTP url" {
    run is-url "ftp://www.google.com/"
    assert_success
    assert_output ""
}

@test "success for simple HTTPS url with login and password" {
    run is-url "https://username:password@www.google.com/"
    assert_success
    assert_output ""
}

@test "success for simple FILE url" {
    run is-url "file:///home/"
    assert_success
    assert_output ""
}

@test "fail on simple SSH url" {
    run is-url "ssh://www.google.com/"
    assert_failure
    assert_output ""
}

@test "fail on simple git url" {
    run is-url "git://github.com/biapy/biapy-bashlings.git"
    assert_failure
    assert_output ""
}

@test "success on HTTP url with escaped spaces" {
    run is-url "http://www.google.com/some%20spaces%20please"
    assert_success
    assert_output ""
}

@test "fail on HTTP url with spaces" {
    run is-url "http://www.google.com/some spaces please"
    assert_failure
    assert_output ""
}

@test "fail on vscode url" {
    run is-url "vscode://"
    assert_failure
    assert_output ""
}

@test "fail without error on domain name without protocol" {
    run is-url "google.com"
    assert_failure
    assert_output ""
}

@test "fail with error on missing argument" {
    run is-url
    assert_failure
    assert_output "Error: is-url must have one and only one argument."
}

@test "fail with error on more than one argument" {
    run is-url "http://" "https://"
    assert_failure
    assert_output "Error: is-url must have one and only one argument."
}
