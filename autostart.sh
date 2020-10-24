#!/bin/bash

MAXCOUNTER=23

#setting the Errorcode
$(exit 42)
while [ $? != 0 ] && [ $MAXCOUNTER != 0 ]; do
	MAXCOUNTER="$((MAXCOUNTER-1))"
	#echo $MAXCOUNTER
	sleep 2
	ONLINEID=$(curl -f https://raw.githubusercontent.com/Andymann/Tizonia-RPI3/master/updateID.txt|grep "^[^#]")
done

if [[ "$MAXCOUNTER" != 0 ]]; then
	# At this point we were able to retrieve an ID from the URL.
	OFFLINEID=$(cat ./Tizonia-RPI3/updateID.txt|grep "^[^#]")
	if [[ "$ONLINEID" != "$OFFLINEID" ]]
	then
		echo "Different IDs. Updating ..."
		rm -rf ./Tizonia-RPI3.old
		mv ./Tizonia-RPI3 ./Tizonia-RPI3.old
		git clone https://github.com/Andymann/Tizonia-RPI3.git
		chmod +x ./Tizonia-RPI3/autostart.sh

	else
		echo "Identical IDs. Nothing to update."
	fi
else
	echo "Too many tries. Maybe we're offline or the URL does not contain an ID."
fi

# We might as well run Tizonia in a loop from here but
# the goal of this script is updating and such. The rest is
# basically another piece of cake.
./Tizonia-RPI3/autostart.sh
