#!/usr/bin/bash

python3 manage.py runserver 8040 & >> ./logs/djangoserver.log 2>> ./logs/djangoserver.log
sleep 3
ngrok http http://localhost:8040 & >> ./logs/ngrok.log 2>> ./logs/ngrok.log
sleep 3
/home/daniel/workspace/palmeirasatemorrer/jobSendMessage.sh & >> ./logs/jobSendMessage.log 2>> ./logs/jobSendMessage.log

