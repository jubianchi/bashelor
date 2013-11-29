#!/bin/bash

if [ ! $(which truncate > /dev/null 2>&1) ]
then
    function truncate() {
        while getopts : OPT "$@"; do true; done
        shift $OPTIND

        for FILE in $*; do > $FILE; done
    }
fi

function getstdout() { cat $(stdout); }
function getstderr() { cat $(stderr); }
function getstatus() { cat $(rc); }