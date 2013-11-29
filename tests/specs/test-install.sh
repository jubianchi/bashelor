#!/bin/bash

describe "bashelor install"

. ../bootstrap.sh
. ../../src/logger.sh

before() {
    TEST_PWD=$(pwd)
    TEST_SANDBOX="/tmp/$roundup_test_name"

    after && mkdir -p "$TEST_SANDBOX"
}

after() {
    [ -d "$TEST_SANDBOX" ] && rm -rf "$TEST_SANDBOX" || true
}

it_throws_error_if_no_deps_file() {
    expectfail capture ../../bin/bashelor install

    local OUTPUT=$(getstdout | head -n1)

    [ "$OUTPUT" = "$(error "Nos deps file found in $TEST_PWD" | head -n1)" ]
}

it_does_nothing_on_empty_deps_file() {
    cd ${TEST_SANDBOX}
    touch deps

    capture ${TEST_PWD}/../../bin/bashelor install

    [ -z "$(getstdout)" ]
}

it_installs_deps_in_vendor_directory() {
    cd ${TEST_SANDBOX}
    echo "require github dfs-sh/roundup" > deps

    capture ${TEST_PWD}/../../bin/bashelor install

    local OUTPUT=$(getstdout)
    local LINE1=$(echo "$OUTPUT" | head -n1)
    local LINE2=$(echo "$OUTPUT" | head -n2 | tail -n1)

    [ "$LINE1" = "=> Cloning $(success http://github.com/dfs-sh/roundup) into $(success dfs-sh/roundup)" ]
    echo "$LINE2" | grep -e "Installed dfs-sh/roundup@[a-f0-9]*"
    [ -d "vendor/dfs-sh/roundup" ]
}

it_installs_deps_in_custom_vendor_subdirectory() {
    cd ${TEST_SANDBOX}
    echo "require github dfs-sh/roundup custom/directory/roundup" > deps

    capture ${TEST_PWD}/../../bin/bashelor install

    local OUTPUT=$(getstdout)
    local LINE1=$(echo "$OUTPUT" | head -n1)
    local LINE2=$(echo "$OUTPUT" | head -n2 | tail -n1)

    [ "$LINE1" = "=> Cloning $(success http://github.com/dfs-sh/roundup) into $(success custom/directory/roundup)" ]
    echo "$LINE2" | grep -e "Installed custom/directory/roundup@[a-f0-9]*"
    [ -d "vendor/custom/directory/roundup" ]
}

it_updates_deps() {
    cd ${TEST_SANDBOX}
    echo "require github dfs-sh/roundup" > deps

    ${TEST_PWD}/../../bin/bashelor install
    capture ${TEST_PWD}/../../bin/bashelor install

    local OUTPUT=$(getstdout)
    local LINE1=$(echo "$OUTPUT" | head -n1)
    local LINE2=$(echo "$OUTPUT" | head -n2 | tail -n1)

    [ "$LINE1" = "=> Updating $(success dfs-sh/roundup)" ]
    echo "$LINE2" | grep -e "Nothing to update ([a-f0-9]*)"
    [ -d "vendor/dfs-sh/roundup" ]
}