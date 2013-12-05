DEBUG=
TEST="test-*.sh"

# Action targets
test: clean dist
	@bin/bashelor install
	@cd tests/specs && ../../vendor/dfs-sh/roundup/roundup.sh $(DEBUG) $(TEST)

test-debug:
	make test DEBUG="--debug"

dist: bin/bashelor

clean:
	@rm -rf bin build

.PHONY: test dist clean

# File targets
bin/bashelor: bin build/driver build/bashelor
	@echo "#!/bin/bash" | tee bin/bashelor > /dev/null
	@echo "#Built on $(shell date --rfc-2822)" | tee -a bin/bashelor > /dev/null
	@echo | tee -a bin/bashelor > /dev/null
	@cat build/driver build/bashelor >> bin/bashelor
	@chmod +x bin/bashelor

build/bashelor: build
	@cat src/fileutil.sh src/logger.sh src/upgrader.sh src/bashelor.sh > build/bashelor

build/driver: build
	@cat src/driver/*.sh > build/driver

# Directory targets
build:
	@mkdir build

bin:
	@mkdir bin
