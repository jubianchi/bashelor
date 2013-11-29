function log() {
	echo -e "$*"
}

function error() {
	local ERROR_CODE="$1"
	shift

	log "\033[31mERR$ERROR_CODE $*\033[0m"

	local CALLER=$(caller 2)
	local FILE=$(echo $CALLER | cut -d' ' -f3)
	local LINE=$(echo $CALLER | cut -d' ' -f1)

	log "\033[31m ├── $FILE (line $LINE)\033[0m"

	CALLER=$(caller 1)
	FILE=$(echo $CALLER | cut -d' ' -f3)
	LINE=$(echo $CALLER | cut -d' ' -f1)

	log "\033[31m └── $FILE (line $LINE)\033[0m"

	exit $ERROR_CODE
}

function success() {
	log "\033[32m$*\033[0m"
}

function warning() {
	log "\033[33m$*\033[0m"
}
