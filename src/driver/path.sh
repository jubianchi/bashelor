function path() {
	local URL
	local DIRECTORY

	URL="$1"
	DIRECTORY="$2"

	if [ -d "$DIRECTORY" ]
	then
		log "=> Updating $DIRECTORY"
		rm -rf "$DIRECTORY"
	else
		log "=> Installing $DIRECTORY"
	fi

	mkdir -p "$DIRECTORY"

	cp -r "$URL"/* "$DIRECTORY"
}
