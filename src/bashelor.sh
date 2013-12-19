[ -z "$(printenv BASHELOR_VENDOR_DIRECTORY)" ] && BASHELOR_VENDOR_DIRECTORY='vendor'
[ -z "$(printenv BASHELOR_PATH)" ] && BASHELOR_PATH="$(pwd)"

BASHELOR_PATH="$BASHELOR_PATH/$BASHELOR_VENDOR_DIRECTORY"
BASHELOR_PID=$$

function usage() {
	log "Usage: $(success $0) $(warning [-h] [-q]) $(success [install] [inline])"
	log
	log "  $(success install): Install dependencies"
	log "  $(success inline): Inline install dependencies"
	log
	log "  $(warning -q): Quiet mode (no output)"
	log "  $(warning -h): Display this help message"
}

function require() {
	local DRIVER="$1BashelorDriver"
	local URL="$2"
	local DEST="$3"
	local PREVPWD=$(pwd)

	[ ! -d "$BASHELOR_VENDOR_DIRECTORY" ] && mkdir "$BASHELOR_VENDOR_DIRECTORY"

	cd ${BASHELOR_VENDOR_DIRECTORY}
	${DRIVER} "$URL" "$DEST"
	log
	cd "$DEST"
	( [ -f deps ] && . deps || true )
	cd "$PREVPWD"
}

function mainuse() {
	local LIB

	for LIB in $*
	do
		if [ -f "$BASHELOR_PATH/$LIB" ]
		then
			function use() {
				BASHELOR_PATH="$(dirname "$BASHELOR_VENDOR_DIRECTORY/$LIB")/$BASHELOR_VENDOR_DIRECTORY" mainuse $*
			}

			BASHELOR_CURRENT_DIR=$(dirname "$BASHELOR_PATH/$LIB")
			. "$BASHELOR_PATH/$LIB"

			function use() {
				mainuse $*
			}
		else
			error "$LIB (resolved from $(pwd) to $BASHELOR_PATH/$LIB) does not exist"

			exit 2
		fi
	done
}

if [ "$(type -t use 2> /dev/null)" != "function" ]
then
	function use() {
		mainuse $*
	}
fi

function reluse() {
	local LIB

	[ -z "$BASHELOR_CURRENT_DIR" ] && BASHELOR_CURRENT_DIR=$(pwd)

	for LIB in $*
	do
		if [ -f "$BASHELOR_CURRENT_DIR/$LIB" ]
		then
			. "$BASHELOR_CURRENT_DIR/$LIB"
		else
			error "$LIB (resolved from $(pwd) to $BASHELOR_PATH/$LIB) does not exist"

			exit 2
		fi
	done
}

if [[ -z "$1" || "$1" = "-h" ]]
then
	usage

	exit
fi

if [ "$1" = "-q" ]
then
	function log() {
		return
	}

	shift
fi

if [ "$1" = "install" ]
then
	if [ -f deps ]
	then
		. deps
	else
		error "Nos deps file found in $(pwd)"

		exit 2
	fi

	[ "$2" != "inline" ] && exit 0
elif [ "$1" = "upgrade" ]
then
	upgrade
else
	error "Unknown command \033[1;31m$1"

	exit 22
fi
