#### Automatic Diferential Curl Oh!!!
# Runs sequential requests with cURL and shows differences
# between them.
#
# cURL uses <CR><LF> notation for breaking lines. So we
# have to convert terminal do LC_CTYPE=C; LANG=C to avoid
# DIFF glitches.
#
# Depends on "colordiff" (brew install colordiff)
# 
alias adcurlo='autocurl() {
    start=`date +"%Y-%m-%d %H:%M:%S%z"`
    start_sec=`date +%s`
    count=1
    current=""
    previous=""
    >&2 echo "-- Started: $start --"
    while true
        do
        secs=$((`date +%s` - $start_sec))
        elapsed=$( printf "%dd:%dh:%dm:%ds\n" $((secs/86400)) $((secs%86400/3600)) $((secs%3600/60)) $((secs%60)) )

        >&2 echo -e "\n--- [Run: $count, time: `date +"%Y-%m-%d %H:%M:%S%z"`, elapsed: $elapsed sec ] ---"
        
        current=`curl -v -H "pragma: azion-debug-cache" -o /dev/null $* 2>&1 | tr -d "\r"`
        diff -y -W $COLUMNS <(echo "$previous") <(echo "$current") | iconv -f ISO-8859-1 -t utf8 | colordiff
        
        previous="$current"
        sleep 3
        let count=$count+1
    done
}; autocurl $*'

## Automatic cURL Oh!
# Runs sequential cURL requests with azion features
# like pragma and redirect of output.
#
# Depends on colordiff and coreutils
# Run: 
#    brew install coreutils colordiff
alias acurlo='autocurl() {
    # Default values
    match="x-debug"
    output="/dev/null"
    interval=5
    curl_opts=(-v -H "pragma: azion-debug-cache")

    # Parse arguments and override defaults if provided, without using "=" notation
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -M|--match)
                shift
                [[ $# -gt 0 ]] && match="$1" && shift
                ;;
            -o|--output)
                shift
                [[ $# -gt 0 ]] && output="$1" && shift
                ;;
            -i|--interval)
                shift
                [[ $# -gt 0 ]] && interval="$1" && shift
                ;;
            *)
                curl_opts+=("$1")
                shift
                ;;
        esac
    done

    # Add output option if not default
    curl_opts+=(-o "$output")

    start=`date +"%Y-%m-%d %H:%M:%S%z"`
    start_sec=`date +%s`
    count=1
    old_x_debug="None"
    >&2 echo "-- Started: $start (interval: $interval sec; Options: \"${curl_opts[@]}\") --"

    while true
        do
        loop_start=$(date +%s)
        
        x=`curl ${curl_opts} 2>&1 | tr -d "\r"`
        x_debug=`echo -e "$x" | grep "$match"`
        
        echo -e "$x"

        secs=$((`date +%s` - $start_sec))
        elapsed=$( printf "%dd:%dh:%dm:%ds\n" $((secs/86400)) $((secs%86400/3600)) $((secs%3600/60)) $((secs%60)) )
        
        >&2 echo -e "\n--- [Run: $count, time: `date +"%Y-%m-%d %H:%M:%S%z"`, elapsed: $elapsed sec, $match: $x_debug ] ---"

        [[ $count -eq 1 ]] && \
            { [[ -z "$x_debug" ]] && echo "Notice: no match for [$match] detected" } || \
        
        { [[ $old_x_debug != "$x_debug" ]] && { colordiff -W $COLUMNS -y <(echo $old_x_debug) <(echo $x_debug) || \
            { echo -e "\a"; timeout $interval say -v Samantha -r 230 "Match \"$match\" changed to: [$x_debug]" } } }
        
        # Given a timeout of 5s, calculate remaining time after a block of commands
        loop_end=$(date +%s)
        loop_elapsed=$(( loop_end - loop_start ))
        sleep_time_left=$(($interval - $loop_elapsed))

        [[ $sleep_time_left -gt 0 ]] && sleep $sleep_time_left
        let count=$count+1
        old_x_debug=$x_debug
    done
}; autocurl $*'

## cURL Oh!
# just an easy shortcut to run cURL with Azion common
# options.
alias curlo="curl -v -H 'pragma: azion-debug-cache' -o /dev/null 2>&1"


alias certshow='mycertshow() {
    cname=$1
    ip_addr=${2:-$1}
    openssl s_client -showcerts -connect $ip_addr:443 -servername $cname | openssl x509 -text
}; mycertshow $*'

alias certdns='mycertdns() {
    domain=$1
    ip_addr=${2:-$1}
    openssl s_client -connect $domain:443 -servername $domain -showcerts </dev/null 2>/dev/null | openssl x509 -noout -text | grep 'DNS:' | sed 's/DNS://g' | tr -s " ,\n" "\n"
}; mycertdns $*'

alias searchcdn='myfindcdn() {
 l=$1; dns_point=`dig +short $l | head -1`; echo "$l -> $dns_point -> reverse: `if [[ $dns_point =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then host $dns_point; else echo "NOT AN IP"; fi`"; whois $l | grep -e "OrgId" -e "OrgName" -e "NetName"}; myfindcdn $*'

alias azionip='dig +short a.map.azionedge.net | head -1'
alias azionipprev='dig +short lala.preview.map.azionedge.net | head -1'

alias azionstage='
azionstage_func() {
    # Try to read STAGE HOSTS from environment variable
    if [ -z "${AZION_STAGE_HOSTS[*]}" ]; then
        echo "No AZION_STAGE_HOSTS found in environment" >&2
        return 1
    fi

    for stage_host in "${AZION_STAGE_HOSTS[@]}"; do
        ip=$stage_host
        # If not an IP, resolve it
        if [[ ! $stage_host =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            ip=$(dig +short $host | head -1)
        fi
        if [[ -n "$ip" ]]; then
            # Try HTTPS connection, ignore output, timeout after 2s
            if timeout 2 bash -c "</dev/tcp/$ip/443" 2>/dev/null; then
                echo "$ip (https:443)"
                return 0
            elif timeout 2 bash -c "</dev/tcp/$ip/80" 2>/dev/null; then
                echo "$ip (http:80)"
                return 0
            fi
        fi
    done
    echo "No responsive server found while trying: ${AZION_STAGE_HOSTS}" >&2
    return 1
}; azionstage_func'

alias bestedge='bestEdge() {
    #set -x
    ip_addr=$1
    shift
    dig @ns1.azioncdn.net a.ha.azioncdn.net +subnet=$ip_addr/24 $*
}; bestEdge $*'

alias mychrome='myChrome() {
    target=${1}
    target_hostname=$(echo $target | awk -F/ {print\ \$3})
    ipadd=${2:-$(azionipprev)}
    set -x
    open -a "Google Chrome" -n --args --incognito --host-resolver-rules="MAP $target_hostname $ipadd" --new-window $target
    set +x
}; myChrome $*'

alias az_edge='myazedge() {
    result=$(curl -fsS $SRE_MANAGER_URL/api/metrics/blackbox/interfaces | \
        jq -r --arg ip "$1" ".hosts|to_entries[]|select([.value[]?]|flatten|index(\$ip))|.key") || \
            { echo "Please, connect to Azion VPN." && return 1 }
        
    [[ -z "$result" ]] && { echo "No server found for $1" && return 1 }
    
    echo "$result"
}; myazedge $*'


# Add timestamp
RPROMPT="[%D{%L:%M:%S}]"