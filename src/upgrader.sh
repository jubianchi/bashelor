function upgrade() {
	local BIN_PATH="$0"
	local TEMP_PATH=$(mktemp -d)

	(
		log "=> Updating $(success "bashelor")"
		if ! git clone https://github.com/jubianchi/bashelor.git ${TEMP_PATH} > /dev/null 2>&1
		then
			local STATUS=$?
			error "Bashelor was not upgraded: clone failed"
			exit ${STATUS}
		fi

		cd ${TEMP_PATH}

		log "=> Running tests and building $(success "bashelor")"
		if ! make
		then
			local STATUS=$?
			error "Bashelor was not upgraded: tests failed"
			exit ${STATUS}
		fi

		log "=> Copying $(success "bashelor") to $(success "$TEMP_PATH")"
 		if ! cp -f bin/bashelor ${BIN_PATH}
 		then
 			local STATUS=$?
			error "Bashelor was not upgraded: copy failed"
			exit ${STATUS}
		fi
	)
}
