#!/bin/bash

# Copyright Sam Thompson 2021
# Made available under BSD 3-clause licence. Look it up if you care.
# No warranty etc.



# Check if we have been given any arguments. If not, print a help message.
if [[ $# -eq 0 ]]
then
        echo "Usage: pass a WWN for a drive, and receive the corresponding serial number."
        exit 1
fi

TARGETWWN=$1

# resolve the actual device file pointed to by the wwm symlink
TARGETDEV=$(readlink -f /dev/disk/by-id/$TARGETWWN)

# list all devices by ID and loop over them
ALLDEV="/dev/disk/by-id/*"
for DEV in $ALLDEV
do
        # check if we've just matched the WWN we passed the script. If so, keep looking.
        if [ $DEV == "wwn*" ]
        then
                continue
        fi
        # Match the symlink target to the target from the passed WWN. If match, return serial.
        if [ $(readlink -f $DEV) == $TARGETDEV ]
        then
                echo $DEV
                break
        fi

done
