#!/bin/bash


iocage exec ${CUSTOM_JAIL_NAME} "mkdir -p /mnt/plexdata /mnt/plex-config"
iocage fstab -a ${CUSTOM_JAIL_NAME} "${DPLEXDATA}" "/mnt/plexdata" nullfs rw 0 0
iocage fstab -a ${CUSTOM_JAIL_NAME} "${DPLEXCONFIG}" "/mnt/plex-config" nullfs rw 0 0
iocage fstab -a ${CUSTOM_JAIL_NAME} "chown -R media:ftp /mnt/plexdata"

if [ $CUSTOM_USE_PLEXPASS -eq 1 ]; then
  iocage exec ${CUSTOM_JAIL_NAME} "sysrc plexmediaserver_plexpass_enable='YES'"
  iocage exec ${CUSTOM_JAIL_NAME} "sysrc plexmediaserver_plexpass_support_path='/mnt/plex-config'"
  iocage exec ${CUSTOM_JAIL_NAME} "sysrc plexmediaserver_plexpass_user='media'"
  iocage exec ${CUSTOM_JAIL_NAME} "sysrc plexmediaserver_plexpass_group='ftp'"
else
  iocage exec ${CUSTOM_JAIL_NAME} "sysrc plexmediaserver_enable='YES'"
  iocage exec ${CUSTOM_JAIL_NAME} "sysrc plexmediaserver_support_path='/mnt/plex-config'"
  iocage exec ${CUSTOM_JAIL_NAME} "sysrc plexmediaserver_user='media'"
  iocage exec ${CUSTOM_JAIL_NAME} "sysrc plexmediaserver_group='ftp'"
  sed -i '' "s|-plexpass||" "${DPLEXCONFIG}"/update_packages
fi

iocage exec ${CUSTOM_JAIL_NAME} "crontab /mnt/plex-config/update_packages"

iocage exec ${CUSTOM_JAIL_NAME} "service plexmediaserver start"

# Install WebTools.bundle
iocage exec ${CUSTOM_JAIL_NAME} "wget -O ${DPLEXDATA}/Plex\ Media\ Server/Plug-ins https://github.com/ukdtom/WebTools.bundle/releases/download/3.0.0/WebTools.bundle.zip"
iocage exec ${CUSTOM_JAIL_NAME} "unzip ${DPLEXDATA}/Plex\ Media\ Server/Plug-ins/WebTools.bundle.zip"
iocage exec ${CUSTOM_JAIL_NAME} "rm ${DPLEXDATA}/Plex\ Media\ Server/Plug-ins/WebTools.bundle.zip"
iocage exec ${CUSTOM_JAIL_NAME} "chown -R media:ftp ${DPLEXDATA}/Plex\ Media\ Server/Plug-ins/WebTools.bundle"
iocage exec ${CUSTOM_JAIL_NAME} "service plexmediaserver restart"

