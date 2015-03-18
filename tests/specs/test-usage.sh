#!/bin/bash

describe "bashelor usage"

. ../bootstrap.sh
. ../../src/logger.sh

it_displays_usage() {
	capture ../../bin/bashelor -h

	local OUTPUT=$(getstdout)

	local LINE1=$(echo "$OUTPUT" | head -n1)
	local LINE3=$(echo "$OUTPUT" | head -n3 | tail -n1)
	local LINE4=$(echo "$OUTPUT" | head -n4 | tail -n1)
	local LINE6=$(echo "$OUTPUT" | head -n6 | tail -n1)
	local LINE7=$(echo "$OUTPUT" | head -n7 | tail -n1)

	[ "$LINE1" = "Usage: $(success ../../bin/bashelor) $(warning [-h] [-q]) $(success [install|upgrade])" ]
	[ "$LINE3" = "  $(success install): Install dependencies" ]
	[ "$LINE4" = "  $(success upgrade): Upgrade bashelor" ]
	[ "$LINE6" = "  $(warning -q): Quiet mode (no output)" ]
	[ "$LINE7" = "  $(warning -h): Display this help message" ]
}
