#!/bin/sh

set -e

if ! builtin command -v chezmoi >/dev/null 2>&1
then
    bin_dir="${HOME}/.local/bin"
    if builtin command -v curl >/dev/null 2>&1
    then
        sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "${bin_dir}"
    elif builtin command -v wget >/dev/null 2>&1
    then
        sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "${bin_dir}"
    else
        echo "To install chezmoi, you must have curl or wget installed." >&2
        exit 1
    fi
fi
