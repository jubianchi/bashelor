[ -z "$BASHELOR_VENDOR_DIRECTORY" ] && BASHELOR_VENDOR_DIRECTORY='vendor'
[ -z "$BASHELOR_PATH" ] && BASHELOR_PATH="$(dirname $0)"
BASHELOR_PATH="$BASHELOR_PATH/$BASHELOR_VENDOR_DIRECTORY"
BASHELOR_PID=$$

if [ "$1" = "-q" ]
then
	function log() {
		return
	}

	shift
fi

function require() {
	local DRIVER
	local URL
	local DEST

	DRIVER="$1BashelorDriver"
	URL="$2"
	DEST="$3"

	[ ! -d "$BASHELOR_VENDOR_DIRECTORY" ] && mkdir "$BASHELOR_VENDOR_DIRECTORY"

	(
		cd $BASHELOR_VENDOR_DIRECTORY && \
		$DRIVER "$URL" "$DEST" && echo && \
		cd "$DEST" && \
		( [ -f deps ] && . deps ) || true
	)
}

function mainuse() {
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
			error 2 "$LIB does not exist"
		fi
	done
}

BASHELOR_USE_TYPE=$(type -t use 2> /dev/null)
if [ "$BASHELOR_USE_TYPE" != "function" ]
then
	function use() {
		mainuse $*
	}
fi

function reluse() {
	for LIB in $*
	do
		if [ -f "$BASHELOR_CURRENT_DIR/$LIB" ]
		then
			. "$BASHELOR_CURRENT_DIR/$LIB"
		else
			error 2 "$LIB does not exist"
		fi
	done
}

if [ "$1" = "install" ]
then
	[ -f deps ] && . deps

	[ "$2" != "inline" ] && exit 0
fi
