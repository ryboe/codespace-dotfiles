#!/bin/zsh

set -euo pipefail

install_tools_alpine() {
    sudo apk add --update bat exa fd file fzf neovim ripgrep shfmt

    sudo wget --quiet --timeout=30 --output-document=/usr/local/bin/gitprompt https://github.com/ryboe/gitprompt/releases/latest/download/gitprompt-x86_64-unknown-linux-musl
    sudo chmod +x /usr/local/bin/gitprompt

    # Install fzf shell integration functions to /usr/share/fzf.
    sudo wget --quiet --timeout=30 --output-document=/usr/share/fzf/completion.zsh https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh
    sudo wget --quiet --timeout=30 --output-document=/usr/share/fzf/key-bindings.zsh https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh
}

install_tools_debian() {
    sudo apt install -y --no-install-recommends bat exa fd-find fzf neovim ripgrep golang-mvdan-sh
    sudo ln -s /usr/bin/batcat ~/usr/bin/bat
    sudo wget --quiet --timeout=30 --output-document=/usr/local/bin/gitprompt https://github.com/ryboe/gitprompt/releases/latest/download/gitprompt-x86_64-unknown-linux-gnu
    sudo chmod +x /usr/local/bin/gitprompt

    sudo wget --quiet --timeout=30 --output-document=/usr/share/fzf/completion.zsh https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh
    sudo wget --quiet --timeout=30 --output-document=/usr/share/fzf/key-bindings.zsh https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh
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
    script_dir=${0:a:h}

    rm -rf ~/.bashrc ~/.config ~/.oh-my-zsh ~/.zshrc
    mkdir -p ~/.config/git
    ln -s "$script_dir/.config/git/config" $HOME/.config/git/config
    ln -s "$script_dir/.config/git/ignore" $HOME/.config/git/ignore
    ln -s "$script_dir/.zshrc" $HOME/.zshrc
}

main() {
    install_tools

    create_symlinks
}

main
