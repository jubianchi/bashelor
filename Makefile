all: bashelor driver bin
	echo "#!/bin/bash\n" > bin/bashelor
	cat build/driver.sh build/bashelor.sh >> bin/bashelor
	chmod +x bin/bashelor

bashelor: build
	cp src/bashelor.sh build/

driver: build
	cat src/driver/*.sh > build/driver.sh

build:
	mkdir build

bin:
	mkdir bin

clean:
	rm -rf bin build