#!/usr/bin/env bash

# Turn on colors
alias ls='ls $LS_OPTIONS'
alias lss='ls -1'
alias dir='ls -CA'
alias vdir='ls -lA'
alias tree="tree -C"

alias grep="grep --color"
alias pgrep="grep --color"
alias egrep="grep --color"

# Make sudo preserve home
alias sudo="sudo -H"
alias se="sudoedit"

# Directory & file
alias mkdir="mkdir -p"

# Default to human readable figures
alias vi="vim"
alias df='df -h'
alias du='du -h'

# DOS like clear
alias cls="clear"

# Editor mappings
alias e='"$EDITOR"'
alias edit='"$EDITOR"'
alias ge='"$VISUAL"'
alias vis='"$VISUAL"'
alias v="vim -R"
alias view="vim -R"

# Vim typos
alias :q="exit"
alias :wq="exit"
alias :x="exit"

# History
alias histg='history | grep'
alias hist='history | ag'

# Utility commands
alias mkdatedir='mkdir $(date "+%Y-%m-%d")'
alias mkdatefile='touch $(date "+%Y-%m-%d").txt'

# RipGrep should always use "smart-case"
if command_exists rg; then
  alias rg='rg -S'
fi

# vless
# shellcheck disable=SC2139
alias vless="/usr/share/vim/vim$VIM_VER/macros/less.sh"

if command_exists thefuck; then
  eval "$(thefuck --alias)"
fi
