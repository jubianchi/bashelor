[ -z "$(printenv BASHELOR_GIT_CMD)" ] && BASHELOR_GIT_CMD=git

function bashelor.driver.git() {
	local GIT=$(which "$BASHELOR_GIT_CMD" 2> /dev/null)

	if [[ -z "$GIT" || ! $? -eq 0 ]]
	then
		bashelor.logger.error "git command ($BASHELOR_GIT_CMD) is not available"

		exit 45
	fi

	local URL="$1"
	local DIRECTORY="$2"
	local PREV_REV=""
	local CURRENT_REV=""

	if [ -d "$DIRECTORY" ]
	then
		PREV_REV=$(cd ${DIRECTORY} && ${GIT} rev-parse --short HEAD)

		bashelor.logger.log "=> Updating $(bashelor.logger.success "$DIRECTORY")"
		(
			cd "$DIRECTORY" && \
			${GIT} pull
		) > /dev/null 2>&1
	else
		bashelor.logger.log "=> Cloning $(bashelor.logger.success "$URL") into $(bashelor.logger.success "$DIRECTORY")"
		${GIT} clone "$URL" "$DIRECTORY" > /dev/null 2>&1
	fi

	CURRENT_REV=$(${GIT} --git-dir="$DIRECTORY/.git" rev-parse --short HEAD)

	if [ -n "$PREV_REV" ]
	then
		if [ "$PREV_REV" != "$CURRENT_REV" ]
		then
			bashelor.logger.warning "   Updated $PREV_REV..$CURRENT_REV"
			bashelor.logger.warning "  $(cd ${DIRECTORY} ${GIT} diff --shortstat "$PREV_REV..$CURRENT_REV")"
		else
			bashelor.logger.warning "   Nothing to update ($CURRENT_REV)"
		fi
	else
		bashelor.logger.warning "   Installed $DIRECTORY@$CURRENT_REV"
	fi
}
