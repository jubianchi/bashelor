function __FILE__() {
	local FILE=${BASH_SOURCE[1]}
	local DIR=$(dirname "$FILE")

	DIR=$(cd "$DIR"; pwd)
	FILE=$(basename "$FILE")

	echo "$DIR/$FILE"
}

function __DIR__() {
	local DIR=$(dirname ${BASH_SOURCE[1]})

	cd "$DIR"; pwd
}

function __SOURCE__() {
	realpath ${BASH_SOURCE[2]}
}

function realpath() {
	if [ -f "$1" ]
	then
		local DIR=$(dirname "$1")
		local FILE=$(basename "$1")

		DIR=$(cd "$DIR"; pwd)

		echo "$DIR/$FILE"
	else
		echo $(cd "$1" > /dev/null 2>&1 && pwd)
	fi
}
