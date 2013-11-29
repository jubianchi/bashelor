#!/bin/bash

function repository() {
    [ ! -d "$1" ]

    mkdir -p "$1" && cd "$1"

    git init
    commit "$1"
}

function commit() {
    [ -d "$1" ]

    git --git-dir="$1/.git" commit -m "A commit" --allow-empty
}

function revision() {
    [ -d "$1" ]

    git --git-dir="$1/.git" rev-parse --short HEAD
}
