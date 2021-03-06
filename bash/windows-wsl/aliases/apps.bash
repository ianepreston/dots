# Aliases for linux apps, redirecting to windows versions

if [[ -e "$SCOOP/shims/gvim.exe" ]]; then
  alias gvim="$SCOOP/shims/gvim.exe"
fi

alias docker="docker.exe"
alias docker-compose="docker-compose.exe"
alias docker-machine="docker-machine.exe"
alias kubectl="kubectl.exe"
alias notary="notary.exe"

if [[ -e "$SCOOP/shims/packer.exe" ]]; then
  alias packer="$SCOOP/shims/packer.exe"
fi
alias vagrant="vagrant.exe"
