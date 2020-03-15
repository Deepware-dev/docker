#!/bin/sh

# see instruction in https://docs.docker.com/install/linux/docker-ce/ubuntu/

sudo apt-get update

# Setup Docker repository
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

# install docker engine
sudo apt-get install docker-ce docker-ce-cli containerd.io

# Install NVIDIA docker. See instruction on https://github.com/NVIDIA/nvidia-docker#quick-start

# Add NVIDIA package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker

# instruction in https://docs.docker.com/install/linux/linux-postinstall/

# Create the docker group
sudo groupadd docker

# Add your user to the docker group
sudo usermod -aG docker $USER

# To activate the changes to groups
newgrp docker 

sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R