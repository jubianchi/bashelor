function gitBashelorDriver() {
	local URL
	local DIRECTORY

	which git > /dev/null 2>&1 || (echo 'git command is not available' && exit 1)

	URL="$1"
	DIRECTORY="$2"
	PREV_REV=""
	CURRENT_REV=""

	if [ -d "$DIRECTORY" ]
	then
		PREV_REV=$(git --git-dir="$DIRECTORY/.git" rev-parse --short HEAD)

		log "=> Updating $(success $DIRECTORY)"
		(
			cd "$DIRECTORY" && \
			/usr/bin/env git pull
		) > /dev/null 2>&1
	else
		log "=> Installing $(success $URL) into $(success $DIRECTORY)"
		/usr/bin/env git clone "$URL" "$DIRECTORY" > /dev/null 2>&1
	fi

	CURRENT_REV=$(git --git-dir="$DIRECTORY/.git" rev-parse --short HEAD)

	if [ -n "$PREV_REV" ]
	then
		if [ "$PREV_REV" != "$CURRENT_REV" ]
		then
			warning "   Updated $PREV_REV..$CURRENT_REV"
		else
			warning "   Nothing to update ($CURRENT_REV)"
		fi
	else
		warning "   Installed $CURRENT_REV"
	fi
}
