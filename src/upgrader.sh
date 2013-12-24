function bashelor.upgrader.upgrade() {
	local BIN_PATH="$0"
	local TEMP_PATH=$(mktemp -d)

	(
		bashelor.logger.log "=> Updating $(bashelor.logger.success "bashelor")"
		if ! git clone https://github.com/jubianchi/bashelor.git ${TEMP_PATH} > /dev/null 2>&1
		then
			local STATUS=$?
			bashelor.logger.error "Bashelor was not upgraded: clone failed"
			exit ${STATUS}
		fi

		cd ${TEMP_PATH}

		bashelor.logger.log "=> Running tests and building $(bashelor.logger.success "bashelor")"
		if ! make
		then
			local STATUS=$?
			bashelor.logger.error "Bashelor was not upgraded: tests failed"
			exit ${STATUS}
		fi

		bashelor.logger.log "=> Copying $(bashelor.logger.success "bashelor") to $(bashelor.logger.success "$TEMP_PATH")"
 		if ! cp -f bin/bashelor ${BIN_PATH}
 		then
 			local STATUS=$?
			bashelor.logger.error "Bashelor was not upgraded: copy failed"
			exit ${STATUS}
		fi
	)
}
