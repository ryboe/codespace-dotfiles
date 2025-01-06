#!/bin/zsh

set -euo pipefail

install_tools_alpine() {
    sudo apk add --update bat exa fd file fzf neovim ripgrep shfmt

    # Install fzf completions manually, because apk doesn't do that for us. Note
    # that this is installing the latest completions, which won't match the old
    # version of fzf available on apk. Unfortunately, there's no reliable way to
    # get the fzf version, because the output of `fzf --version` doesn't always
    # match the git tags on the github.com/junegunn/fzf repo.
    sudo wget --quiet --timeout=30 --output-document=/usr/share/fzf/completion.zsh https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh
}

install_tools_debian() {
    sudo apt update
    # shfmt is not available on apt yet. The shfmt package is named
    # golang-mvdan-sh, but it's only in testing. See this URL for status
    # updates:
    #   https://tracker.debian.org/pkg/golang-mvdan-sh
    sudo apt install -y --no-install-recommends bat exa fd-find fzf neovim ripgrep

    # bat and fd have stupid names on Debian of naming conflicts with
    # preexisting packages, so give them a proper name.
    mkdir -p $HOME/.local/bin
    ln -s /usr/bin/batcat $HOME/.local/bin/bat
    ln -s /usr/bin/fdfind $HOME/.local/bin/fd

    # apt installs the fzf completions and key-bindings to a weird directory, so
    # let's move them to the directory that alpine uses.
    sudo mkdir -p /usr/share/fzf
    sudo cp /usr/share/doc/fzf/examples/completion.zsh /usr/share/fzf/completion.zsh
    sudo cp /usr/share/doc/fzf/examples/key-bindings.zsh /usr/share/fzf/key-bindings.zsh
}

install_tools() {
    if [[ -f /etc/alpine-release ]]; then
        install_tools_alpine
    elif [[ $(command -v lsb_release) && $(lsb_release --id --short) == Debian ]]; then
        install_tools_debian
    else
        echo 'ERROR: unknown linux distribution'
        echo 'skipping installation of command line tools'
    fi
}

install_configs() {
    # Delete any existing configs.
    rm -rf ~/.bash_logout ~/.bashrc ~/.config/git ~/.oh-my-zsh ~/.profile ~/.zshrc
    mkdir -p ~/.config/git

    mkdir -p $HOME/.config/git
    script_dir=${0:a:h}
    mv "$script_dir/.config/git/config" $HOME/.config/git/config
    mv "$script_dir/.config/git/ignore" $HOME/.config/git/ignore
    mv "$script_dir/.zshrc" $HOME/.zshrc
}

main() {
    install_tools

    install_configs
}

main
