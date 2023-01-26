#!/bin/zsh

set -euo pipefail

install_tools_alpine() {
    sudo apk add --update bat exa fd file fzf neovim ripgrep shfmt

    sudo wget --quiet --timeout=30 --output-document=/usr/local/bin/gitprompt https://github.com/ryboe/gitprompt/releases/latest/download/gitprompt-x86_64-unknown-linux-musl
    sudo chmod +x /usr/local/bin/gitprompt

    # Install fzf completions manually, because apk doesn't do that for us.
    sudo wget --quiet --timeout=30 --output-document=/usr/share/fzf/completion.zsh https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh
    sudo wget --quiet --timeout=30 --output-document=/usr/share/fzf/key-bindings.zsh https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh
}

install_tools_debian() {
    # apt will try to install completions to this dir, but it won't create the
    # directory for some reason.
    sudo mkdir -p /usr/share/fzf

    sudo apt update
    # shfmt is not available on apt yet. The shfmt package is named
    # golang-mvdan-sh, but it's only in testing. See this URL for status
    # updates:
    #   https://tracker.debian.org/pkg/golang-mvdan-sh
    sudo apt install -y --no-install-recommends bat exa fd-find fzf neovim ripgrep
    mkdir -p $HOME/.local/bin
    wget --quiet --timeout=30 --output-document=$HOME/.local/bin/gitprompt https://github.com/ryboe/gitprompt/releases/latest/download/gitprompt-x86_64-unknown-linux-gnu
    chmod +x $HOME/.local/bin/gitprompt
    # bat and fd have stupid names on Debian of naming conflicts with
    # preexisting packages, so give them a proper name.
    ln -s /usr/bin/batcat $HOME/.local/bin/bat
    ln -s /usr/bin/fdfind $HOME/.local/bin/fd
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

create_symlinks() {
    # Delete any existing configs.
    rm -rf ~/.bash_logout ~/.bashrc ~/.config ~/.oh-my-zsh ~/.profile ~/.zshrc
    mkdir -p ~/.config/git

    script_dir=${0:a:h}
    ln -s "$script_dir/.config/git/config" $HOME/.config/git/config
    ln -s "$script_dir/.config/git/ignore" $HOME/.config/git/ignore
    ln -s "$script_dir/.zshrc" $HOME/.zshrc
}

main() {
    install_tools

    create_symlinks
}

main
