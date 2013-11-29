describe "bashelor usage"

it_displays_usage() {
	local USAGE=$(bin/bashelor -h)

	local LINE1=$(echo "$USAGE" | head -n1)
	local LINE3=$(echo "$USAGE" | head -n3 | tail -n1)
	local LINE4=$(echo "$USAGE" | head -n4 | tail -n1)
	local LINE6=$(echo "$USAGE" | head -n6 | tail -n1)
	local LINE7=$(echo "$USAGE" | head -n7 | tail -n1)

	[ "$LINE1" = "$(echo -e "Usage: \033[32mbin/bashelor\033[0m \033[33m[-h] [-q]\033[0m \033[32m[install] [inline]\033[0m")" ]
	[ "$LINE3" = "$(echo -e "  \033[32minstall\033[0m: Install dependencies")" ]
	[ "$LINE4" = "$(echo -e "  \033[32minline\033[0m: Inline install dependencies")" ]
	[ "$LINE6" = "$(echo -e "  \033[33m-q\033[0m: Quiet mode (no output)")" ]
	[ "$LINE7" = "$(echo -e "  \033[33m-h\033[0m: Display this help message")" ]
}