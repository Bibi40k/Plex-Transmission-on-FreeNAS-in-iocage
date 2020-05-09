#!/bin/bash
# This script will create all necessary dirs & store them in vars




# Create dirs, copy dummy vars file and set bkp dir
# DIRS=("${TMP_CUSTOM_BKP_DIR}"/"${TMP_CUSTOM_JAIL_NAME}"/{plexdata,transmission-config})
# mkdir -p -- "${DIRS[@]}"


### DIRS ###
# DBKP="${TMP_CUSTOM_BKP_DIR}/${TMP_CUSTOM_JAIL_NAME}"
# DPLEXDATA="${DBKP}/plexdata"
# DTRANSMISSION="${DBKP}/transmission-config"
# DDOWNLOAD="/mnt/${POOL_NAME}/FTP"
# DLOGS="${DCONFIG}/logs"





### DIRS ###
DCONFIG="${DIR}/mediabox-configs"   # Custom configs dir
DBACKUP="${DIR}/backup"             # Custom backup dir
DSERVER="${DCONFIG}/server"         # Server configs dir
DLOGS="${DCONFIG}/logs"             # Logs dir



function CheckConfigDirs {
   
    # Create config dir(s) if doesn't exist(s) already
    # We check for the '/server/originals' because we always keep customizations
    echo -ne "${PROGRESS} checking config dirs... "
    if [[ ! -d "${DCONFIG}/server/originals" ]] ; then
        echo -e "${WARNING} no config dirs found"
        DIRS=(${DCONFIG}/{server/{keys,originals},clients/originals,logs/originals})
        
        echo -ne "${PROGRESS} creating config dirs to ${DCONFIG}... "
        if mkdir -p -- "${DIRS[@]}"; then
            echo -e "${OK}"
        else
            echo -e "${FAIL}"
        fi
    else
        echo -e "${OK}"
    fi

}


echo
CheckConfigDirs

