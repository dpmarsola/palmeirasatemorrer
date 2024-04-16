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
			echo "Sending file... $filename at $hour:$minute"
			python3 sendMessage.py $hour $minute $filename
			echo "File sent... $filename at $hour:$minute" 
			
			echo $(date) ">>>> Moving file... $filename to ./sent" $(mv $filename ./sent) 
 
			sleep 10

		done <<< $(ls ./tosend/*.msg 2> /dev/null)

	fi

}

################## MAIN ##############################
cd ~/palmeirasatemorrer

while true
do
    readfiles
	echo $(date) ">>>> No more files to send, checking for more in 5 seconds..."
    sleep 5
done
