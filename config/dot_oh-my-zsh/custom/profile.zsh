#==============================================================#
##                       NVM Setup                            ##
#==============================================================#

if [ -d "${HOME}/.nvm" ]; then
    export NVM_DIR="${HOME}/.nvm"
    if [ -s "${NVM_DIR}/nvm.sh" ]; then
        . "${NVM_DIR}/nvm.sh" --no-use
    fi
    if [ -s "${NVM_DIR}/bash_completion" ]; then
        . "${NVM_DIR}/bash_completion"  # This loads nvm bash_completion
    fi

    NODE_DEFAULT_PATH="${NVM_DIR}/versions/default/bin"
    export PATH="${NODE_DEFAULT_PATH}:${PATH}"

    _nvm_switch_node() {
        local NODE_PATH TARGET_NODE_VERSION
        if [ -f '.nvmrc' ]; then
            TARGET_NODE_VERSION="$(nvm version $(cat .nvmrc))"
            NODE_PATH="${NVM_DIR}/versions/node/${TARGET_NODE_VERSION}/bin"
        else
            TARGET_NODE_VERSION="$(nvm version default)"
            NODE_PATH="${NODE_DEFAULT_PATH}"
        fi
        if [ "${TARGET_NODE_VERSION}" != "$(nvm current)" ]; then
            export PATH="${NODE_PATH}:${PATH}"
        fi
    }
    _nvm_switch_node
    add-zsh-hook chpwd _nvm_switch_node
fi
