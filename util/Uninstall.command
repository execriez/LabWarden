#!/bin/bash
#
# Short:    Uninstall LabWarden
# Author:   Mark J Swift
# Version:  1.0.100
# Modified: 27-Oct-2016
#
#
# Called as follows:    
#   Uninstall.command [<root_dirpath>]
#
# Note, the contents of any directory called "custom" is not uninstalled
#

# ---

# Full souce of this script
sv_ThisScriptFilePath="${0}"

# Path to this script
sv_ThisScriptDirPath="$(dirname "${sv_ThisScriptFilePath}")"

# Change working directory
cd "${sv_ThisScriptDirPath}"

# Filename of this script
sv_ThisScriptFileName="$(basename "${sv_ThisScriptFilePath}")"

# Filename without extension
sv_ThisScriptName="$(echo ${sv_ThisScriptFileName} | sed 's|\.[^.]*$||')"

# ---

# Load the contants, only if they are not already loaded
if test -z "${LW_sv_LabWardenSignature}"
then
  . "$(dirname "${sv_ThisScriptDirPath}")"/lib/Constants
fi

# ---

# Where we should install
sv_RootDirPath="${1}"

# ---

# Get user name
sv_ThisUserName="$(whoami)"

# ---

# Check if user is an admin (returns "true" or "false")
if [ "$(dseditgroup -o checkmember -m "${sv_ThisUserName}" -n . admin | cut -d" " -f1)" = "yes" ]
then
  bv_ThisUserIsAdmin="true"
else
  bv_ThisUserIsAdmin="false"
fi

# ---

if [ "${bv_ThisUserIsAdmin}" = "false" ]
then
  echo >&2 "ERROR: You must be an admin to uninstall this software."
  exit 0
fi

# ---

if [ "${sv_ThisUserName}" != "root" ]
then
  echo ""
  echo "If asked, enter the password for user '"${sv_ThisUserName}"'"
  echo ""
  sudo "${sv_ThisScriptFilePath}" "${sv_RootDirPath}"

else
  echo "Uninstalling LabWarden."
  echo ""
  
  # Remove old install
  find 2>/dev/null "${sv_RootDirPath}"/usr/local/LabWarden -iname .DS_Store -exec rm -f {} \;
  find 2>/dev/null -d "${sv_RootDirPath}"/usr/local/LabWarden/Policies/custom -iname "*ExamplePolicy" -exec rm -fd {} \;
  find 2>/dev/null -d "${sv_RootDirPath}"/usr/local/LabWarden ! -ipath "*/custom/*" -exec rm -fd {} \;
  rm -f "${sv_RootDirPath}"/Library/LaunchAgents/${LW_sv_LabWardenSignature}*
  rm -f "${sv_RootDirPath}"/Library/LaunchDaemons/${LW_sv_LabWardenSignature}*
  
  if test -n "$(defaults 2>/dev/null read "${sv_RootDirPath}"/private/var/root/Library/Preferences/com.apple.loginwindow LoginHook | grep -i "LabWarden")"
  then
    defaults write "${sv_RootDirPath}"/private/var/root/Library/Preferences/com.apple.loginwindow LoginHook ""
  fi
  
  if test -n "$(defaults 2>/dev/null read "${sv_RootDirPath}"/private/var/root/Library/Preferences/com.apple.loginwindow LogoutHook | grep -i "LabWarden")"
  then
    defaults write "${sv_RootDirPath}"/private/var/root/Library/Preferences/com.apple.loginwindow LogoutHook ""
  fi
  
  if test -z "${sv_RootDirPath}"
  then
    pkgutil 2>/dev/null --forget "${LW_sv_LabWardenSignature}"

    echo "PLEASE REBOOT."
    echo ""
  else
    pkgutil 2>/dev/null --forget "${LW_sv_LabWardenSignature}" --volume "${sv_RootDirPath}"
  fi

fi

exit 0
