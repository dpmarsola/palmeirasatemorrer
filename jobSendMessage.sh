#!/usr/bin/bash

dateHourMinuteCalculation()
{

	minute=$(expr $minute + 1)

	if [ $minute -gt 59 ]
	then
	   if [ $minute -gt 61 ]
	   then
	     echo "Error: More than 60 minutes in an hour"
	   else
	     minute=$(expr $minute - 60)
	     hour=$(expr $hour + 1)
	   fi
	fi


	if [ $hour -gt 23 ]
	then
	   if [ $hour -gt 24 ]
	   then
	     echo "Error: More than 24 hours in a day"
	   else
	     hour=$(expr $hour - 24)
	   fi
	fi
}


readfiles()
{
    files=$(ls ./tosend/*.msg 2> /dev/null)

	if [ $? -eq 0 ]
	then
		while read filename
		do
			echo $(date) ">>>> Sending File... $filename"
			hour=$(date +%H)
			minute=$(date +%M)

			dateHourMinuteCalculation  
			echo "Sending file... $filename at $hour:$minute" >> ./logs/sendMessage.log 2>&1
			python3 sendMessage.py $hour $minute $filename >> ./logs/sendMessage.log 2>&1
			echo "File sent... $filename at $hour:$minute" >> ./logs/sendMessage.log 2>&1

			echo $(date) ">>>> Moving file... $filename to ./sent" >> ./logs/sendMessage.log 2>&1
			mv $filename ./sent

		done <<< $(ls ./tosend/*.msg 2> /dev/null)
	fi

}

################## MAIN ##############################

while true
do
    readfiles
	echo "Sleeping for 5 seconds"
    sleep 5
done