[ -z "$(printenv BASHELOR_GIT_CMD)" ] && BASHELOR_GIT_CMD=$(findCli "git" 2> /dev/null)

function gitBashelorDriver() {
	if [[ -z "$BASHELOR_GIT_CMD" || ! -x "$BASHELOR_GIT_CMD" ]]
	then
		error "git command ($BASHELOR_GIT_CMD) is not available"

		return 45
	fi

	local URL="$1"
	local DIRECTORY="$2"
	local PREV_REV=""
	local CURRENT_REV=""

	if [ -d "$DIRECTORY" ]
	then
		PREV_REV=$(${BASHELOR_GIT_CMD} --git-dir="$DIRECTORY/.git" rev-parse --short HEAD)

		log "=> Updating $(success "$DIRECTORY")"
		(
			cd "$DIRECTORY" && \
			${BASHELOR_GIT_CMD} pull
		) > /dev/null 2>&1
	else
		log "=> Cloning $(success "$URL") into $(success "$DIRECTORY")"
		${BASHELOR_GIT_CMD} clone "$URL" "$DIRECTORY" > /dev/null 2>&1
	fi

	CURRENT_REV=$(${BASHELOR_GIT_CMD} --git-dir="$DIRECTORY/.git" rev-parse --short HEAD)

	if [ -n "$PREV_REV" ]
	then
		if [ "$PREV_REV" != "$CURRENT_REV" ]
		then
			warning "   Updated $PREV_REV..$CURRENT_REV"
			warning "  $(${BASHELOR_GIT_CMD} --git-dir="$DIRECTORY/.git" diff --shortstat "$PREV_REV..$CURRENT_REV")"
		else
			warning "   Nothing to update ($CURRENT_REV)"
		fi
	else
		warning "   Installed $DIRECTORY@$CURRENT_REV"
	fi

	return 0
}
