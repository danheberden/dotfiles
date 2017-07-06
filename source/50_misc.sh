# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

export GREP_OPTIONS='--color=auto'

# Prevent less from clearing the screen while still showing colors.
export LESS=-XR

# Set the terminal's title bar.
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}

# SSH auto-completion based on entries in known_hosts.
if [[ -e ~/.ssh/known_hosts ]]; then
  complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp stfp
fi

# Create a new directory and enter it
export JOURNAL_PATH="/Users/danheberden/Citadel/danheberden/.private/workjournal/"
function journal() {
  echo "$@" >> "$JOURNAL_PATH$(date +'%Y-%m-%d')" && history -d $(($HISTCMD-2))
}

alias lsusb="system_profiler SPUSBDataType"
function pgc() {
  # get the passed keychain data
  local PGC_KEYCHAIN="$(security find-generic-password -l $1)"

  # parse the keychain for the account name and cut after the =
  local PGC_USER=$(printf "$PGC_KEYCHAIN" | grep -a acct | cut -d '=' -f 2)
  PGC_USER="${PGC_USER:1:${#PGC_USER}-2}" # remove the quotes

  # parse the keychain for the service and cut after the =
  local PGC_PATH=$(printf "$PGC_KEYCHAIN" | grep -a svce | cut -d '=' -f 2)
  PGC_PATH="${PGC_PATH:1:${#PGC_PATH}-2}" # remove the quotes

  # rerun to get the password
  local PGC_PASS="$(security find-generic-password -l $1 -w)"

  pgcli "postgres://$PGC_USER:$PGC_PASS@$PGC_PATH"
}

. ~/.ec2/nexus-environment
