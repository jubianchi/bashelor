#!/bin/bash

describe "bashelor git driver"

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

it_throws_error_if_git_not_available() {
	cd ${TEST_SANDBOX}
	echo "require git git@host:repository.git test/repository" > deps

	export BASHELOR_GIT_CMD="git_not_available"
	expectfail capture ${TEST_PWD}/../../bin/bashelor install

	local OUTPUT=$(getstdout)
	local LINE1=$(echo "$OUTPUT" | head -n1)
	local LINE2=$(echo "$OUTPUT" | head -n2 | tail -n1)

	[ $(getstatus) -eq 45 ]
	[ "$LINE1" = "$(error "git command (git_not_available) is not available" | head -n1)" ]
	[[ "$LINE2" = "$(error " └── deps (line 1)" | head -n1)" || "$LINE2" = "$(error " └── ./deps (line 1)" | head -n1)" ]]
}

it_clones_git_repository() {
	repository "$TEST_SANDBOX/repository"
	commit "$TEST_SANDBOX/repository"
	local REV=$(revision "$TEST_SANDBOX/repository")

	project "$TEST_SANDBOX/project"
	require "$TEST_SANDBOX/project" "git" "$TEST_SANDBOX/repository" "test/repository"

	capture ${TEST_PWD}/../../bin/bashelor install

	local OUTPUT=$(getstdout)
	local LINE1=$(echo "$OUTPUT" | head -n1)
	local LINE2=$(echo "$OUTPUT" | head -n2 | tail -n1)

	[ "$LINE1" = "=> Cloning $(success ${TEST_SANDBOX}/repository) into $(success test/repository)" ]
	[ "$LINE2" = "$(warning "   Installed test/repository@$REV")" ]
	[ -d "$TEST_SANDBOX/project/vendor/test/repository" ]
	[ $(revision "$TEST_SANDBOX/project/vendor/test/repository") = "$REV" ]
}

it_pulls_git_repository() {
	repository "$TEST_SANDBOX/repository"
	commit "$TEST_SANDBOX/repository"
	local FIRST_REV=$(revision "$TEST_SANDBOX/repository")

	project "$TEST_SANDBOX/project"
	require "$TEST_SANDBOX/project" "git" "$TEST_SANDBOX/repository" "test/repository"

	${TEST_PWD}/../../bin/bashelor install

	commit "$TEST_SANDBOX/repository"
	local REV=$(revision "$TEST_SANDBOX/repository")

	capture ${TEST_PWD}/../../bin/bashelor install

	local OUTPUT=$(getstdout)
	local LINE1=$(echo "$OUTPUT" | head -n1)
	local LINE2=$(echo "$OUTPUT" | head -n2 | tail -n1)

	[ "$LINE1" = "=> Updating $(success test/repository)" ]
	[ "$LINE2" = "$(warning "   Updated $FIRST_REV..$REV")" ]
	[ -d "$TEST_SANDBOX/project/vendor/test/repository" ]
	[ $(revision "$TEST_SANDBOX/project/vendor/test/repository") = "$REV" ]
}