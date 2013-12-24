function bashelor.driver.path() {
	local URL="$1"
	local DIRECTORY="$2"

	if [ -d "$DIRECTORY" ]
	then
		bashelor.logger.log "=> Updating $(bashelor.logger.success $DIRECTORY)"
		rm -rf "$DIRECTORY"
	else
		bashelor.logger.log "=> Installing $(bashelor.logger.success $DIRECTORY)"
	fi

	mkdir -p "$DIRECTORY"

	cp -r "$URL"/* "$DIRECTORY"
	bashelor.logger.warning "   Installed $DIRECTORY"
}
