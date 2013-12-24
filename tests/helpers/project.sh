#!/bin/bash

function project() {
    if [ "$1" = "-f" ]
    then
        shift
    else
        [ ! -d "$1" ]
    fi

    mkdir -p "$1" && cd "$1"

    if [ "$2" = "--deps" ]
    then
        touch deps
    fi
}

function require() {
    [ -d "$1" ]

    echo "bashelor.require $2 $3 $4"  > "$1/deps"
}