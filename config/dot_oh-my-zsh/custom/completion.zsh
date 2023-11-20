#==============================================================#
##          Completion                                        ##
#==============================================================#

command -v kubectl &> /dev/null && source <(kubectl completion zsh)
command -v kubectl &> /dev/null && compdef kubecolor=kubectl
command -v helm &> /dev/null && source <(helm completion zsh)
command -v kind &> /dev/null && source <(kind completion zsh)
command -v kubebuilder &> /dev/null && source <(kubebuilder completion zsh)
command -v chezmoi &> /dev/null && source <(chezmoi completion zsh)
command -v minikube &> /dev/null && source <(minikube completion zsh)

command -v rbenv &> /dev/null && eval "$(rbenv init - zsh)"
