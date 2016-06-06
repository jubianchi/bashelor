function isset() {
    [ ! -z "$(printenv $1)" ]
}

function findCli() {
    local CLI_PATH

    which > /dev/null 2>&1

    if [ $? -eq 127 ]
    then
        CLI_PATH=$(whereis $* 2> /dev/null)
    else
        CLI_PATH=$(which $* 2> /dev/null)
    fi

    if [ $? -neq 0 ]
    then
        CLI_PATH=""
    fi

    if [ -z "$CLI_PATH" ]
    then
        return 1
    fi

    echo $CLI_PATH | cut -d':' -f2

    return 0
}
