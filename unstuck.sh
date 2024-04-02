#!/usr/bin/bash

echo $(date) ">>>> Killing stuck processes" >> ./logs/unstuck.log

echo $(date) "The following processes are stuck:" >> ./logs/unstuck.log
echo $(ps -ef | grep jobSendMessage | grep -v color) >> ./logs/unstuck.log
echo $(ps -ef | grep sendMessage | grep -v color) >> ./logs/unstuck.log

echo $(date) "Killing them now...." >> ./logs/unstuck.log

kill -9 $(ps -ef | grep jobSendMessage | grep -v color | cut -c'11-19') >> ./logs/unstuck.log 2>&1
kill -9 $(ps -ef | grep sendMessage | grep -v color | cut -c'11-19') >> ./logs/unstuck.log 2>&1

echo $(date) "Reviving whatever should relive...." >> ./logs/unstuck.log

echo $(date) "This process has been revived by unstuck.sh" >> ./logs/jobSendMessage.log
nohup /home/daniel/workspace/palmeirasatemorrer/jobSendMessage.sh >> ./logs/jobSendMessage.log 2>&1 &

echo $(date) ">>>>> All processes are unstuk" >> ./logs/unstuck.log

