#!/bin/sh

mkdir $HOME/.config

# for neovim
ln -s $HOME/.dotfiles/nvim $HOME/.config/nvim

# for zshrc
sudo wget -O /etc/zsh/zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
wget -O $HOME/.zshrc https://git.grml.org/f/grml-etc-core/etc/skel/.zshrc
ln -sv $HOME/.dotfiles/zsh/.zshrc.pre $HOME/.zshrc.pre

# for tmux
mkdir $HOME/.config/tmux
ln -sv $HOME/.dotfiles/tmux/tmux.conf $HOME/.config/tmux/tmux.conf

# for git-cz
ln -sv $HOME/.dotfiles/git/.chanlog.config.js $HOME/.chanlog.config.js

# for lazygit
mkdir $HOME/.config/lazygit
ln -sv $HOME/.dotfiles/git/lazygit_config.yaml $HOME/.config/lazygit/config.yml
