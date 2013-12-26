function bashelor.driver.path() {
	local URL="$1"
	local DIRECTORY="$2"

	if [ ! -d "$URL" ]
	then
		bashelor.logger.error "   Could not install $DIRECTORY: Directory $URL not found"

		return 2
	fi

	if [ -d "$DIRECTORY" ]
	then
		bashelor.logger.log "=> Updating $(bashelor.logger.success ${DIRECTORY})"
		rm -rf "$DIRECTORY"
	else
		bashelor.logger.log "=> Installing $(bashelor.logger.success ${DIRECTORY})"
	fi

	mkdir -p $(dirname "$DIRECTORY")
	cp -r "$URL" "$DIRECTORY"

	if [ -d "$DIRECTORY" ]
	then
		bashelor.logger.warning "   Installed $DIRECTORY"
	fi
}
