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

BAND_DIRECTORY='vendor'

function require() {
	local DRIVER
	local URL
	local DEST

	DRIVER="$1"
	URL="$2"
	DEST="$3"

	[ ! -d "$BAND_DIRECTORY" ] && mkdir "$BAND_DIRECTORY"

	(
		cd $BAND_DIRECTORY && \
		$DRIVER "$URL" "$DEST" && \
		cd "$DEST" && \
		$0 install
	)
}

function mainuse() {
	[ -z "$BAND_PATH" ] && BAND_PATH="$(dirname $0)/$BAND_DIRECTORY"

	for LIB in $*
	do
		if [ -f "$BAND_PATH/$LIB" ]
		then
			function use() {
				BAND_PATH="$(dirname "$BAND_DIRECTORY/$LIB")/$BAND_DIRECTORY" mainuse $*
			}

			. "$BAND_PATH/$LIB"

			function use() {
				mainuse $*
			}
		else
			echo "$BAND_PATH/$LIB does not exist"
		fi
	done
}

BAND_USE_TYPE=$(type -t use 2> /dev/null)
if [ "$BAND_USE_TYPE" != "function" ]
then
	function use() {
		mainuse $*
	}
fi

if [ "$1" = "install" ]
then
	[ -f band ] && . band

	exit
fi