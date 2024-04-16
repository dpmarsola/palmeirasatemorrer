#!/usr/bin/bash

cd ~/palmeirasatemorrer

echo $(date) ">>>> Killing stuck processes" >> ./logs/unstuck.log

echo $(date) "The following processes are stuck:" >> ./logs/unstuck.log
echo $(pgrep -f jobSendMessage) >> ./logs/unstuck.log
echo $(pgrep -f sendMessage) >> ./logs/unstuck.log

echo $(date) "Killing them now...." >> ./logs/unstuck.log

kill -9 $(pgrep -f jobSendMessage) >> ./logs/unstuck.log 2>&1
kill -9 $(pgrep -f sendMessage) >> ./logs/unstuck.log 2>&1

echo $(date) ">>>> Moving stuck files to ./stuck" >> ./logs/unstuck.log
mv ./tosend/*.msg ./stuck 2> /dev/null 

echo $(date) "Reviving whatever should relive...." >> ./logs/unstuck.log

echo $(date) "This process has been revived by unstuck.sh" >> ./logs/jobSendMessage.log
nohup ./jobSendMessage.sh >> ./logs/jobSendMessage.log 2>&1 &

echo $(date) ">>>>> All processes are unstuk" >> ./logs/unstuck.log

