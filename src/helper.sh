function bashelor.helper.usage() {
	bashelor.logger.log "Usage: $(bashelor.logger.success $0) $(bashelor.logger.warning [-h] [-q]) $(bashelor.logger.success [install] [inline])"
	bashelor.logger.log
	bashelor.logger.log "  $(bashelor.logger.success install): Install dependencies"
	bashelor.logger.log "  $(bashelor.logger.success inline): Inline install dependencies"
	bashelor.logger.log
	bashelor.logger.log "  $(bashelor.logger.warning -q): Quiet mode (no output)"
	bashelor.logger.log "  $(bashelor.logger.warning -h): Display this help message"
}
