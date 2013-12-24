function usage() {
	log "Usage: $(success $0) $(warning [-h] [-q]) $(success [install] [inline])"
	log
	log "  $(success install): Install dependencies"
	log "  $(success inline): Inline install dependencies"
	log
	log "  $(warning -q): Quiet mode (no output)"
	log "  $(warning -h): Display this help message"
}
