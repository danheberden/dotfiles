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
  echo "$@" >> "$JOURNAL_PATH$(date +'%Y-%m-%d')" && history -d $(($HISTCMD-1))
}

alias lsusb="system_profiler SPUSBDataType"
