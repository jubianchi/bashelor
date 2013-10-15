function github() {
	local URL

	URL="http://github.com/$1"
	DEST="$1"

	git "$URL" "$DEST"
}
