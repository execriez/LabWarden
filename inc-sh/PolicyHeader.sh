#!/bin/bash
#
# Short:    Gen Policy Footer - Included at the beginning of every (bash) gen policy
# Author:   Mark J Swift
# Version:  3.3.0
# Modified: 22-May-2022
#
# Note: The following globals should be set up before this script is included:
#       GLB_SV_PROJECTDIRPATH
#       GLB_SV_CODEVERSION
#       GLB_SV_DEPRECATEDBYPOLICYLIST
#
# Should be included at the top of any policy script as follows:
#   . "${GLB_SV_PROJECTDIRPATH}"/inc-sh/PolicyHeader.sh
#
# Policies are called with the following parameters:
#
#  GLB_SV_POLICYNAME                                 - ${1} The name of the running policy
#  GLB_SV_EVENTNAME                                  - ${2} The event that triggered the policy
#  GLB_SV_OPTIONALPARAM                              - ${3} A general variable that is used to pass optional parameters
#  GLB_SV_CONSOLEUSERINFO                            - ${4} USERNAME;USERID;USERISADMIN;USERISLOCAL;USERISMOBILE;HOMEISLOCAL;HOMEDIRPATH;LOCALHOMEDIRPATH;NETWORKHOMEURI;NETWORKHOMEDIRPATH
#  GLB_SV_CONFIGUUID                                 - ${5} The entry in the config payload that holds the configurable parameters for this policy
#  GLB_SV_CONFIGFILEPATH                             - ${6} The current config file path 
#  GLB_SV_POLICYPREFSFILEPATH                        - ${7} Policy local prefs. Referenced by CONFIGUUID. Deleted when the policy is updated or uninstalled
#  GLB_SV_SHAREDPREFSFILEPATH                        - ${8} Policy shared prefs. Referenced by POLICYNAME. These survive policy updates and uninstalls
#  GLB_SV_SYSDEFAULTSCONFIGFILEPATH                  - ${9} System defaults payload file path
#  GLB_SV_LOGINFO                                    - ${10} LOGISACTIVE;LOGLEVELTRAP;LOGSIZEMAXBYTES;LOGFILEPATH
#
#
# The following globals are passed in the GLB_SV_CONSOLEUSERINFO string during "Usr-" events and during 
# Sys-ConsoleUserLoggedIn, Sys-ConsoleUserLoggedOut, Sys-ConsoleUserSwitch, Sys-Login and Sys-Logout events.
# The GLB_SV_CONSOLEUSERINFO global is null during other "Sys-" events
#
#  GLB_SV_CONSOLEUSERNAME                           - The name of the logged-in user. 
#                                                   - A null string signifies no-one is logged in.
#                                                   - The logged-in user may or may not be the user who is running the script
#  GLB_IV_CONSOLEUSERID                             - The user ID of the logged-in user.
#  GLB_BV_CONSOLEUSERISADMIN                        - Whether the logged-in user is an admin (true/false)
#  GLB_BV_CONSOLEUSERISLOCAL                        - Whether the logged-in user account is local (true/false)
#  GLB_BV_CONSOLEUSERISMOBILE                       - Whether the logged-in user account is mobile (true/false)
#  GLB_BV_CONSOLEUSERHOMEISLOCAL                    - Whether the logged-in user home is on a local drive (true/false)
#  GLB_SV_CONSOLEUSERHOMEDIRPATH                    - The userhome path for the logged in user
#  GLB_SV_CONSOLEUSERLOCALHOMEDIRPATH               - The local userhome path for the logged in user
#  GLB_SV_CONSOLEUSERSHAREURI                       - The network home URI for the logged in user (if known) - ie: smb://yourserver.com/staff/t/thisuser
#  GLB_SV_CONSOLEUSERSHAREDIRPATH                   - The network userhome path for the logged in user - or null if none is mounted
#
# The following globals are passed in the GLB_SV_LOGINFO string 
#
#  GLB_BV_LOGISACTIVE                     - Whether we should log (true/false) 
#  GLB_IV_LOGLEVELTRAP                    - The logging level (see GLB_iv_MsgLevel...)
#  GLB_IV_LOGSIZEMAXBYTES                 - Maximum length of LabWarden log(s)
#
# The following global is available during these events Sys-VolDidMount,Sys-VolWillUnmount,Sys-VolDidUnmount
#                                                       Usr-VolDidMount,Usr-VolWillUnmount,Usr-VolDidUnmount
#
#  GLB_SV_MOUNTEDVOLUMEDIRPATH                       - The Volume mount path - i.e. /Volumes/YourDrive
#
# The following global is available during these events Sys-InterfaceUp,Sys-InterfaceDown,Sys-NetworkUp,Sys-NetworkDown
#
#  GLB_SV_MOUNTEDNETWORKDEVICENAME                   - The mounted network device name - i.e. en0
#
# The following global is available during these events Sys-NetworkUp,Sys-NetworkDown
#
#  GLB_SV_MOUNTEDNETWORKSERVICEUUID                  - The mounted network  service UUID - i.e. "9804EAB2-718C-42A7-891D-79B73F91CA4B"
#
# The following globals are available during these events Usr-AppWillLaunch,Usr-AppDidLaunch,Usr-AppDidTerminate
#
#  GLB_SV_LAUNCHEDAPPBUNDLEIDENTIFIER                - The ApplicationBundleIdentifier e.g. com.apple.TextEdit
#  GLB_SV_LAUNCHEDAPPNOTIFICATIONTYPE                - The Application notification e.g. WillLaunch, DidLaunch or DidTerminate
#  GLB_IV_LAUNCHEDAPPNOTIFICATIONEPOCH               - The Date/Time Epoch of the notification
#  GLB_SV_LAUNCHEDAPPNAME                            - The Application Name e.g. TextEdit
#  GLB_SV_LAUNCHEDAPPFILEPATH                        - The Application Path e.g. /Applications/TextEdit.app
#  GLB_IV_LAUNCHEDAPPPROCESSID                       - The Application Process Identifier - i.e. the process ID

# ---

if [ $# -eq 0 ]
then
  echo "${GLB_SV_CODEVERSION}"
  exit 0
fi

# ---

if [ $# -ne 10 ]
then
  exit 0
fi

# ---
GLB_SV_POLICYNAME="${1}"
GLB_SV_EVENTNAME="${2}"

# Get optional parameter
# This is a general variable that is currently used to pass the following info:
#   User info during a Sys-ConsoleUserLoggedIn, Sys-ConsoleUserLoggedOut, Sys-ConsoleUserSwitch, Sys-Login or Sys-Logout event.
#   Volume info during sys-VolDidMount, Sys-VolWillUnmount and Sys-VolDidUnmount events
#
#   Application info during Usr-AppWillLaunch, Usr-AppDidLaunch or Usr-AppDidTerminate events.
#   Volume info during Usr-VolDidMount, Usr-VolWillUnmount and Usr-VolDidUnmount events
#
GLB_SV_OPTIONALPARAM="${3}"

# Get the the logged in user info.
# A null string signifies no-one is logged in, or this is a system event.
GLB_SV_CONSOLEUSERINFO="${4}"

# Check if we have been passed user info
if [ -n "${GLB_SV_CONSOLEUSERINFO}" ]
then
  GLB_SV_CONSOLEUSERNAME=$(echo "${GLB_SV_CONSOLEUSERINFO}" | cut -s -d ";" -f1)
  GLB_IV_CONSOLEUSERID=$(echo "${GLB_SV_CONSOLEUSERINFO}" | cut -s -d ";" -f2)
  GLB_BV_CONSOLEUSERISADMIN=$(echo "${GLB_SV_CONSOLEUSERINFO}" | cut -s -d ";" -f3)
  GLB_BV_CONSOLEUSERISLOCAL=$(echo "${GLB_SV_CONSOLEUSERINFO}" | cut -s -d ";" -f4)
  GLB_BV_CONSOLEUSERISMOBILE=$(echo "${GLB_SV_CONSOLEUSERINFO}" | cut -s -d ";" -f5)
  GLB_BV_CONSOLEUSERHOMEISLOCAL=$(echo "${GLB_SV_CONSOLEUSERINFO}" | cut -s -d ";" -f6)
  GLB_SV_CONSOLEUSERHOMEDIRPATH=$(echo "${GLB_SV_CONSOLEUSERINFO}" | cut -s -d ";" -f7)
  GLB_SV_CONSOLEUSERLOCALHOMEDIRPATH=$(echo "${GLB_SV_CONSOLEUSERINFO}" | cut -s -d ";" -f8)
  GLB_SV_CONSOLEUSERSHAREURI=$(echo "${GLB_SV_CONSOLEUSERINFO}" | cut -s -d ";" -f9)
  GLB_SV_CONSOLEUSERSHAREDIRPATH=$(echo "${GLB_SV_CONSOLEUSERINFO}" | cut -s -d ";" -f10)
fi

GLB_SV_CONFIGUUID="${5}"

GLB_SV_CONFIGFILEPATH="${6}"
GLB_SV_POLICYPREFSFILEPATH="${7}"
GLB_SV_SHAREDPREFSFILEPATH="${8}"
GLB_SV_SYSDEFAULTSCONFIGFILEPATH="${9}"
GLB_SV_LOGINFO="${10}"

# Check if we have been passed user info
if [ -n "${GLB_SV_LOGINFO}" ]
then
  GLB_BV_LOGISACTIVE=$(echo "${GLB_SV_LOGINFO}" | cut -s -d ";" -f1)
  GLB_IV_LOGLEVELTRAP=$(echo "${GLB_SV_LOGINFO}" | cut -s -d ";" -f2)
  GLB_IV_LOGSIZEMAXBYTES=$(echo "${GLB_SV_LOGINFO}" | cut -s -d ";" -f3)
  GLB_SV_LOGFILEPATH=$(echo "${GLB_SV_LOGINFO}" | cut -s -d ";" -f4)
fi

# Get info from optional parameter
case ${GLB_SV_EVENTNAME} in

Sys-ConsoleUserLoggedIn|Sys-ConsoleUserLoggedOut|Sys-ConsoleUserSwitch|Sys-Login|Sys-Logout)
  GLB_SV_CONSOLEUSERNAME="${GLB_SV_OPTIONALPARAM}"
  ;;
  
Sys-VolDidMount|Sys-VolWillUnmount|Sys-VolDidUnmount)
  # Get Volume mount path - i.e. /Volumes/YourDrive
  GLB_SV_MOUNTEDVOLUMEDIRPATH="${GLB_SV_OPTIONALPARAM}"
  ;;
  
Sys-InterfaceUp|Sys-InterfaceDown)
  # Get Network device name - i.e. en0
  GLB_SV_MOUNTEDNETWORKDEVICENAME="${GLB_SV_OPTIONALPARAM}"
  ;;
  
Sys-NetworkUp|Sys-NetworkDown)
  # Get network service UUID - i.e. "9804EAB2-718C-42A7-891D-79B73F91CA4B"
  GLB_SV_MOUNTEDNETWORKSERVICEUUID="$(echo ${GLB_SV_OPTIONALPARAM} | cut -d":" -f1)"

  # Get Network device name - i.e. "en0"
  GLB_SV_MOUNTEDNETWORKDEVICENAME="$(echo ${GLB_SV_OPTIONALPARAM} | cut -d":" -f2)"
  ;;
  
Usr-AppWillLaunch|Usr-AppDidLaunch|Usr-AppDidTerminate)

  # Get ApplicationBundleIdentifier e.g. com.apple.TextEdit
  # Note, older applications may return "(null)"
  GLB_SV_LAUNCHEDAPPBUNDLEIDENTIFIER="$(echo ${GLB_SV_OPTIONALPARAM} | cut -d":" -f3)"

  # Get notification e.g. WillLaunch, DidLaunch or DidTerminate
  GLB_SV_LAUNCHEDAPPNOTIFICATIONTYPE="$(echo ${GLB_SV_OPTIONALPARAM} | cut -d":" -f1)"

  # Get Date/Time Epoch of the notification
  GLB_IV_LAUNCHEDAPPNOTIFICATIONEPOCH="$(echo ${GLB_SV_OPTIONALPARAM} | cut -d":" -f2)"

  # Get ApplicationName e.g. TextEdit
  GLB_SV_LAUNCHEDAPPNAME="$(echo ${GLB_SV_OPTIONALPARAM} | cut -d":" -f4)"

  # Get ApplicationPath e.g. /Applications/TextEdit.app
  GLB_SV_LAUNCHEDAPPFILEPATH="$(echo ${GLB_SV_OPTIONALPARAM} | cut -d":" -f5)"

  # Get ApplicationProcessIdentifier - i.e. the process ID
  GLB_IV_LAUNCHEDAPPPROCESSID="$(echo ${GLB_SV_OPTIONALPARAM} | cut -d":" -f6)"
  ;;

Usr-VolDidMount|Usr-VolWillUnmount|Usr-VolDidUnmount)
  # Get Volume mount path - i.e. /Volumes/YourDrive
  GLB_SV_MOUNTEDVOLUMEDIRPATH="${GLB_SV_OPTIONALPARAM}"
  ;;
  
esac

# ---

# Include the policy defs library (if it is not already loaded)
if [ -z "${GLB_BC_PLCYDEFS_INCLUDED}" ]
then
  . "${GLB_SV_PROJECTDIRPATH}"/inc-sh/PolicyDefs.sh

  # Exit if something went wrong unexpectedly
  if [ -z "${GLB_BC_PLCYDEFS_INCLUDED}" ]
  then
    echo >&2 "Something unexpected happened - '${0}' PLCYDEFS"
    exit 90
  fi
fi

# By the time we get here, quite a few global variables have been set up.

# ---

# Execute the Policy

# Take a note of the Policy call
GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Policy '${GLB_SV_POLICYNAME}' ${GLB_SV_OPTIONALPARAM} triggered by event '${GLB_SV_EVENTNAME}' as user '${GLB_SV_RUNUSERNAME}'"

# ---

case ${GLB_SV_EVENTNAME} in

Sys-PolicyInstall|Usr-PolicyInstall)
  iv_NowEpoch=$(date -u "+%s")
  GLB_NF_SETPLISTPROPERTY "${GLB_SV_POLICYPREFSFILEPATH}" ":${GLB_SV_CONFIGUUID}:Name" "${GLB_SV_POLICYNAME}"
  GLB_NF_SETPLISTPROPERTY "${GLB_SV_POLICYPREFSFILEPATH}" ":${GLB_SV_CONFIGUUID}:Prefs:FirstRunEpoch" "${iv_NowEpoch}"
  ;;

*)
  # if the prefs don't exist, wait a little while for the policy prefs to get initialised
  iv_DelayCount=0
  while [ ! -e "${GLB_SV_POLICYPREFSFILEPATH}" ]
  do
    GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Waiting for init (${iv_DelayCount})"

    # We don't want to hog the CPU - so lets sleep a while
    sleep 1

    iv_DelayCount=$((${iv_DelayCount}+1))
    if [ ${iv_DelayCount} -ge 10 ]
    then
      GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE}  "'${GLB_SV_THISSCRIPTFILENAME}' aborted. Policy prefs haven't been initialised yet"
      exit 0
    fi
  done
  ;;
  
esac

# ---

# Check if a payload is installed from a newer version of the script
if [ -n "${GLB_SV_DEPRECATEDBYPOLICYLIST}" ]
then
  if [ $(GLB_BF_POLICYCONFIGISINSTALLED "${GLB_SV_DEPRECATEDBYPOLICYLIST}") = ${GLB_BC_TRUE} ]
  then
    GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE}  "'${GLB_SV_THISSCRIPTFILENAME}' aborted. This policy is deprecated by an installed payload from '${GLB_SV_DEPRECATEDBYPOLICYLIST}'."
    . "${GLB_SV_PROJECTDIRPATH}"/inc-sh/PolicyFooter.sh
    exit 0

  else
    GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Legacy policy '${GLB_SV_THISSCRIPTFILENAME}' is active. You should look at creating a new profile for one of the following policies '${GLB_SV_DEPRECATEDBYPOLICYLIST}'."

  fi
fi

