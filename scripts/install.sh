#!/bin/sh

chmod +x link.sh
./link.sh

sudo apt update -y
sudo apt upgrade -y

# change shell from bash to zsh
sudo apt -y install zsh
sudo chsh -s /bin/zsh

sudo apt install -y zsh-completions
sudo apt install -y zsh-autosuggestions

# install dependencies
sudo apt -y install gcc nodejs npm
sudo apt -y install ripgrep

# install lazy git
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# install python through rye
RYE_INSTALL_OPTION=--yes
curl -sSf https://rye.astral.sh/get | bash

# Make sure ~/.zfunc is added to fpath, before compinit.
rye self completion -s zsh >~/.zfunc/_rye

# install neovim
mkdir -p $HOME/.local/bin
wget https://github.com/neovim/neovim/releases/download/v0.10.2/nvim.appimage -P $HOME/.local/bin
mv $HOME/.local/bin/nvim.appimage $HOME/.local/bin/nvim
chmod +x $HOME/.local/bin/nvim

# install tmux
sudo apt -y install tmux

# github cli
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) &&
	sudo mkdir -p -m 755 /etc/apt/keyrings &&
	wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
	sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
	sudo apt update &&
	sudo apt install gh -y

# ghq
sudo add-apt-repository -y ppa:longsleep/golang-backports
sudo apt update -y
sudo apt install -y golang-go

go install github.com/x-motemen/ghq@latest

# git-cz
npm install -g git-cz

# install terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg |
	gpg --dearmor |
	sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
gpg --no-default-keyring \
	--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
	--fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" |
	sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt install terraform

# install aws cli
sudo snap install aws-cli --classic

# install session manager plugin
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
