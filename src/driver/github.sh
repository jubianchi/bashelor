function bashelor.driver.github() {
	local URL="https://github.com/$1"
	local DEST="$2"

	[ -z "$DEST" ] && DEST="$1"

	bashelor.driver.git "$URL" "$DEST"
}
