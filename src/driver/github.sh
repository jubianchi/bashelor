function githubBashelorDriver() {
	local URL

	URL="http://github.com/$1"
	DEST="$2"

    [ -z "$DEST" ] && DEST="$1"

	gitBashelorDriver "$URL" "$DEST"
}
