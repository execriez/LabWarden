#!/bin/bash
#
# Short:    Uninstall LabWarden
# Author:   Mark J Swift
# Version:  1.0.82
# Modified: 27-May-2016
#
#
#

# ---

# Path to this script
GLB_MyDir="$(dirname "${0}")"

# Path to payload
GLB_PayloadDir="$(dirname "${GLB_MyDir}")"

# Change working directory
cd "${GLB_MyDir}"

# Filename of this script
GLB_MyFilename="$(basename "${0}")"

# Filename without extension
GLB_MyName="$(echo ${GLB_MyFilename} | sed 's|\.[^.]*$||')"

# Full souce of this script
GLB_MySource="${0}"

# ---

# Get user name
GLB_UserName="$(whoami)"

# ---

# Check if user is an admin (returns "true" or "false")
if [ "$(dseditgroup -o checkmember -m "${GLB_UserName}" -n . admin | cut -d" " -f1)" = "yes" ]
then
  GLB_IsAdmin="true"
else
  GLB_IsAdmin="false"
fi

# ---

if [ "${GLB_IsAdmin}" = "false" ]
then
  echo "Sorry, you must be an admin to uninstall this script."
  echo ""

else
  echo ""
  echo "Uninstalling LabWarden."
  echo "If asked, enter the password for user '"${GLB_UserName}"'"
  echo ""
  
  sudo su root <<'HEREDOC'

  # Set the signature for the LabWarden installation
  GLB_LabWardenSignature="com.github.execriez.LabWarden"

  # Remove old install
  rm -fR /usr/local/LabWarden
  rm -f /Library/LaunchAgents/${GLB_LabWardenSignature}*
  rm -f /Library/LaunchDaemons/${GLB_LabWardenSignature}*
  
  if test -n "$(defaults read /private/var/root/Library/Preferences/com.apple.loginwindow LoginHook | grep -i "LabWarden")"
  then
  echo "hello"
    defaults write /private/var/root/Library/Preferences/com.apple.loginwindow LoginHook ""
  fi
  
  if test -n "$(defaults read /private/var/root/Library/Preferences/com.apple.loginwindow LogoutHook | grep -i "LabWarden")"
  then
    defaults write /private/var/root/Library/Preferences/com.apple.loginwindow LogoutHook ""
  fi
  
  echo "PLEASE REBOOT."
  echo ""

HEREDOC

fi
