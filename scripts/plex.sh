#!/bin/bash
# Plex configuration



echo -e "${INFO} Starting Plex configuration..."
  iocage exec ${JAIL_NAME} "mkdir -p /mnt/plexdata"
  iocage exec ${JAIL_NAME} "chown -R media:ftp /mnt/plexdata"
  iocage fstab -a ${JAIL_NAME} '"${DPLEXDATA}" /mnt/plexdata nullfs rw 0 0'



if [ ${PLEXPASS} == "YES" ]; then
  echo
    iocage exec ${JAIL_NAME} "sysrc plexmediaserver_plexpass_enable='YES'"
    iocage exec ${JAIL_NAME} "sysrc plexmediaserver_plexpass_support_path='/mnt/plexdata'"
    iocage exec ${JAIL_NAME} "sysrc plexmediaserver_plexpass_user='media'"
    iocage exec ${JAIL_NAME} "sysrc plexmediaserver_plexpass_group='ftp'"
else
  echo
    iocage exec ${JAIL_NAME} "sysrc plexmediaserver_enable='YES'"
    iocage exec ${JAIL_NAME} "sysrc plexmediaserver_support_path='/mnt/plexdata'"
    iocage exec ${JAIL_NAME} "sysrc plexmediaserver_user='media'"
    iocage exec ${JAIL_NAME} "sysrc plexmediaserver_group='ftp'"
fi



echo
IN_DPLUGINS="/mnt/plexdata/Plex Media Server/Plug-ins" # accessible from inside Jail
OUT_DPLUGINS="${DPLEXDATA}/Plex Media Server/Plug-ins" # accessible from FreeNAS (outside Jail)

if [ ! -d "${OUT_DPLUGINS}"/WebTools.bundle ]; then
  # Install WebTools.bundle
  WebTools_link="https://github.com/ukdtom/WebTools.bundle/releases/download/3.0.0/WebTools.bundle.zip"

  wget ${WebTools_link} -P "${OUT_DPLUGINS}"
  unzip "${OUT_DPLUGINS}"/WebTools.bundle.zip -d "${OUT_DPLUGINS}"
  rm "${OUT_DPLUGINS}"/WebTools.bundle.zip
  chown -R media:ftp "${OUT_DPLUGINS}"/WebTools.bundle
fi



# @@@ INTEL GPU OFFLOAD NOTES @@@

# If you have a supported Intel GPU, you can leverage hardware
# accelerated encoding/decoding in Plex Media Server on FreeBSD 12.0+.

# The requirements are as follows:

# * Install multimedia/drm-kmod: e.g., pkg install drm-fbsd12.0-kmod

# * Enable loading of kernel module on boot: sysrc kld_list+="i915kms"
# ** If Plex will run in a jail, you must load the module outside the jail!

# * Load the kernel module now (although reboot is advised): kldload i915kms

# * Add plex user to the video group: pw groupmod -n video -m plex

# * For jails, make a devfs ruleset to expose /dev/dri/* devices.

# e.g., /dev/devfs.rules on the host:

# [plex_drm=10]
# add include $devfsrules_hide_all
# add include $devfsrules_unhide_basic
# add include $devfsrules_unhide_login
# add include $devfsrules_jail
# add path 'dri*' unhide
# add path 'dri/*' unhide
# add path 'drm*' unhide
# add path 'drm/*' unhide

# * Enable the devfs ruleset for your jail. e.g., devfs_ruleset=10 in your
# /etc/jail.conf or for iocage, iocage set devfs_ruleset="10"

# Please refer to documentation for all other FreeBSD jail management
# utilities.

# * Make sure hardware transcoding is enabled in the server settings

# @@@ INTEL GPU OFFLOAD NOTES @@@

