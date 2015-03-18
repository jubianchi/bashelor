function isset() {
    [ ! -z "$(printenv $1)" ]
}
