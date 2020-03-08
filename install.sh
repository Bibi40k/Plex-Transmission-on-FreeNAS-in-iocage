#!/bin/bash
# Build Plex & Transmission Iocage Jail under FreeNAS


# Getting installer dir ( /root/Plex-and-Transmission-on-FreeNAS-in-Iocage )
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "${SCRIPT}")
echo "SCRIPTPATH is $SCRIPTPATH"
echo "${SCRIPTPATH}/scripts/dirs.sh"


# Import scripts from /scripts dir
source ${SCRIPTPATH}/scripts/dirs.sh # create all dir structure
