#!/usr/bin/bash

echo "====== Create Swapfile and Partition ======"
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile 
sudo stat /swapfile 
sudo mkswap /swapfile 
sudo swapon /swapfile
sudo echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo "====== Setting packages for download ======"
echo "
deb [arch=arm64] http://ports.ubuntu.com/ <<version_codename>> main multiverse universe
deb [arch=arm64] http://ports.ubuntu.com/ <<version_codename>>-security main multiverse universe
deb [arch=arm64] http://ports.ubuntu.com/ <<version_codename>>-backports main multiverse universe
deb [arch=arm64] http://ports.ubuntu.com/ <<version_codename>>-updates main multiverse universe
" > tmp

codename=$(cat /etc/os-release | grep VERSION_CODENAME | cut -d'=' -f2)
sed -i 's/<<version_codename>>/'${codename}'/g' tmp

sudo mv tmp /etc/apt/sources.list.d/my_list.list

echo "====== Creating directories ==============="
mkdir ./logs ./sent ./tosend ./security ./stuck

echo "====== Installing Python and Its Apps ====="
sudo apt install python3-tk -y

if [ $? -ne 0 ]
then
    echo "Failed to install python3-tk"
    exit 1
fi

sudo apt install python3-dev -y

if [ $? -ne 0 ]
then
    echo "Failed to install python3-dev"
    exit 1
fi

sudo apt install python3-pip -y

if [ $? -ne 0 ]
then
    echo "Failed to install python3-pip"
    exit 1
fi

pip install django --break-system-packages

if [ $? -ne 0 ]
then
    echo "Failed to install django"
    exit 1
fi

pip install pywhatkit --break-system-packages

if [ $? -ne 0 ]
then
    echo "Failed to install pywhatkit"
    exit 1
fi

echo "====== Installing NGROK Agent ============="
sudo snap install ngrok 

if [ $? -ne 0 ]
then
    echo "Failed to install ngrok"
    exit 1
fi

echo "Please enter your NGROK token here <check your ngrok account for the token>: "
read token

if [ ! -z $token ]
then
    ngrok config add-authtoken $token
    if [ $? -ne 0 ]
    then
        echo "Failed to add authtoken to ngrok"
        exit 1
    fi
fi

echo "====== Setting BREVO credentials =========="
echo "Please enter your email and password for access BREVO service: "
read -p "EMAIL: " email
read -s -p "PASSWORD: " password

if [ ! -z $email ] && [ ! -z $password ]
then
    echo $email > ./security/credentials
    echo $password > ./security/credentials
    echo -e "\n"
fi

echo "====== Installing X11 and Its Stuff ======="
sudo apt install xorg openbox -y
sudo chown ubuntu:ubuntu ~/.Xauthority
sudo chmod 775 ~/.Xauthority

if [ $? -ne 0 ]
then
    echo "Failed to install x11 and openbox"
    exit 1
fi

echo "====== Installing XFCE ===================="
sudo apt install xfce4-session xfce4-goodies -y

if [ $? -ne 0 ]
then
    echo "Failed to install xfce"
    exit 1
fi

echo "====== Installing VNC Server =============="
sudo apt install tigervnc-standalone-server -y
sudo apt install dbus-x11

if [ $? -ne 0 ]
then
    echo "Failed to install xfce"
    exit 1
else 
    mkdir ~/.vnc
    echo "startxfce4" > ~/.vnc/xstartup
    chmod a+x ~/.vnc/xstartup
    sudo cp /etc/tigervnc/vncserver.users tmp \
         && sudo chown ubuntu:ubuntu tmp \
         && echo ":1=ubuntu" >> tmp \
         && sudo chown root:root tmp \
         && sudo mv tmp /etc/tigervnc/vncserver.users
    sudo cp /lib/systemd/system/tigervncserver@.service /etc/systemd/system/
    echo "Please provide a password to access the VNC Server: "
    vncpasswd 
    sudo systemctl enable tigervncserver@:1
    sudo systemctl start tigervncserver@:1
fi

echo "====== Set Service to Run at Startup ======"
sudo cp ./cfg/palmeiras.service /etc/systemd/system
sudo chmod 644 /etc/systemd/system/palmeiras.service
sudo systemctl enable palmeiras.service
sudo systemctl daemon-reload

echo "====== Installing Chrome Browser =========="
sudo apt install chromium-browser

echo "====== Finalizing Installation ============"
exit 0

#todo list
# make tigerVNC server run at startup
# make the app run at startup
# handle the international carachters in whatsapp message
# acess VNC server from the internet
