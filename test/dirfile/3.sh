#!/bin/bash

echo "Echo BASH_SOURCE from 3.sh"
echo $BASH_SOURCE

echo "Declare bar from 3.sh"
function bar() {
	echo ${BASH_SOURCE[1]}
}