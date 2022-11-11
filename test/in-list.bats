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

# bats file_tags=function:in-list,scope:public

@test "find text in other arguments" {
    run in-list "text" "some" "list" "with" "text" "inside"
    assert_success
    assert_output ""
}

@test "find number in other arguments" {
    run in-list 15 2 5 6 9 10 11 13 15 18 19
    assert_success
    assert_output ""
}

@test "find match in list" {
    list=("this is" "some argument" "list")
    run in-list "some argument" "${list[@]}"
    assert_success
    assert_output ""
}

@test "Allow for regexp based search (.*)" {
    list=("a" "word" "in" "this" "test" "list")
    run in-list "t.*t" "${list[@]}"
    assert_success
    assert_output ""
}

@test "Allow for regexp based search ([a-z]+)" {
    list=("a" "wooooord" "in" "this" "test" "list")
    run in-list "w[a-z]+rd" "${list[@]}"
    assert_success
    assert_output ""
}

@test "Allow for regexp based search (group)" {
    list=("a" "word" "in" "this" "test" "list")
    run in-list "te(x|s)t" "${list[@]}"
    assert_success
    assert_output ""
}

@test "Do not find number in other arguments" {
    run in-list 15 20 51 63 94 140 121 113 151 138 19
    assert_failure
    assert_output ""
}

@test "find only exact match in arguments" {
    run in-list "text" "some" "list" "texts" "inside"
    assert_failure
    assert_output ""
}

@test "Do not file partial match in arguments" {
    run in-list "text" "some" "list" "ext" "inside"
    assert_failure
    assert_output ""
}

@test "does not match word in a argument" {
    run in-list "text" "some" "list" "with text inside"
    assert_failure
    assert_output ""
}

@test "fail without error message for empty list" {
    run in-list "text"
    assert_failure
    assert_output ""
}

@test "fail on missing argument" {
    run in-list
    assert_failure
    assert_output "Error: in-list must have at least one argument."
}
