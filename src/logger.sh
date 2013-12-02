function log() {
	echo -e "$*"
}

function error() {
	log "\033[31m$*\033[0m" 1>&2

	local CALLER=$(caller 2)
	local FILE=$(echo ${CALLER} | cut -d' ' -f3)
	local LINE=$(echo ${CALLER} | cut -d' ' -f1)

	[ -n "$CALLER" ] && log "\033[31m └── $FILE (line $LINE)\033[0m"  1>&2
}

function success() {
	log "\033[32m$*\033[0m"
}

function warning() {
	log "\033[33m$*\033[0m"
}
