function githubBashelorDriver() {
	local URL="http://github.com/$1"
	local DEST="$2"

	[ -z "$DEST" ] && DEST="$1"

	gitBashelorDriver "$URL" "$DEST"
}
