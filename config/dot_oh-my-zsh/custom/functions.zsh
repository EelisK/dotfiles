#==============================================================#
##         Profiler                                           ##
#==============================================================#

function zsh-startuptime() {
    local total_msec=0
    local msec
    local i
    for i in $(seq 1 10); do
        msec=$((TIMEFMT='%mE'; time zsh -i -c exit) 2>/dev/stdout >/dev/null)
        msec=$(echo $msec | tr -d "ms")
        echo "${(l:2:)i}: ${msec}"
        total_msec=$(( $total_msec + $msec ))
    done
    local average_msec
    average_msec=$(( ${total_msec} / 10 ))
    echo "\naverage: ${average_msec} [ms]"
}

function zsh-profiler() {
    ZSHRC_PROFILE=1 zsh -i -c zprof
}

function zsh-startuptime-slower-than-default() {
    local time_rc
    time_rc=$((TIMEFMT="%mE"; time zsh -i -c exit) &> /dev/stdout)
    # time_norc=$((TIMEFMT="%mE"; time zsh -df -i -c exit) &> /dev/stdout)
    # compinit is slow
    local time_norc
    time_norc=$((TIMEFMT="%mE"; time zsh -df -i -c "autoload -Uz compinit && compinit -C; exit") &> /dev/stdout)
    echo "my zshrc: ${time_rc}\ndefault zsh: ${time_norc}\n"

    local result
    result=$(scale=3 echo "${time_rc%ms} / ${time_norc%ms}" | bc)
    echo "${result}x slower your zsh than the default."
}


#==============================================================#
##         Misc                                               ##
#==============================================================#

function reload() {
    exec zsh
}
