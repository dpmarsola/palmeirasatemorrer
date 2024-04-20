#!/usr/bin/bash


sudo apt install python3-tk python3-dev

if [ $? -ne 0 ]
then
    echo "Failed to install python3-tk"
    exit 1
fi

sudo apt install python3-dev

if [ $? -ne 0 ]
then
    echo "Failed to install python3-dev"
    exit 1
fi

sudo snap install ngrok

if [ $? -ne 0 ]
then
    echo "Failed to install ngrok"
    exit 1
fi

mkdir ./logs ./sent ./tosend ./security ./stuck

pip install django

if [ $? -ne 0 ]
then
    echo "Failed to install django"
    exit 1
fi

pip install pywhatkit

if [ $? -ne 0 ]
then
    echo "Failed to install pywhatkit"
    exit 1
fi

ngrok config add-authtoken <check your ngrok account for the token>

if [ $? -ne 0 ]
then
    echo "Failed to add authtoken to ngrok"
    exit 1
fi


echo "email" >> ./security/credentials
echo "password" >> ./security/credentials


sudo cp cfg/palmeirasatemorrer.service /etc/systemd/system/palmeirasatemorrer.service
sudo systemctl enable palmeirasatemorrer.service
sudo systemctl start palmeirasatemorrer.service

#todo list
# make tigerVNC server run at startup
# make the app run at startup
# handle the international carachters in whatsapp message
# acess VNC server from the internet
