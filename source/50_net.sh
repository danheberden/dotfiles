# IP addresses
alias wanip="dig +short myip.opendns.com @resolver1.opendns.com"
alias whois="whois -h whois-servers.net"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache"

# View HTTP traffic
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# sshtunnel
sshtunnel() {
  if [[ -n "$1" && -n "$2" ]]; then
    ssh -D $1 -C -N $2
  else
    echo "Use like this: sshtunnel <port> <address>"
  fi
}
