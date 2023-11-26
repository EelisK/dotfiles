#==============================================================#
##          Completion                                        ##
#==============================================================#

command -v kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)
command -v kubectl >/dev/null 2>&1 && compdef kubecolor=kubectl
command -v helm >/dev/null 2>&1 && source <(helm completion zsh)
command -v kind >/dev/null 2>&1 && source <(kind completion zsh)
command -v kubebuilder >/dev/null 2>&1 && source <(kubebuilder completion zsh)
command -v chezmoi >/dev/null 2>&1 && source <(chezmoi completion zsh)
command -v minikube >/dev/null 2>&1 && source <(minikube completion zsh)
command -v stern >/dev/null 2>&1 && source <(stern --completion zsh)
command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init - zsh)"
