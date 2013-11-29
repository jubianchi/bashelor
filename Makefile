test: clean bin/bashelor
	@bin/bashelor install
	@vendor/dfs-sh/roundup/roundup.sh tests/*sh

bin/bashelor: bin build/bashelor build/driver
	@echo "#!/bin/bash\n" > bin/bashelor
	@cat build/driver build/bashelor >> bin/bashelor
	@chmod +x bin/bashelor

build/bashelor: build
	@cat src/logger.sh src/bashelor.sh > build/bashelor

build/driver: build
	@cat src/driver/*.sh > build/driver

build:
	@mkdir build

bin:
	@mkdir bin

clean:
	@rm -rf bin build