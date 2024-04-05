#!/usr/bin/bash

echo $(date) ">>>> Killing all processes" >> ./logs/stop.log

kill -9 $(pgrep ngrok) >> ./logs/stop.log 2>&1
kill -9 $(pgrep runserver) >> ./logs/stop.log 2>&1
kill -9 $(pgrep jobSendMessage) >> ./logs/stop.log 2>&1
kill -9 $(pgrep sendMessage) >> ./logs/stop.log 2>&1
kill -9 $(pgrep pywhatkitWrapper) >> ./logs/stop.log 2>&1

echo $(date) ">>>>> All processes killed" >> ./logs/stop.log