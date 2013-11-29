function pathBashelorDriver() {
	local URL="$1"
	local DIRECTORY="$2"

	if [ -d "$DIRECTORY" ]
	then
		log "=> Updating $(success $DIRECTORY)"
		rm -rf "$DIRECTORY"
	else
		log "=> Installing $(success $DIRECTORY)"
	fi

	mkdir -p "$DIRECTORY"

	cp -r "$URL"/* "$DIRECTORY"
	warning "   Installed $DIRECTORY"
}
