#!/usr/bin/bash

cd ~/palmeirasatemorrer

echo $(date) ">>>>>>>>>> Killing stuck processes <<<<<<<<<<" >> ./logs/unstuck.log

echo $(date) ">>>> The following processes might be stuck:" >> ./logs/unstuck.log
echo $(pgrep -f jobSendMessage) >> ./logs/unstuck.log
echo $(pgrep -f sendMessage) >> ./logs/unstuck.log
echo $(pgrep -f chrome) >> ./logs/unstuck.log

echo $(date) ">>>> Killing them now...." >> ./logs/unstuck.log

kill -9 $(pgrep -f jobSendMessage) >> ./logs/unstuck.log 2>&1
kill -9 $(pgrep -f sendMessage) >> ./logs/unstuck.log 2>&1
kill -9 $(pgrep -f chrome) >> ./logs/unstuck.log 2>&1

echo $(date) ">>>> Moving stuck files to ./stuck" >> ./logs/unstuck.log
mv ./tosend/*.msg ./stuck 2> /dev/null 

echo $(date) ">>>> Reviving whatever should relive...." >> ./logs/unstuck.log

nohup ./jobSendMessage.sh >> ./logs/jobSendMessage.log 2>&1 &
result=$?

if [ $result -ne 0 ]
then
    echo $(date) ">>>> Failed to revive jobSendMessage.sh - Error: " $result>> ./logs/unstuck.log
    echo $(date) ">>>>>>>>>> Processes Unstuck Failed <<<<<<<<<<" >> ./logs/unstuck.log
    exit 1
else
    echo $(date) ">>>> The process jobSendMessage.sh has been revived by unstuck.sh" >> ./logs/jobSendMessage.log
    mv ./stuck/*.msg ./tosend 2> /dev/null
    echo $(date) ">>>> Moving files back from ./stuck to ./tosend" >> ./logs/unstuck.log
    echo $(date) ">>>>>>>>>> All processes are unstuk <<<<<<<<<<" >> ./logs/unstuck.log
fi
