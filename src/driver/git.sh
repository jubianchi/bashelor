[ -z "$(printenv BASHELOR_GIT_CMD)" ] && BASHELOR_GIT_CMD=git

function gitBashelorDriver() {
	local GIT=$(which "$BASHELOR_GIT_CMD" 2> /dev/null)

	if [[ -z "$GIT" || ! $? -eq 0 ]]
	then
		error "git command ($BASHELOR_GIT_CMD) is not available"

		exit 45
	fi

	local URL="$1"
	local DIRECTORY="$2"
	local PREV_REV=""
	local CURRENT_REV=""

	if [ -d "$DIRECTORY" ]
	then
		PREV_REV=$(${GIT} --git-dir="$DIRECTORY/.git" rev-parse --short HEAD)

		log "=> Updating $(success "$DIRECTORY")"
		(
			cd "$DIRECTORY" && \
			${GIT} pull
		) > /dev/null 2>&1
	else
		log "=> Cloning $(success "$URL") into $(success "$DIRECTORY")"
		${GIT} clone "$URL" "$DIRECTORY" > /dev/null 2>&1
	fi

	CURRENT_REV=$(${GIT} --git-dir="$DIRECTORY/.git" rev-parse --short HEAD)

	if [ -n "$PREV_REV" ]
	then
		if [ "$PREV_REV" != "$CURRENT_REV" ]
		then
			warning "   Updated $PREV_REV..$CURRENT_REV"
			warning "  $(${GIT} --git-dir="$DIRECTORY/.git" diff --shortstat "$PREV_REV..$CURRENT_REV")"
		else
			warning "   Nothing to update ($CURRENT_REV)"
		fi
	else
		warning "   Installed $DIRECTORY@$CURRENT_REV"
	fi
}
