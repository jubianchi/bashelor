#!/bin/bash

function project() {
    [ ! -d "$1" ]

    mkdir -p "$1" && cd "$1"

    if [ "$2" = "--deps" ]
    then
        touch deps
    fi
}

function require() {
    [ -d "$1" ]

    echo "require $2 $3 $4"  > "$1/deps"
}

function file() {
	[ -d "$1" ]

	if [ -n "$3" ]
	then
		echo "$3" > "$1/$2"
	else
		touch "$1/$2"
	fi
}