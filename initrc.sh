#!/usr/bin/bash

export HOME=/home/ubuntu

su - ubuntu -c "cd ~/palmeirasatemorrer && startup.sh >> ./logs/initrc.log 2>&1" >> ~/palmeirasatemorrer/logs/initrc.log 2>&1

