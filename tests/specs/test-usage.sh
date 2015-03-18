#!/bin/bash

describe "bashelor usage"

. ../bootstrap.sh
. ../../src/logger.sh

it_displays_usage() {
	capture ../../bin/bashelor -h

	local OUTPUT=$(getstdout)

	local LINE1=$(echo "$OUTPUT" | head -n1)
	local LINE3=$(echo "$OUTPUT" | head -n3 | tail -n1)
	local LINE5=$(echo "$OUTPUT" | head -n5 | tail -n1)
	local LINE6=$(echo "$OUTPUT" | head -n6 | tail -n1)

	[ "$LINE1" = "Usage: $(success ../../bin/bashelor) $(warning [-h] [-q]) $(success [install] [inline])" ]
	[ "$LINE3" = "  $(success install): Install dependencies" ]
	[ "$LINE5" = "  $(warning -q): Quiet mode (no output)" ]
	[ "$LINE6" = "  $(warning -h): Display this help message" ]
}
