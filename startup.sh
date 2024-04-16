#!/usr/bin/bash

cd ~/palmeirasatemorrer

echo $(date) ">>>>>>>>>> Starting a new Instance <<<<<<<<<<" > ./logs/startup.log

echo $(date) ">>>> Setting up the timezone" >> ./logs/startup.log
sudo timedatectl set-timezone America/Sao_Paulo

display_num=$(ps -ef | grep tigervnc | grep -v grep |  cut -c'53-75' | cut -d':' -f2 | cut -d' ' -f1)

if [ -z "$display_num" ]
then
    echo $(date) ">>>> Starting VNC server" >> ./logs/startup.log
    vncserver -localhost
    display_num=$(ps -ef | grep tigervnc | grep -v grep |  cut -c'53-75' | cut -d':' -f2 | cut -d' ' -f1)
    echo $(date) ">>>> VNC server started on display $display_num" >> ./logs/startup.log
else
    echo $(date) ">>>> VNC server already running on display $display_num" >> ./logs/startup.log
fi

DISPLAY=":$display_num"
export DISPLAY

echo $(date) ">>>> Starting up all processes" >> ./logs/startup.log

nohup python3 manage.py runserver 8040 > ./logs/djangoserver.log 2>&1 & >> ./logs/startup.log 2>&1
sleep 3
nohup ngrok http --domain=rare-exact-squirrel.ngrok-free.app 8040 > ./logs/ngrok.log 2>&1 & >> ./logs/startup.log 2>&1
sleep 3
nohup ./jobSendMessage.sh > ./logs/jobSendMessage.log 2>&1 & >> ./logs/startup.log 2>&1

echo $(date) ">>>>>>>>>> All proccess were started <<<<<<<<<<" >> ./logs/startup.log
