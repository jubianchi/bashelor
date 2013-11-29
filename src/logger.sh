function log() {
	echo -e $*
}

function error() {
	log "\033[31m$*\033[0m"
}
