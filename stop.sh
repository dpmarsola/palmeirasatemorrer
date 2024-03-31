#!/usr/bin/bash

echo $(date) ">>>> Killing all processes" >> ./logs/stop.log

kill -9 $(ps -ef | grep ngrok | grep -v color | cut -c'11-19') >> ./logs/stop.log 2>&1
kill -9 $(ps -ef | grep runserver | grep -v color | cut -c'11-19') >> ./logs/stop.log 2>&1
kill -9 $(ps -ef | grep jobSendMessage | grep -v color | cut -c'11-19') >> ./logs/stop.log 2>&1
kill -9 $(ps -ef | grep sendMessage | grep -v color | cut -c'11-19') >> ./logs/stop.log 2>&1

echo $(date) ">>>>> All processes killed" >> ./logs/stop.log