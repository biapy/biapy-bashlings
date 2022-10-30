#!/usr/bin/env ./test/bats/bin/bats
# in-list.bats
# Test in-list.bash:in-list function.

# Setup test environment.
setup() {
    # Load bats libraries.
    load 'test_helper/common-setup'
    _common_setup

    # Sourcing in-list.bash
    source "${PROJECT_ROOT}/src/in-list.bash"
}

# Teardown test environment.
teardown() {
    _common_teardown
}

# bats file_tags=function:in-list

@test "find text in other arguments" {
    run in-list "text" "some" "list" "with" "text" "inside" 2>&1
    assert_success
    assert_output ""
}

@test "find number in other arguments" {
    run in-list 15 2 5 6 9 10 11 13 15 18 19 2>&1
    assert_success
    assert_output ""
}


@test "Do not find number in other arguments" {
    run in-list 15 20 51 63 94 140 121 113 151 138 19 2>&1
    assert_failure
    assert_output ""
}


@test "find only exact match in arguments" {
    run in-list "text" "some" "list" "texts" "inside" 2>&1
    assert_failure
    assert_output ""
}

@test "Do not file partial match in arguments" {
    run in-list "text" "some" "list" "ext" "inside" 2>&1
    assert_failure
    assert_output ""
}

@test "does not match word in a argument" {
    run in-list "text" "some" "list" "with text inside" 2>&1
    assert_failure
    assert_output ""
}

@test "fail without error message for empty list" {
    run in-list "text" 2>&1
    assert_failure
    assert_output ""
}

@test "find match in list" {
    list=("this is" "some argument" "list")
    run in-list "some argument" "${list[@]}"
    assert_success
    assert_output ""
}

@test "fail on missing argument" {
    run in-list 2>&1
    assert_failure
    assert_output "Error: in-list must have at least one argument."
}
