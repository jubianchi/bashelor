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
