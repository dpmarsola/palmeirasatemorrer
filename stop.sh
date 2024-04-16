#!/usr/bin/bash

cd ~/palmeirasatemorrer

echo $(date) ">>>> Killing all processes" >> ./logs/stop.log

kill -9 $(pgrep -f ngrok) >> ./logs/stop.log 2>&1
kill -9 $(pgrep -f runserver) >> ./logs/stop.log 2>&1
kill -9 $(pgrep -f jobSendMessage) >> ./logs/stop.log 2>&1
kill -9 $(pgrep -f sendMessage) >> ./logs/stop.log 2>&1
kill -9 $(pgrep -f pywhatkitWrapper) >> ./logs/stop.log 2>&1

echo $(date) ">>>>> All processes killed" >> ./logs/stop.log
