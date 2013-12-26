[ -z "$(printenv BASHELOR_VENDOR_DIRECTORY)" ] && BASHELOR_VENDOR_DIRECTORY='vendor'
[ -z "$(printenv BASHELOR_PATH)" ] && BASHELOR_PATH="$(pwd)"

BASHELOR_PATH="$BASHELOR_PATH/$BASHELOR_VENDOR_DIRECTORY"
BASHELOR_PID=$$

function bashelor.require() {
	local DRIVER="bashelor.driver.$1"
	local URL="$2"
	local DEST="$3"
	local PREVPWD=$(pwd)

	[ ! -d "$BASHELOR_VENDOR_DIRECTORY" ] && mkdir "$BASHELOR_VENDOR_DIRECTORY"
	[ -z "$DEST" ] && DEST="$URL"

	cd ${BASHELOR_VENDOR_DIRECTORY}

	${DRIVER} "$URL" "$DEST"
	local STATUS=$?

	if [ -d "$DEST" ]
	then
		cd "$DEST"
		[ -f deps ] && . deps
		cd "$PREVPWD"
	else
		cd "$PREVPWD"
		exit ${STATUS}
	fi
}

function bashelor.mainuse() {
	local LIB

	for LIB in $*
	do
		if [ -f "$BASHELOR_PATH/$LIB" ]
		then
			function bashelor.use() {
				BASHELOR_PATH="$(dirname "$BASHELOR_VENDOR_DIRECTORY/$LIB")/$BASHELOR_VENDOR_DIRECTORY" bashelor.mainuse $*
			}

			BASHELOR_CURRENT_DIR=$(dirname "$BASHELOR_PATH/$LIB")
			. "$BASHELOR_PATH/$LIB"

			function bashelor.use() {
				bashelor.mainuse $*
			}
		else
			bashelor.logger.error "$LIB (resolved from $(pwd) to $BASHELOR_PATH/$LIB) does not exist"

			exit 2
		fi
	done
}

if [ "$(type -t bashelor.use 2> /dev/null)" != "function" ]
then
	function bashelor.use() {
		bashelor.mainuse $*
	}
fi

function bashelor.reluse() {
	local LIB

	[ -z "$BASHELOR_CURRENT_DIR" ] && BASHELOR_CURRENT_DIR=$(pwd)

	for LIB in $*
	do
		if [ -f "$BASHELOR_CURRENT_DIR/$LIB" ]
		then
			. "$BASHELOR_CURRENT_DIR/$LIB"
		else
			bashelor.logger.error "$LIB (resolved from $(pwd) to $BASHELOR_PATH/$LIB) does not exist"

			exit 2
		fi
	done
}

if [[ -z "$1" || "$1" = "-h" ]]
then
	bashelor.helper.usage

	exit
fi

if [ "$1" = "-q" ]
then
	function bashelor.logger.log() {
		return
	}

	shift
fi

[ -z "$(printenv BASHELOR_WORKING)" ] && export BASHELOR_WORKING=0
[ "$BASHELOR_WORKING" -eq 1 ] && exit


if [ "$1" = "install" ]
then
	export BASHELOR_WORKING=1

	if [ -f deps ]
	then
		. deps
	else
		bashelor.logger.error "Nos deps file found in $(pwd)"

		exit 2
	fi

	[ "$2" != "inline" ] && exit 0
elif [ "$1" = "upgrade" ]
then
	bashelor.upgrader.upgrade
else
	bashelor.logger.error "Unknown command \033[1;31m$1"

	exit 22
fi
