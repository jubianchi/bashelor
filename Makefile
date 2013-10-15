all: bandleader driver bin
	echo "#!/bin/bash\n" > bin/bandleader
	cat build/driver.sh build/bandleader.sh >> bin/bandleader
	chmod +x bin/bandleader

bandleader: build
	cp src/bandleader.sh build/

driver: build
	cat src/driver/*.sh > build/driver.sh

build:
	mkdir build

bin:
	mkdir bin

clean:
	rm -rf bin build