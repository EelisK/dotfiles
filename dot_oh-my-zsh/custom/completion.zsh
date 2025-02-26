# shellcheck disable=SC1090,SC2148,SC2128,SC2283,SC2296
#==============================================================#
##          Completion                                        ##
#==============================================================#

command -v kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)
command -v kubectl >/dev/null 2>&1 && compdef kubecolor=kubectl
command -v helm >/dev/null 2>&1 && source <(helm completion zsh)
command -v kind >/dev/null 2>&1 && source <(kind completion zsh)
command -v kubebuilder >/dev/null 2>&1 && source <(kubebuilder completion zsh)
command -v operator-sdk >/dev/null 2>&1 && source <(operator-sdk completion zsh)
command -v chezmoi >/dev/null 2>&1 && source <(chezmoi completion zsh)
command -v minikube >/dev/null 2>&1 && source <(minikube completion zsh)
command -v stern >/dev/null 2>&1 && source <(stern --completion zsh)

#==============================================================#
##          Custom completion                                 ##
#==============================================================#

_work() {
    _arguments \
        '1:Repository:_path_files -W ${WORKSPACE_DIR} -/'
}

compdef _work work

_dotfiles() {
    _arguments \
        '1:(optional) File to edit:_path_files -W "$(chezmoi source-path)"'
}

compdef _dotfiles dotfiles

# zsh parameter completion for the dotnet CLI

_dotnet_zsh_complete()
{
    local completions=("$(dotnet complete "$words")")

    # If the completion list is empty, just continue with filename selection
    if [ -z "$completions" ]
    then
        _arguments '*::arguments: _normal'
        return
    fi

    # This is not a variable assignment, don't remove spaces!
    _values = "${(ps:\n:)completions}"
}

compdef _dotnet_zsh_complete dotnet
