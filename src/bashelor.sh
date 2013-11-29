function log() {
	echo $*
}

if [ "$1" = "-q" ]
then
	function log() {
		return
	}

	shift
fi

[ -z "$BASHELOR_VENDOR_DIRECTORY" ] && BASHELOR_VENDOR_DIRECTORY='vendor'

function require() {
	local DRIVER
	local URL
	local DEST

	DRIVER="$1"
	URL="$2"
	DEST="$3"

	[ ! -d "$BASHELOR_VENDOR_DIRECTORY" ] && mkdir "$BASHELOR_VENDOR_DIRECTORY"

	(
		cd $BASHELOR_VENDOR_DIRECTORY && \
		$DRIVER "$URL" "$DEST" && \
		cd "$DEST" && \
		(
			[ -f deps ] && . deps || true
		)
	)
}

function mainuse() {
	[ -z "$BASHELOR_PATH" ] && BASHELOR_PATH="$(dirname $0)"
	BASHELOR_PATH="$BASHELOR_PATH/$BASHELOR_VENDOR_DIRECTORY"

	for LIB in $*
	do
		if [ -f "$BASHELOR_PATH/$LIB" ]
		then
			function use() {
				BASHELOR_PATH="$(dirname "$BASHELOR_VENDOR_DIRECTORY/$LIB")/$BASHELOR_VENDOR_DIRECTORY" mainuse $*
			}

			. "$BASHELOR_PATH/$LIB"

			function use() {
				mainuse $*
			}
		else
			echo "$BASHELOR_PATH/$LIB does not exist"
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

if [ "$1" = "install" ]
then
	[ -f deps ] && . deps

	[ "$2" != "inline" ] && exit
fi