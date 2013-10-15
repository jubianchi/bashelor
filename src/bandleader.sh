if [ "$1" = "-q" ]
then
	function log() {
		return
	}
else
	function log() {
		echo $*
	}
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

	( cd $BAND_DIRECTORY && $DRIVER "$URL" "$DEST" )
}

function use() {
	for LIB in $*
	do
		. "$BAND_DIRECTORY/$LIB"
	done
}

[ -f band ] && . band
