#!/bin/bash
DOCKER_COMPOSE_VERSION=1.27.4
PYTHON_VERSION=3.8
sudo systemctl stop apparmor
sudo systemctl disable apparmor
sudo ufw disable
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt install git -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update -y
sudo apt install docker-ce -y
sudo systemctl enable docker
sudo useradd -d /home/training -m -s /bin/bash -p $(echo "training" | openssl passwd -1 -stdin) training
sudo usermod -aG sudo training
sudo usermod -aG docker training
LN=`sed -n '/%sudo/=' /etc/sudoers
sudo sed -i "${LN}s/ ALL/ NOPASSWD:ALL/g" /etc/sudoers
sudo apt install curl -y
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install python${PYTHON_VERSION} -y
sudo ln -sfn /usr/bin/python${PYTHON_VERSION} /usr/bin/python3
sudo apt install --reinstall python3-apt -y



exit 0

