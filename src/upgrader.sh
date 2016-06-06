function upgrade() {
	local BIN_PATH="$0"
	local TEMP_PATH=$(mktemp -d bashelor_upgrade)

	(
		log "=> Updating $(success "bashelor")"
		if ! git clone https://github.com/jubianchi/bashelor.git ${TEMP_PATH} > /dev/null 2>&1
		then
			local STATUS=$?
			error "Bashelor was not upgraded: clone failed"
			return ${STATUS}
		fi

		cd ${TEMP_PATH} >/dev/null

		log "=> Running tests and building $(success "bashelor")"
		if ! make
		then
			local STATUS=$?
			error "Bashelor was not upgraded: tests failed"
			return ${STATUS}
		fi

		cd - >/dev/null

		log "=> Copying $(success "bashelor") to $(success "$BIN_PATH")"
		if ! cp -f ${TEMP_PATH}/bin/bashelor ${BIN_PATH}
		then
			local STATUS=$?
			error "Bashelor was not upgraded: copy failed"
			return ${STATUS}
		fi
	)

	local STATUS=$?

	rm -rf $TEMP_PATH
	return $STATUS
}
