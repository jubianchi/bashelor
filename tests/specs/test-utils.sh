#!/bin/bash

describe "bashelor utils"

. ../bootstrap.sh
. ../../src/utils.sh

it_checks_if_variable_is_set() {
	expectfail capture isset FOOBAR

    FOOBAR=hello isset FOOBAR
}
