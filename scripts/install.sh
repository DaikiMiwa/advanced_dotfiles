#!/bin/sh

chmod +x link.sh
./link.sh

# change shell from bash to zsh
sudo apt -y install zsh
chsh -s /bin/zsh

sudo apt install -y zsh-completions
sudo apt install -y zsh-autosuggestions

# install neovim dependencies
sudo apt -y install gcc ripgrep nodejs npm

# install lazy git
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# install python through rye
curl -sSf https://rye.astral.sh/get | bash

# Make sure ~/.zfunc is added to fpath, before compinit.
rye self completion -s zsh > ~/.zfunc/_rye	

# install neovim
sudo apt -y install neovim 

# install tmux
sudo apt -y install tmux

# github cli
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

# ghq
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install -y golang-go

go install github.com/x-motemen/ghq@latest

# git-cz
npm install -g git-cz

