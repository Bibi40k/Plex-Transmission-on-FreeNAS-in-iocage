  #!/bin/bash
# Build Plex & Transmission Iocage Jail under FreeNAS


# Getting installer dir ( /mnt/${POOL_NAME}/BackUPS/Jails/Plex-and-Transmission-on-FreeNAS-in-Iocage )
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "${SCRIPT}")


# Setup workdir and backup dir
WORKDIR=../${SCRIPTPATH}
echo "workdir is "${WORKDIR}


# Import scripts from /scripts dir
source $DIR/scripts/dirs.sh # create all dir structure
