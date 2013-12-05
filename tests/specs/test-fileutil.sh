#!/bin/bash

describe "bashelor fileutil"

. ../bootstrap.sh
. ../../src/fileutil.sh

before() {
	TEST_PWD=$(pwd)
	TEST_SANDBOX="/tmp/$roundup_test_name"

	after && mkdir -p "$TEST_SANDBOX"
}

after() {
	[ -d "$TEST_SANDBOX" ] && rm -rf "$TEST_SANDBOX" || true
}


it_displays_current_file_path() {
	local FILEPATH=$(__FILE__)

	[ "$FILEPATH" = "$TEST_PWD/$(basename ${BASH_SOURCE[0]})" ]
}

it_displays_current_file_directory() {
	local FILEPATH=$(__DIR__)

	[ "$FILEPATH" = "$TEST_PWD" ]
}

it_displays_real_paths() {
	local REAL_FILE="$TEST_SANDBOX/real_file"
	local SYMLINK_FILE="$TEST_SANDBOX/symlink_file"
	local REAL_DIRECTORY="$TEST_SANDBOX/real_directory"
	local SYMLINK_DIRECTORY="$TEST_SANDBOX/symlink_directory"

	touch ${REAL_FILE}
	ln -s ${REAL_FILE} ${SYMLINK_FILE}

	mkdir -p  ${REAL_DIRECTORY}
	ln -s ${REAL_DIRECTORY} ${SYMLINK_DIRECTORY}

	cd ${TEST_SANDBOX}

	[ $(realpath "real_file") = "$TEST_SANDBOX/real_file" ]
	[ $(realpath "real_directory") = "$TEST_SANDBOX/real_directory" ]
	[ $(realpath "symlink_file") = "$TEST_SANDBOX/symlink_file" ]
	[ $(realpath "symlink_directory") = "$TEST_SANDBOX/symlink_directory" ]
}

it_displays_sourcing_file_path() {
	local SOURCING_FILE="$TEST_SANDBOX/sourcing"
	local SOURCED_FILE="$TEST_SANDBOX/sourced"

	echo " . $(realpath ../../src/fileutil.sh)"	 > ${SOURCED_FILE}
	echo "__SOURCE__" >> ${SOURCED_FILE}

	echo ". $SOURCED_FILE" > ${SOURCING_FILE}

	[ "$(. ${SOURCING_FILE})" = "$SOURCING_FILE" ]
}