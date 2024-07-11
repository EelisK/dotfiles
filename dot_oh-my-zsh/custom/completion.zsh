# shellcheck disable=SC1090,SC2148
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
