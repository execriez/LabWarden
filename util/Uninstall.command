#!/bin/bash
#
# Short:    Uninstall LabWarden
# Author:   Mark J Swift
# Version:  1.0.90
# Modified: 01-Jul-2016
#
#
# Called as follows:    
#   Uninstall.command
#
# Note, the contents of any directory called "custom" is not uninstalled
#

# ---

# Path to this script
LW_sv_ThisScriptDirPath="$(dirname "${0}")"

# Path to payload
sv_PayloadDirPath="$(dirname "${LW_sv_ThisScriptDirPath}")"

# Change working directory
cd "${LW_sv_ThisScriptDirPath}"

# Filename of this script
LW_sv_ThisScriptFileName="$(basename "${0}")"

# Filename without extension
LW_sv_ThisScriptName="$(echo ${LW_sv_ThisScriptFileName} | sed 's|\.[^.]*$||')"

# Full souce of this script
LW_sv_ThisScriptFilePath="${0}"

# ---

# Get user name
LW_sv_ThisUserName="$(whoami)"

# ---

# Check if user is an admin (returns "true" or "false")
if [ "$(dseditgroup -o checkmember -m "${LW_sv_ThisUserName}" -n . admin | cut -d" " -f1)" = "yes" ]
then
  LW_bv_ThisUserIsAdmin="true"
else
  LW_bv_ThisUserIsAdmin="false"
fi

# ---

if [ "${LW_bv_ThisUserIsAdmin}" = "false" ]
then
  echo "Sorry, you must be an admin to uninstall this script."
  echo ""

else
  echo ""
  echo "Uninstalling LabWarden."
  echo "If asked, enter the password for user '"${LW_sv_ThisUserName}"'"
  echo ""
  
  sudo su root <<'HEREDOC'

  # Set the signature for the LabWarden installation
  LW_sv_LabWardenSignature="com.github.execriez.LabWarden"

  # Remove old install
  find -d /usr/local/LabWarden/Policies/custom -iname "*ExamplePolicy" -exec rm -fd {} \;
  find -d /usr/local/LabWarden ! -ipath "*/custom/*" -exec rm -fd {} \;
  rm -f /Library/LaunchAgents/${LW_sv_LabWardenSignature}*
  rm -f /Library/LaunchDaemons/${LW_sv_LabWardenSignature}*
  
  if test -n "$(defaults read /private/var/root/Library/Preferences/com.apple.loginwindow LoginHook | grep -i "LabWarden")"
  then
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
