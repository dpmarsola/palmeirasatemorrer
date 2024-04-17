#!/usr/bin/bash

mkdir ./logs ./sent ./tosend ./security ./stuck

pip install pywhatkit django

sudo apt install python3-tk python3-dev
sudo snap install ngrok
ngrok config add-authtoken <check your ngrok account for the token>

echo "email" >> ./security/credentials
echo "password" >> ./security/credentials

#todo list
# make tigerVNC server run at startup
# make the app run at startup
# handle the international carachters in whatsapp message
# acess VNC server from the internet
