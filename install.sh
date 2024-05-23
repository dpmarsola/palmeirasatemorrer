#!/usr/bin/bash

codename=$(cat /etc/os-release | grep VERSION_CODENAME | cut -d'=' -f2)

echo "====== Setting packages for download ======"
echo "
deb [arch=arm64] http://ports.ubuntu.com/ <<version_codename>> main multiverse universe
deb [arch=arm64] http://ports.ubuntu.com/ <<version_codename>>-security main multiverse universe
deb [arch=arm64] http://ports.ubuntu.com/ <<version_codename>>-backports main multiverse universe
deb [arch=arm64] http://ports.ubuntu.com/ <<version_codename>>-updates main multiverse universe
" > tmp

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
else
    echo "No token was provided."
    exit 1
fi

echo "====== Setting BREVO credentials =========="
echo "Please enter your email and password for access BREVO service: "
read -p "EMAIL: " email
read -s -p "PASSWORD: " password
echo $email >> ./security/credentials
echo $password >> ./security/credentials

echo "====== Installing X11 and Its Stuff ======="
sudo apt-get install xorg openbox -y

if [ $? -ne 0 ]
then
    echo "Failed to install x11 and openbox"
    exit 1
fi

echo "====== Installing XFCE ===================="
sudo apt-get install xfce4-session xfce4-goodies -y

if [ $? -ne 0 ]
then
    echo "Failed to install xfce"
    exit 1
fi

echo "====== Set Service to Run at Startup ======"
sudo cp ./cfg/palmeiras.service /etc/systemd/system
sudo chmod 644 /etc/systemd/system/palmeiras.service
sudo systemctl enable palmeiras.service
sudo systemctl daemon-reload

echo "====== Finalizing Installation ============"
read -p "System need to reebot. Want to reboot it now (Y/N)?" $reboot

if [ "$reboot" = "Y" ]
then
    sudo shutdown -r now
else
    exit 0
fi

#todo list
# make tigerVNC server run at startup
# make the app run at startup
# handle the international carachters in whatsapp message
# acess VNC server from the internet
