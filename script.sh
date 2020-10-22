#!/bin/bash
USER=training
DOCKER_COMPOSE_VERSION=1.27.4
PYTHON_VERSION=3.8
ANACONDA_INSTALL_SCRIPT=Anaconda3-2020.07-Linux-x86_64.sh
ANACONDA_URL=https://repo.anaconda.com/archive/$ANACONDA_INSTALL_SCRIPT
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
sudo useradd -d /home/$USER -m -s /bin/bash -p $(echo "${USER}" | openssl passwd -1 -stdin) $USER
sudo usermod -aG sudo $USER
sudo usermod -aG docker $USER
LN=`sed -n '/%sudo/=' /etc/sudoers
sudo sed -i "${LN}s/ ALL/ NOPASSWD:ALL/g" /etc/sudoers
sudo apt install curl -y
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo apt install software-properties-common -y
sudo su - $USER
cd /tmp
curl -O $ANACONDA_URL
bash $ANACONDA_INSTALL_SCRIPT -b -p $HOME/anaconda
sudo rm -f $ANACONDA_INSTALL_SCRIPT
sudo ln -sfn /usr/bin/python3.6 /usr/bin/python3
eval "$($HOME/anaconda/bin/conda shell.bash hook)"
conda init
conda update conda -y
conda update anaconda -y
python3 -m pip install jupyter-repo2docker
mkdir -p $HOME/repositories
exit 0

