#!/usr/bin/bash

cd ~/palmeirasatemorrer

echo $(date) ">>>> Starting up all processes" >> ./logs/startup.log

nohup python3 manage.py runserver 8040 > ./logs/djangoserver.log 2>&1 & >> ./logs/startup.log 2>&1
sleep 3
nohup ngrok http --domain=rare-exact-squirrel.ngrok-free.app 8040 > ./logs/ngrok.log 2>&1 & >> ./logs/startup.log 2>&1
sleep 3
nohup ./jobSendMessage.sh > ./logs/jobSendMessage.log 2>&1 & >> ./logs/startup.log 2>&1

echo $(date) ">>>> All processes started" >> ./logs/startup.log
