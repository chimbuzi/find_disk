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

# figure out if we've been given a wwn
if [[ "$1" == "wwn"* ]]
then
        # do something
        echo "Looking up by WWN..."
        TARGETWWN=$1

        # resolve the device file pointed to by the symlink
        TARGETDEV=$(readlink -f /dev/disk/by-id/$TARGETWWN)
        echo $TARGETDEV
        # list all devices by ID and loop over then
        ALLDEV="/dev/disk/by-id/*"
        for DEV in $ALLDEV
        do
                # check if we've just matched the WWN we passed in the script. If so, keep looking.
                if [ $DEV == "wwn*" ]
                then
                        continue
                fi
                # match the symlink target to the target from the passed WWN. If match, return serial.
                if [ $(readlink -f $DEV) == $TARGETDEV ]
                then
                        echo $DEV
                        break
                fi
        done
        exit 0

fi

# figure out if we've been given a device name
if [[ "$1" == "sd"* ]] || [[ "$1" == "/dev/sd"* ]]
then
        # do something
        echo "Looking up by device name..."

        # find the right device file regardless of what was passed
        ALLDEV="/dev/*"
        for DEV in $ALLDEV
        do
                if [[ "$DEV" == *"$1"* ]]
                then
                        TARGETDEV=$DEV
                fi
        done

        # then look up the WWN and serial
        ALLDEV="/dev/disk/by-id/*"
        for DEV in $ALLDEV
        do
                if [ $(readlink -f $DEV) == $TARGETDEV ]
                then
                        echo $DEV
                fi
        done





        exit 0
fi



# otherwise, assume serial number
echo "Looking up by serial number..."
TARGETSERIAL=$1
TARGETDEV=$(readlink -f /dev/disk/by-id/$TARGETSERIAL)
echo $TARGETDEV
ALLDEV="/dev/disk/by-id/*"
for DEV in $ALLDEV
do
        if [[ "$DEV" != *"wwn"* ]]
        then
                continue
        fi
        if [ $(readlink -f $DEV) == $TARGETDEV ]
        then
                echo $DEV
                break
        fi
done
exit 0
