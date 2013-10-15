function git() {
	local URL
	local DIRECTORY

	which git > /dev/null 2>&1 || (echo 'git command is not available' && exit 1)

	URL="$1"
	DIRECTORY="$2"

	if [ -d "$DIRECTORY" ]
	then
		log "=> Updating $DIRECTORY"
		(cd "$DIRECTORY" && /usr/bin/env git pull > /dev/null 2>&1)
	else
		log "=> Installing $URL into $DIRECTORY"
		/usr/bin/env git clone "$URL" "$DIRECTORY" > /dev/null 2>&1
	fi
}
