#!/bin/sh

# change shell from bash to zsh
sudo apt install zsh
chsh -s /bin/zsh

# install neovim dependencies
sudo apt install gcc ripgrep nodejs

# install lazy git
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# install python through rye
curl -sSf https://rye.astral.sh/get | bash
echo 'source "$HOME/.rye/env"' >> ~/.zshrc
source ~/.zshrc

# Make sure ~/.zfunc is added to fpath, before compinit.
rye self completion -s zsh > ~/.zfunc/_rye	

# install neovim using snap
sudo apt install neovim 

# install tmux using snap
sudo apt install tmux
