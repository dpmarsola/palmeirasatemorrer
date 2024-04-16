#!/usr/bin/bash

mkdir ./logs ./sent ./tosend ./security

pip install pywhatkit django

sudo apt install python3-tk python3-dev

echo "email" >> ./security/credentials
echo "password" >> ./security/credentials
