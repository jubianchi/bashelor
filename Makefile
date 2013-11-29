# Action targets
test: clean bin/bashelor
	@bin/bashelor install
	@cd tests && ../vendor/dfs-sh/roundup/roundup.sh test-*.sh

clean:
	@rm -rf bin build

# File targets
bin/bashelor: bin build/driver build/bashelor
	@echo "#!/bin/bash\n" > bin/bashelor
	@cat build/driver build/bashelor >> bin/bashelor
	@chmod +x bin/bashelor

build/bashelor: build
	@cat src/logger.sh src/bashelor.sh > build/bashelor

build/driver: build
	@cat src/driver/*.sh > build/driver

# Directory targets
build:
	@mkdir build

bin:
	@mkdir bin