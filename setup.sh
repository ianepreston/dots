#!/usr/bin/env bash
# Bash "strict" mode
set -euo pipefail
IFS=$'\n\t'

# initialize-settings.sh - Script to set up a new machine with my dotfiles.

DOTFILES="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Bring in helper functions to colour text and check for program existence
source "$DOTFILES/bash/base-colours.bash"
source "$DOTFILES/bash/base-functions.bash"

# From base-functions. Set environment variables for OS. e.g. primary OS = Linux, secondary = Arch
SetOsEnvironmentVariables

echo ""
echo -e "${color_green}Starting setup...${color_normal}"
echo ""

# We need RCM for obvious reasons. Curl is used to pull in user installs for plugins etc.
if ! command_exists rcup; then
  echo -e "${color_red}RCM is not installed.  Please install it and try again.${color_normal}"
  exit 1
fi

if ! command_exists curl; then
  echo -e "${color_red}Curl is not installed.  Please install it and try again.${color_normal}"
  exit 1
fi

# If there's already an rcrc for this host in either repository then link it in
# This file has to be in place before we can load the rest of the setup in order to
# apply the correct tags and look in the correct places for dotfiles
rcup -f -K -d "$HOME/.dotfiles/rcs" -d "$HOME/.private_dotfiles/rcs" rcrc

if [[ -f "$HOME/.rcrc" ]]; then
  echo -e "${color_yellow}Home .rcrc is in place.${color_normal}"
  echo ""
else
  echo -e "${color_white}Creating new ~/.rcrc file.${color_normal}"
  echo ""
  cp "$DOTFILES/base-rcrc" "$HOME/.rcrc"

  if [[ $OS_PRIMARY == "linux" ]]; then
    echo "TAGS=\"$OS_PRIMARY $OS_SECONDARY home\"" >>"$HOME/.rcrc"
  else
    echo "TAGS=\"$OS_PRIMARY home\"" >>"$HOME/.rcrc"
  fi

  echo -e "${color_yellow}~/.rcrc file created.  You will need to add it with mkrc -o ~/.rcrc${color_normal}"
fi

echo -e "${color_green}Done!  Edit the ~/.rcrc as needed then run 'rcup'${color_normal}"
echo ""

unset DOTFILES
