function bashelor.logger.log() {
	echo -e "$*"
}

function bashelor.logger.error() {
	bashelor.logger.log "\033[31m$*\033[0m"

	local CALLER=$(caller 2)
	local FILE=$(echo ${CALLER} | cut -d' ' -f3)
	local LINE=$(echo ${CALLER} | cut -d' ' -f1)

	[ -n "$CALLER" ] && bashelor.logger.log "\033[31m └── $FILE (line $LINE)\033[0m"
}

function bashelor.logger.success() {
	bashelor.logger.log "\033[32m$*\033[0m"
}

function bashelor.logger.warning() {
	bashelor.logger.log "\033[33m$*\033[0m"
}
