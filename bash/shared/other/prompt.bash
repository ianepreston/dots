#!/usr/bin/env bash

# Show a max of 4 levels of directory then truncate
export PROMPT_DIRTRIM=4

# Default to not using git, detect if we can use it below
GIT_PS1_USEGIT=0

# Three possible places for git prompt, as long as we have it in one
# we're good.
if [[ -e /usr/lib/git/git-core/git-sh-prompt ]]; then
  source '/usr/lib/git/git-core/git-sh-prompt'
  GIT_PS1_USEGIT=1
fi

if [[ -e /usr/lib/git-core/git-sh-prompt ]]; then
  source '/usr/lib/git-core/git-sh-prompt'
  GIT_PS1_USEGIT=1
fi

if [[ -e /usr/share/git/git-prompt.sh ]]; then
  source '/usr/share/git/git-prompt.sh'
  GIT_PS1_USEGIT=1
fi

if [[ $GIT_PS1_USEGIT -eq 1 ]]; then
  # Show modified files with *, staged with +
  GIT_PS1_SHOWDIRTYSTATE=1
  # Show stashed files with $
  GIT_PS1_SHOWSTASHSTATE=1
  # Show untracked files with %
  GIT_PS1_SHOWUNTRACKEDFILES=1
  # Compare local vs upstream.
  # e.g. if local is ahead of upstream by one
  # commit show u+1
  GIT_PS1_SHOWUPSTREAM="verbose git"
  # add colours to status page. e.g. modified files are red
  GIT_PS1_SHOWCOLORHINTS=1
fi

function custom_prompt() {
  # indicate exit status of last command
  # either a green check for success
  # or red x and the exit code for failure
  local last_exit=$?
  if [[ $last_exit -eq 0 ]]; then
    # shellcheck disable=SC2154
    local exit_status="${color_green}[${i_fa_check}]"
  else
    # shellcheck disable=SC2154
    local exit_status="${color_red}[${i_fa_close} (\$?)]"
  fi
  # Figure out and display which python is currently active
  local whichpy=$(which python)
  if [[ $whichpy == *"miniconda"* ]];
  then
      local pypart="${color_white}[conda: $CONDA_DEFAULT_ENV]"
  elif [[ $whichpy == *"pyenv"* ]];
  then
      local whichshim=$(pyenv version | awk '{print $1}')
      if [[ $whichshim == "system" ]];
      then
          local pypart="${color_white}[system python]"
      else
          local pypart="${color_white}[pyenv: $whichshim]"
      fi
  elif [[ "$VIRTUAL_ENV" != "" ]];
  then
    # poetry_env=$(echo $whichpy | sed 's/.*pypoetry\/virtualenvs\/\(.*\)\/bin.*/\1/')
    local pypart="${color_white}[ $VIRTUAL_ENV ]"
  elif [[ $whichpy == "/usr/bin/"* ]];
  then
      local pypart="${color_white}[system python]"
  else
      local pypart="${color_white}[unknown python]"
  fi
  # Indicate if we're accessing the machine via SSH
  local ssh_text=""
  if [[ -n $SSH_CLIENT ]]; then
    # shellcheck disable=SC2154
    local ssh_text="${color_cyan}[SSH]${color_normal}-"
  fi


  # shellcheck disable=SC2154
  # Indicate what kind of shell we're in
  local curShell="${color_blue}["
  if [[ $IS_WSL == "true" ]]; then
    curShell+="WSL "
  fi
  if [[ "$0" == "-bash" ]] || [[ "$0" == "/bin/bash" ]]; then
    curShell+="bash]"
  else
    curShell+="$0]"
  fi

  # Actually build the prompt
  if [[ $GIT_PS1_USEGIT -eq 1 ]]; then
    local git_part
    # shellcheck disable=SC2154
    git_part=$(__git_ps1 "${color_yellow}[%s]${color_normal}-")
    export PS1
    # shellcheck disable=SC2154
    PS1="${color_normal}\n┌─${pypart}-${ssh_text}${color_green}[\u@\h]${color_normal}-${color_purple}[\w]${color_normal}-${git_part}${curShell}${color_normal}-${exit_status}${color_normal} \n└─>\$ "
  else
    PS1="${color_normal}\n┌─${pypart}-${ssh_text}${color_green}[\u@\h]${color_normal}-${color_purple}[\w]${color_normal}-${curShell}${color_normal}-${exit_status}${color_normal} \n└─>\$ "
  fi
}

PROMPT_COMMAND=custom_prompt
