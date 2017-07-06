# My awesome bash prompt
#
# Copyright (c) 2012 "Cowboy" Ben Alman
# Licensed under the MIT license.
# http://benalman.com/about/license/
#
# Example:
# [master:!?][cowboy@CowBook:~/.dotfiles]
# [11:14:45] $
#
# Read more (and see a screenshot) in the "Prompt" section of
# https://github.com/cowboy/dotfiles

# ANSI CODES - SEPARATE MULTIPLE VALUES WITH ;
#
#  0  reset          4  underline
#  1  bold           7  inverse
#
# FG  BG  COLOR     FG  BG  COLOR
# 30  40  black     34  44  blue
# 31  41  red       35  45  magenta
# 32  42  green     36  46  cyan
# 33  43  yellow    37  47  white
#

if [[ $COLORTERM = gnome-* && $TERM = xterm ]]  && infocmp gnome-256color >/dev/null 2>&1; then
  export TERM=gnome-256color
elif [[ $TERM != dumb ]] && infocmp xterm-256color > /dev/null 2>&1; then
  export TERM=xterm-256color
fi



# Eight Color Terminal
color_light=7
color_dark=0
color_prompt=7
color_userBG=6
color_hostBG=3
color_timeBG=4
color_folderBG=5
color_vcsBG=4
color_vcs1=2
color_vcs1=6
color_error=1
color_bold=""
color_reset="\033[m"
color_ascii=true
color_colors="8"
if tput setaf 1 &> /dev/null; then
  # Not in Ascii mode
  color_ascii=false
  # 256 Colors \o/
  if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
    color_prompt=32
    color_userBG=32
    color_hostBG=75
    color_timeBG=25
    color_folderBG=178
    color_vcsBG=172
    color_vcs1=194
    color_vcs2=230
    color_error=1
  fi
  color_bold=$(tput bold) #bold
  color_reset=$(tput sgr0) #reset
  # general="\032[1;37m"

  # TODO: move this
  if [[ "$SSH_TTY" ]]; then
    # connected via ssh
    prompt_colors[0]="$(tput setaf 123)"
  elif [[ "$USER" == "root" ]]; then
    # logged in as root
    prompt_colors[0]="$(tput setaf 97)"
  fi
fi


function fg() {
  local c
  if [[ "$color_ascii" == true ]]; then
    c="\032[1;3$1m"
  else
    c="$(tput setaf $1)"
  fi

  echo "$c"
}
function bg() {
  local c
  if [[ "$color_ascii" == true ]]; then
    c="\032[1;4$1m"
  else
    c="$(tput setab $1)"
  fi
  echo "$c"
}
function cl() {
  echo "$color_reset"
}
function bold() {
  echo "$color_bold"
}


# if [[ ! "${prompt_colors[@]}" ]]; then
#   if tput setaf 1 &> /dev/null; then
#     tput sgr0
#     if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
#       prompt_colors=(
#         "$(tput setaf 7)" # white - connecting text
#         "$(tput setab 32)$(tput setaf 7)" # blue - user
#         "$(tput setaf 178)" # yellow - location
#         "$(tput setaf 9)" # pink - location
#         "$(tput setaf 202)" # orange - versioning information
#         "$(tput setaf 256)" # white - connecting text
#         "$(tput setaf 124)" # red - error no.
#         " " # populated later?
#         " " #  populated later
#         " " #  populated later
#         "$(tput setaf 32)"
#       )
#     else
#       prompt_colors=(
#         "$(tput setaf 7)" # white - connecting text
#         "$(tput setaf 6)" # blue - user
#         "$(tput setaf 3)" # yellow - user
#         "$(tput setaf 5)" # purple - location
#         "$(tput setaf 6)" # red - version info
#         "$(tput setaf 7)" # white - connecting text
#         "$(tput setaf 6)" # red - error no.
#      )
#     fi
#     prompt_colors[8]=$(tput bold) #bold
#     prompt_colors[9]=$(tput sgr0) #reset
#   else
#     prompt_colors=(
#       "\033[1;31m"
#       "\033[1;33m"
#       "\033[1;32m"
#       "\033[1;35m"
#       "\033[1;37m"
#     )
#     prompt_colors[8]=""
#     prompt_colors[9]="\033[m"
#   fi
#
#   if [[ "$SSH_TTY" ]]; then
#     # connected via ssh
#     prompt_colors[0]="$(tput setaf 123)"
#   elif [[ "$USER" == "root" ]]; then
#     # logged in as root
#     prompt_colors[0]="$(tput setaf 97)"
#   fi
# fi

# Inside a prompt function, run this alias to setup local $c0-$c9 color vars.
# alias prompt_getcolors='prompt_colors[9]=; local i; for i in ${!prompt_colors[@]}; do local c$i="\[\e[0;${prompt_colors[$i]}m\]"; done; local cMagenta="$(tput setaf 172)";local cPink="$(tput setaf 9)"';
# alias prompt_getcolors='prompt_colors[11]=; local i; for i in ${!prompt_colors[@]}; do local c$i="\[${prompt_colors[$i]}\]"; done;'

segments=()
# addSegment text, color
function addSegment() {
  #local segment=($1,$2)
  local segment=(a b)
  segments=("${segments[@]}" "$segment")
}

function applySegments() {
  for i in "${segments[@]}"; do
    local segment="${segments[$i]}"
    echo $segment
    # PS1="$PS1$c9${prompt_colors["$1"]} $2  "
    # PS1="$PS1${segment[2]}${segment[1]}  "
  done
}

# Exit code of previous command.
function prompt_exitcode() {
  [[ $1 != 0 ]] && echo "$(bold)$(fg $color_error)$1$(cl)"
}

# Git status.
function prompt_git() {
#  local status output flags
#  status="$(git status 2>/dev/null)"
#  [[ $? != 0 ]] && return;
#  output="$(echo "$status" | awk '/# Initial commit/ {print "(init)"}')"
#  [[ "$output" ]] || output="$(echo "$status" | awk '/# On branch/ {print $4}')"
#  [[ "$output" ]] || output="$(git branch | perl -ne '/^\* (.*)/ && print $1')"
#  flags="$(
#    echo "$status" | awk 'BEGIN {r=""} \
#      /^# Changes to be committed:$/        {r=r "+"}\
#      /^# Changes not staged for commit:$/  {r=r "!"}\
#      /^# Untracked files:$/                {r=r "?"}\
#      END {print r}'
#  )"
#  output="$(fg $color_vcs1)$output"
#  if [[ "$flags" ]]; then
#    output="$output$(fg $color_light):$(fg $color_vcs2)$flags"
#  else
#    output="$output and $flags"
#  fi
#  echo "$(fg $color_folderBG)$(bg $color_vcsBG)$(bold)$(fg $color_light) on $output $(cl)$(fg $color_vcsBG)$(cl)"
#

  local status output flags branch
  status="$(git status 2>/dev/null)"
  [[ $? != 0 ]] && return;
  output="$(echo "$status" | awk '/# Initial commit/ {print "(init)"}')"
  [[ "$output" ]] || output="$(echo "$status" | awk '/# On branch/ {print $4}')"
  [[ "$output" ]] || output="$(git branch | perl -ne '/^\* \(detached from (.*)\)$/ ? print "($1)" : /^\* (.*)/ && print $1')"
  flags="$(
    echo "$status" | awk 'BEGIN {r=""} \
        /^(# )?Changes to be committed:$/        {r=r " 💾"}\
        /^(# )?Changes not staged for commit:$/  {r=r " ✏️"}\
        /^(# )?Untracked files:$/                {r=r " 🔍"}\
      END {print r}'
  )"
  if [[ "$flags" ]]; then
    output="$output$(fg $color_light)$(fg $color_vcs2)$(echo -e "$flags")"
  fi
  echo "$(fg $color_folderBG)$(bg $color_vcsBG)$(bold)$(fg $color_dark) on $(fg $color_light)$output $(cl)$(fg $color_vcsBG)$(cl)"
}

# SVN info.
function prompt_svn() {
  local info="$(svn info . 2> /dev/null)"
  local last current
  if [[ "$info" ]]; then
    last="$(echo "$info" | awk '/Last Changed Rev:/ {print $4}')"
    current="$(echo "$info" | awk '/Revision:/ {print $2}')"
    echo "$c8$c1[$c0$last$c1:$c0$current$c1]$c9"
  fi
}

# Maintain a per-execution call stack.
prompt_stack=()
trap 'prompt_stack=("${prompt_stack[@]}" "$BASH_COMMAND")' DEBUG

function prompt_command() {
  local exit_code=$?
  # If the first command in the stack is prompt_command, no command was run.
  # Set exit_code to 0 and reset the stack.
  [[ "${prompt_stack[0]}" == "prompt_command" ]] && exit_code=0
  prompt_stack=()

  # Manually load z here, after $? is checked, to keep $? from being clobbered.
  [[ "$(type -t _z)" ]] && _z --add "$(pwd -P 2>/dev/null)" 2>/dev/null

  # While the simple_prompt environment var is set, disable the awesome prompt.
  [[ "$simple_prompt" ]] && PS1='\n$ ' && return

  # default to nothing
  prompt_symbol=''

  #exit code
  if [[ "$exit_code" != 0 ]]; then
    PS1="$PS1$(cl)$(prompt_exitcode "$exit_code")"
    prompt_symbol="$(echo -e '\xf0\x9f\x92\xa5')"
  fi

  if [[ "$SSH_TTY" ]]; then
    # connected via ssh ⚡
    prompt_symbol="$(echo -e '\xe2\x9a\xa1')"
  fi

  # http://twitter.com/cowboy/status/150254030654939137
  PS1="\n"
  # date: HH:MM:SS
  PS1="$PS1$(cl)$(bg $color_timeBG)$(fg $color_light)$prompt_symbol  $(date +"%H$c1:$c0%M$c1:$c0%S") "

  PS1="$PS1$(fg $color_timeBG)$(bg $color_userBG)$(bg $color_userBG)$(fg $color_light) \u "

  # get original hostname or computer name
  if hash scutil 2>/dev/null; then
    computer_name=$(scutil --get ComputerName)
  else
    computer_name=$(cat /etc/hostname)
  fi
  # alert if it's different
  if [[ "$(hostname -s)" == "$computer_name" ]]; then
    computer_host="\h"
  else
    computer_host="\h ★ "
  fi
  PS1="$PS1$(fg $color_userBG)$(bg $color_hostBG)$(fg $color_dark) $computer_host "
  PS1="$PS1$(fg $color_hostBG)$(bg $color_folderBG)$(fg $color_dark) \w "


  # vcs
  local vcs_git vcs_svn
  vcs_svn="$(prompt_svn)"
  # git: [branch:flags]
  vcs_git="$(prompt_git)"

  ## terminate last segment if empty
  if [ -z "$vcs_git" ] && [ -z "$vcs_svn" ]; then
    PS1="$PS1$(cl)$(fg $color_folderBG)"
  else
    PS1="$PS1$vcs_git$vcs_svn"
  fi


  # Actual Prompt
  PS1="$PS1\n\[$(fg $color_prompt)\](ง ˙o˙)ง \[$(cl)\]"
}

PROMPT_COMMAND="prompt_command"
