function githubBashelorDriver() {
	local URL

	URL="http://github.com/$1"
	DEST="$1"

	gitBashelorDriver "$URL" "$DEST"
}
