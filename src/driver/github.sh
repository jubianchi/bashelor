function githubBashelorDriver() {
	local URL="https://github.com/$1"
	local DEST="$2"

	[ -z "$DEST" ] && DEST="$1"

	gitBashelorDriver "$URL" "$DEST"
}
