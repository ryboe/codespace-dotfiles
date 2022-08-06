#!/bin/zsh

set -euo pipefail

install_tools() {
    sudo apk add --update bat exa fd file fzf neovim ripgrep shfmt

    sudo wget --quiet --timeout=30 --output-document=/usr/local/bin/gitprompt https://github.com/ryboe/gitprompt/releases/latest/download/gitprompt-x86_64-unknown-linux-musl
    sudo chmod +x /usr/local/bin/gitprompt

    # Install fzf shell integration functions to /usr/share/fzf.
    sudo wget --quiet --timeout=30 --output-document=/usr/share/fzf/completion.zsh https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh
    sudo wget --quiet --timeout=30 --output-document=/usr/share/fzf/key-bindings.zsh https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh
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
