#!/bin/bash

echo "Echo BASH_SOURCE from 2.sh"
echo $BASH_SOURCE

echo "Declare foo from 2.sh"
function foo() {
	echo ${BASH_SOURCE[1]}
}

echo "Source 3.sh from 2.sh"
. 3.sh
