#!/bin/bash
USER=training
HOME=/home/$USER
DOCKER_COMPOSE_VERSION=1.27.4
PYTHON_VERSION=3.8
if [ `whoami` == $USER ]
then
        echo "$USER:$USER" | sudo chpasswd
fi
LN=`sudo sed -n '/%sudo/=' /etc/sudoers`
sudo sed -i "${LN}s/ ALL/ NOPASSWD:ALL/g" /etc/sudoers
if [ `whoami` != $USER ]
then 
        if `sudo useradd -d /home/$USER -m -s /bin/bash -p $(echo "${USER}" | openssl passwd -1 -stdin) $USER`; then
        echo "User ${USER} added and password set"
        else
        echo "$USER:$USER" | sudo chpasswd
        echo "Password changed for user ${USER}"
        fi
        sudo usermod -aG sudo $USER
        sudo su - $USER
fi
sudo systemctl stop apparmor
sudo systemctl disable apparmor
sudo ufw disable
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt install vim -y
sudo apt install git -y
sudo apt install unzip -y
sudo apt install wget -y
sudo apt install net-tools -y
sudo apt install curl -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update -y
sudo apt install docker-ce -y
sudo systemctl enable docker
sudo usermod -aG docker $USER
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo apt install software-properties-common -y
sudo apt install python3-pip -y
cd /tmp
su $USER <<'EOF'
USER=training
HOME=/home/$USER
ANACONDA_INSTALL_SCRIPT=Anaconda3-2020.07-Linux-x86_64.sh
ANACONDA_URL=https://repo.anaconda.com/archive/$ANACONDA_INSTALL_SCRIPT
curl -O $ANACONDA_URL
bash $ANACONDA_INSTALL_SCRIPT -b -p $HOME/anaconda
sudo rm -f $ANACONDA_INSTALL_SCRIPT
eval "$($HOME/anaconda/bin/conda shell.bash hook)"
conda init
conda update conda -y
conda update anaconda -y
python3 -m pip install jupyter-repo2docker
export PATH=$PATH:$HOME/.local/bin
mkdir -p $HOME/repositories
EOF
python3 -m pip install jupyter-repo2docker
su -c "cd $HOME && $HOME/anaconda/bin/conda install -c conda-forge ruamel.yaml -y" $USER
sudo apt install default-jdk -y
echo 'echo "$USER:$USER" | sudo chpasswd' > $HOME/.reset_password
chmod +x $HOME/.reset_password
echo 'alias jshell="jshell --start PRINTING"' >> $HOME/.bashrc
source $HOME/.bashrc
cd /tmp
su -c "cd $HOME && $HOME/anaconda/bin/conda config --add channels conda-forge && $HOME/anaconda/bin/conda create --name scijava scijava-jupyter-kernel -y" $USER
su -c "cd $HOME && eval \"$($HOME/anaconda/bin/conda shell.bash hook)\" && conda activate scijava; conda install -c anaconda jupyter -y" $USER
su $USER <<'EOF'
USER=training
HOME=/home/$USER
IJAVA_VERSION=1.3.0
cd $HOME 
$HOME/anaconda/bin/conda env remove -y -n java11 || rm -rf $HOME/anaconda3/envs/java11 || true
$HOME/anaconda/bin/conda create -n java11 openjdk=11 jupyter jupyterlab -y
eval "$($HOME/anaconda/bin/conda shell.bash hook)" 
conda activate java11
cd /tmp
wget -O ijava-${IJAVA_VERSION}.zip https://github.com/SpencerPark/IJava/releases/download/v${IJAVA_VERSION}/ijava-${IJAVA_VERSION}.zip
unzip -o ./ijava-${IJAVA_VERSION}.zip
python3 install.py --sys-prefix
$HOME/anaconda/bin/conda config --add channels bioconda
$HOME/anaconda/bin/conda create -n bio biopython python=3.8 pandas matplotlib statsmodels scikit-learn -y
$HOME/anaconda/bin/conda install -c conda-forge conda-pack
jupyter notebook --generate-config
echo "c.NotebookApp.password = u'argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$KBLVkhXy9jv0QU91rvPDHg\$qXEdPRvZMIwpEdxWRHwnrg'" >> $HOME/.jupyter/jupyter_notebook_config.py
EOF
exit 0
