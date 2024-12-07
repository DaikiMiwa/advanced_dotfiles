#!/bin/sh

# Install Homebrew if it's not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Make sure Homebrew is up-to-date
brew update

# Upgrade existing packages
brew upgrade

# Install Xcode Command Line Tools
xcode-select --install

# change shell from bash to zsh
brew install zsh
chsh -s /bin/zsh

# install zsh plugins (using a plugin manager like Oh My Zsh is recommended)
brew install zsh-completions
brew install zsh-autosuggestions

# install dependencies
brew install gcc nodejs npm
brew install ripgrep

# install lazy git
brew install lazygit

# install python through rye
brew install rye

# Make sure ~/.zfunc is added to fpath, before compinit.
rye self completion -s zsh > ~/.zfunc/_rye

# install neovim
brew install neovim

# install tmux
brew install tmux

# github cli
brew install gh

# ghq
brew install ghq

# git-cz
npm install -g git-cz
