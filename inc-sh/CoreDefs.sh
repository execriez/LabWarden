#!/bin/bash
#
# Short:    Common routines (shell)
# Author:   Mark J Swift
# Version:  3.2.5
# Modified: 30-Dec-2020
#
# This include defines some global variables and functions that are used in core scripts and utilities.
# These variables and functions are not used the policy scripts, unless passed to the policy on the command line.
#
# Defines the following globals:
#
#  GLB_SC_PROJECTSETTINGSDIRPATH          - Top level path to where LabWarden config files are stored
#  GLB_SV_SYSDEFAULTSCONFIGFILEPATH       - System defaults payload file path
#
#  GLB_BV_USELOGINHOOK                    - Whether we should use the com.apple.loginwindow LoginHook & LogoutHook (true/false)
#
#  GLB_BV_LOGISACTIVE                     - Whether we should log (true/false) 
#  GLB_IV_LOGSIZEMAXBYTES                 - Maximum length of LabWarden log(s)
#  GLB_IV_LOGLEVELTRAP                    - The logging level (see GLB_iv_MsgLevel...)
#  GLB_IV_NOTIFYLEVELTRAP                 - The user notify dialog level
#  GLB_SV_LOGFILEPATH                     - Location of the active log file
#
#  GLB_SV_LOGINFO                         - LOGISACTIVE;LOGLEVELTRAP;LOGSIZEMAXBYTES;LOGFILEPATH
#
#  GLB_SV_RUNNINGCONFIGDIRPATH               - Directory location of the local prefs file
#
#  GLB_IV_CONSOLEUSERID                   - The user ID of the logged-in user
#
#  GLB_BV_CONSOLEUSERISADMIN              - Whether the logged-in user is an admin (true/false)
#  GLB_BV_CONSOLEUSERISLOCAL              - Whether the logged-in user account is local (true/false)
#  GLB_BV_CONSOLEUSERISMOBILE             - Whether the logged-in user account is mobile (true/false)
#
#  GLB_BV_CONSOLEUSERHOMEISLOCAL          - Whether the logged-in user home is on a local drive (true/false)
#  GLB_SV_CONSOLEUSERHOMEDIRPATH          - Home directory for the logged-in user
#  GLB_SV_CONSOLEUSERLOCALHOMEDIRPATH     - Local home directory for the logged-in user (in /Users)
#  GLB_SV_CONSOLEUSERSHAREDIRPATH         - Network home directory path, i.e. /Volumes/staff/t/testuser
#
#  GLB_SV_CONSOLEUSERINFO                 - USERNAME;USERID;USERISADMIN;USERISLOCAL;USERISMOBILE;HOMEISLOCAL;HOMEDIRPATH;LOCALHOMEDIRPATH;NETWORKHOMEDIRPATH
#
# Defines the following LabWarden functions:
#
#  GLB_SF_POLICYEXEFILEPATH <PolicyName>  - Return path to the policy executable given the PolicyName
#
#  Key:
#    GLB_ - LabWarden global variable
#
#    bc_ - string constant with the values 'true' or 'false'
#    ic_ - integer constant
#    sc_ - string constant
#
#    bv_ - string variable with the values 'true' or 'false'
#    iv_ - integer variable
#    sv_ - string variable
#
#    nf_ - null function    (doesn't return a value)
#    bf_ - boolean function (returns string values 'true' or 'false'
#    if_ - integer function (returns an integer value)
#    sf_ - string function  (returns a string value)

# ---
  
# Assume that all code is run from a subdirectory of the main project directory
GLB_SV_PROJECTDIRPATH="$(dirname $(dirname ${0}))"

# ---

if [ -z "${GLB_BC_CORE_ISINCLUDED}" ]
then
  
  # ---
  
  # Include the constants library (if it is not already loaded)
  if [ -z "${GLB_BC_CONST_ISINCLUDED}" ]
  then
    . "${GLB_SV_PROJECTDIRPATH}"/inc-sh/Constants.sh

    # Exit if something went wrong unexpectedly
    if test -z "${GLB_BC_CONST_ISINCLUDED}"
    then
      echo >&2 "Something unexpected happened"
      exit 90
    fi
  fi

  # ---
  
  # Location of the system defaults file
  GLB_SV_SYSDEFAULTSCONFIGFILEPATH="/Library/Preferences/${GLB_SC_PROJECTSIGNATURE}/V${GLB_SC_PROJECTMAJORVERSION}/Computers/localhost/Shared/Sys-Defaults.plist"
  
  # ---

  # Include the Common library (if it is not already loaded)
  if [ -z "${GLB_BC_COMM_ISINCLUDED}" ]
  then
    . "${GLB_SV_PROJECTDIRPATH}"/inc-sh/Common.sh

    # Exit if something went wrong unexpectedly
    if [ -z "${GLB_BC_COMM_ISINCLUDED}" ]
    then
      echo >&2 "Something unexpected happened"
      exit 90
    fi
  fi

  # By the time we get here, quite a few global variables have been set up.
  # Look at 'inc/Common.sh' for a complete list.

  # ---

  if [ "${GLB_SV_RUNUSERNAME}" = "root" ]
  then

    # Delete previous preferences
    if [ -e "/Library/Preferences/SystemConfiguration/com.github.execriez.labwarden" ]
    then
      rm -fR "/Library/Preferences/SystemConfiguration/com.github.execriez.labwarden"
    fi
  
    # Location where the computer config/pref files are stored
    GLB_SC_PROJECTSETTINGSDIRPATH="/Library/Preferences/${GLB_SC_PROJECTSIGNATURE}/V${GLB_SC_PROJECTMAJORVERSION}"
  
  else

    # Location where the user config/pref files are stored
    GLB_SC_PROJECTSETTINGSDIRPATH=~/Library/Preferences/${GLB_SC_PROJECTSIGNATURE}/V${GLB_SC_PROJECTMAJORVERSION}
 
  fi

  # ---

  # -- Begin Function Definition --

  GLB_SF_POLICYEXEFILEPATH() # <PolicyName> - Return path to the policy executable given the PolicyName
  {
    local sv_PolicyName
    local sv_PolicyFilePath
    local sv_PolicySearchPath
    local sv_PolicyPath
    
    sv_PolicyName="${1}"
    
    sv_PolicySearchPath="Policies-custom,Policies-legacy,Policies-sh"
    while read sv_PolicyPath
    do
      sv_PolicyFilePath="${GLB_SV_PROJECTDIRPATH}"/${sv_PolicyPath}/${sv_PolicyName}
      if [ -e "${sv_PolicyFilePath}" ]
      then
        break
      fi
      sv_PolicyFilePath=""  
    done < <(echo ${sv_PolicySearchPath}| tr "," "\n")

    echo "${sv_PolicyFilePath}"
  }

  # -- End Function Definition --
  
  # -- Use hard-coded defaults until the system globals are available
  
  GLB_BV_LOGISACTIVE=${GLB_BV_DFLTLOGISACTIVE}
  GLB_IV_LOGSIZEMAXBYTES=${GLB_IV_DFLTLOGSIZEMAXBYTES}
  GLB_IV_LOGLEVELTRAP=${GLB_IV_DFLTLOGLEVELTRAP}
  GLB_IV_NOTIFYLEVELTRAP=${GLB_IV_DFLTNOTIFYLEVELTRAP}

  # -- Read defaults from system globals
  
  if [ -f "${GLB_SV_SYSDEFAULTSCONFIGFILEPATH}" ]
  then
    # Get a value from the global config
    sv_Value="$(GLB_SF_GETPLISTPROPERTY "${GLB_SV_SYSDEFAULTSCONFIGFILEPATH}" ":Sys-Defaults:Shared:UseLoginhook")"
    if [ -n "${sv_Value}" ]
    then
      GLB_BV_USELOGINHOOK=${sv_Value}
    fi
  
    # Get a value from the global config
    sv_Value="$(GLB_SF_GETPLISTPROPERTY "${GLB_SV_SYSDEFAULTSCONFIGFILEPATH}" ":Sys-Defaults:Shared:LogIsActive")"
    if [ -n "${sv_Value}" ]
    then
      GLB_BV_LOGISACTIVE=${sv_Value}
    fi
  
    # Get a value from the global config
    sv_Value="$(GLB_SF_GETPLISTPROPERTY "${GLB_SV_SYSDEFAULTSCONFIGFILEPATH}" ":Sys-Defaults:Shared:MaxLogSizeBytes")"
    if [ -n "${sv_Value}" ]
    then
      GLB_IV_LOGSIZEMAXBYTES=${sv_Value}
    fi
  
    # Get a value from the global config
    sv_Value="$(GLB_SF_GETPLISTPROPERTY "${GLB_SV_SYSDEFAULTSCONFIGFILEPATH}" ":Sys-Defaults:Shared:LogLevelTrap")"
    if [ -n "${sv_Value}" ]
    then
      GLB_IV_LOGLEVELTRAP=${sv_Value}
    fi

    # Get a value from the global config
    sv_Value="$(GLB_SF_GETPLISTPROPERTY "${GLB_SV_SYSDEFAULTSCONFIGFILEPATH}" ":Sys-Defaults:Shared:NotifyLevelTrap")"
    if [ -n "${sv_Value}" ]
    then
      GLB_IV_NOTIFYLEVELTRAP=${sv_Value}
    fi
  
  fi

  # -- Get some info about the logged in user
  
  # Only allow specifying a different logged in user, if we are root
  if [ "${GLB_SV_RUNUSERNAME}" != "root" ]
  then
    GLB_SV_CONSOLEUSERNAME="${GLB_SV_RUNUSERNAME}"
  fi

  if test -n "${GLB_SV_CONSOLEUSERNAME}"
  then

    # Get user ID
    GLB_IV_CONSOLEUSERID="$(id -u ${GLB_SV_CONSOLEUSERNAME})"
  
    # Check if user is an admin (returns 'true' or 'false')
    if [ "$(dseditgroup -o checkmember -m "${GLB_SV_CONSOLEUSERNAME}" -n . admin | cut -d" " -f1)" = "yes" ]
    then
      GLB_BV_CONSOLEUSERISADMIN=${GLB_BC_TRUE}
    else
      GLB_BV_CONSOLEUSERISADMIN=${GLB_BC_FALSE}
    fi
  
    # Where would the user home normally be if it were local
    if [ "${GLB_SV_CONSOLEUSERNAME}" = "root" ]
    then
      GLB_SV_CONSOLEUSERLOCALHOMEDIRPATH="/var/root"
  
    else
      GLB_SV_CONSOLEUSERLOCALHOMEDIRPATH="/Users/${GLB_SV_CONSOLEUSERNAME}"
      
    fi
  
    # Get the User Home directory
    GLB_SV_CONSOLEUSERHOMEDIRPATH=$(eval echo ~${GLB_SV_CONSOLEUSERNAME})
    
    # Make sure that we got a valid home
    if test -n "$(echo ${GLB_SV_CONSOLEUSERHOMEDIRPATH} | grep '~')"
    then
      GLB_SV_CONSOLEUSERHOMEDIRPATH="/Users/${GLB_SV_CONSOLEUSERNAME}"
    fi
  
    # Decide whether the user home is on the local drive
    if test -n "$(stat -f "%Sd" "${GLB_SV_CONSOLEUSERHOMEDIRPATH}" | grep "^disk")"
    then
      GLB_BV_CONSOLEUSERHOMEISLOCAL=${GLB_BC_TRUE}
      GLB_SV_CONSOLEUSERLOCALHOMEDIRPATH="${GLB_SV_CONSOLEUSERHOMEDIRPATH}"
      
    else
      GLB_BV_CONSOLEUSERHOMEISLOCAL=${GLB_BC_FALSE}
      
    fi
  
    # Check if user is a local account (returns 'true' or 'false')
    if [ "$(dseditgroup -o checkmember -m "${GLB_SV_CONSOLEUSERNAME}" -n . localaccounts | cut -d" " -f1)" = "yes" ]
    then
      GLB_BV_CONSOLEUSERISLOCAL=${GLB_BC_TRUE}
    else
      GLB_BV_CONSOLEUSERISLOCAL=${GLB_BC_FALSE}
    fi
  
    #  Get the local accounts 'OriginalHomeDirectory' property
    sv_Value=$(GLB_SF_GETDIRECTORYOBJECTATTRVALUE "/Local/Default/Users" "${GLB_SV_CONSOLEUSERNAME}" "OriginalHomeDirectory")
    if [ "${sv_Value}" = "ERROR" ]
    then
      sv_Value=""
    fi

    if test -n "${sv_Value}"
    then
      GLB_BV_CONSOLEUSERISMOBILE=${GLB_BC_TRUE}
    else
      GLB_BV_CONSOLEUSERISMOBILE=${GLB_BC_FALSE}
    fi
  
    # Get the network defined home directory
    if [ "${GLB_BV_CONSOLEUSERISLOCAL}" = ${GLB_BC_FALSE} ]
    then
      # - Network account -
  
      # Get UserHomeNetworkURI 
      # eg: smb://yourserver.com/staff/t/testuser
      # or  smb://yourserver.com/Data/Student%20Homes/Active/teststudent
  
      #  Get 'SMBHome' property
      sv_Value=$(GLB_SF_GETDIRECTORYOBJECTATTRVALUE "/Search/Users" "${GLB_SV_CONSOLEUSERNAME}" "SMBHome")
      if [ "${sv_Value}" = "ERROR" ]
      then
        sv_Value=""
      fi
      
      # We are only interested in one entry
      sv_Value=$(echo ${sv_Value} | head -n1)
      
      if [ -n "${sv_Value}" ]
      then
        GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "SMBHome ${sv_Value}"
        # Check for characters that we may not have considered
        sv_CheckString=$(GLB_SF_URLENCODE "${sv_Value}" | sed 's|%5c|\\|g;s|%20| |g')
        if [ "${sv_CheckString}" != "${sv_Value}" ]
        then
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELWARN} "Unexpected characters in SMBHome property ${sv_Value}"
        fi
        # Prepend the preferred protocol
        sv_PropertyString="Network protocol to be used";sv_protocol=$(dsconfigad -show | grep "${sv_PropertyString}" | cut -d "=" -f2 | sed "s|^[ ]*||;s|[ ]*$||")
        if test -z "${sv_protocol}"
        then
          sv_protocol="smb"
        fi
        GLB_SV_CONSOLEUSERSHAREURI=$(GLB_SF_URLENCODE "${sv_Value}" | sed "s|%5c|/|g"| sed "s|^[/]*|${sv_protocol}://|")
        GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "GLB_SV_CONSOLEUSERSHAREURI ${GLB_SV_CONSOLEUSERSHAREURI}"

      else
        #  Get 'HomeDirectory' property
        sv_Value=$(GLB_SF_GETDIRECTORYOBJECTATTRVALUE "/Search/Users" "${GLB_SV_CONSOLEUSERNAME}" "HomeDirectory")
        if [ "${sv_Value}" = "ERROR" ]
        then
          sv_Value=""
        fi
      
        # We are only interested in one entry
        sv_Value=$(echo ${sv_Value} | head -n1)
      
        GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "HomeDirectory ${sv_Value}"
        GLB_SV_CONSOLEUSERSHAREURI=$(echo "${sv_Value}" | sed "s|<[^>]*>||g;s|/$||;s|^[^:]*:||")
        if test -z "${GLB_SV_CONSOLEUSERSHAREURI}"
        then
          #  Get 'OriginalHomeDirectory' property
          sv_Value=$(GLB_SF_GETDIRECTORYOBJECTATTRVALUE "/Search/Users" "${GLB_SV_CONSOLEUSERNAME}" "OriginalHomeDirectory")
          if [ "${sv_Value}" = "ERROR" ]
          then
            sv_Value=""
          fi
      
          # We are only interested in one entry
          sv_Value=$(echo ${sv_Value} | head -n1)
      
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "OriginalHomeDirectory ${sv_Value}"
          GLB_SV_CONSOLEUSERSHAREURI=$(echo "${sv_Value}" | sed "s|<[^>]*>||g;s|/$||;s|^[^:]*:||")    
        fi  
        GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "GLB_SV_CONSOLEUSERSHAREURI ${GLB_SV_CONSOLEUSERSHAREURI}"
      fi
    
      if test -n "${GLB_SV_CONSOLEUSERSHAREURI}"
      then
        # Get full path to the network HomeDirectory 
        # ie: /Volumes/staff/t/testuser
        # or  /Volumes/Data/Student Homes/Active_Q2/pal/teststudpal
        while read sv_MountEntry
        do
          sv_MountPoint=$(echo ${sv_MountEntry} | sed -E 's|(^.*) on (.*) (\(.*\))|\2|' | grep -v '^/$')
          sv_MountShare=$(echo ${sv_MountEntry} | sed -E 's|(^.*) on (.*) (\(.*\))|\1|' | sed 's|'${GLB_SV_CONSOLEUSERNAME}'@||')
          if test -n "$(echo "${GLB_SV_CONSOLEUSERSHAREURI}" | sed "s|^[^:]*:||" | grep -E "^${sv_MountShare}")"
          then
            sv_ConsoleUserHomeNetworkDirPath=$(GLB_SF_URLDECODE "${sv_MountPoint}$(echo ${GLB_SV_CONSOLEUSERSHAREURI} | sed "s|^[^:]*:||;s|^"${sv_MountShare}"||")")
            if test -e "${sv_ConsoleUserHomeNetworkDirPath}"
            then
              GLB_SV_CONSOLEUSERSHAREDIRPATH="${sv_ConsoleUserHomeNetworkDirPath}"
              break
            fi
          fi
        done < <(mount | grep "//${GLB_SV_CONSOLEUSERNAME}@")
      
      fi
    fi
    
    GLB_SV_CONSOLEUSERINFO="${GLB_SV_CONSOLEUSERNAME};${GLB_IV_CONSOLEUSERID};${GLB_BV_CONSOLEUSERISADMIN};${GLB_BV_CONSOLEUSERISLOCAL};${GLB_BV_CONSOLEUSERISMOBILE};${GLB_BV_CONSOLEUSERHOMEISLOCAL};${GLB_SV_CONSOLEUSERHOMEDIRPATH};${GLB_SV_CONSOLEUSERLOCALHOMEDIRPATH};${GLB_SV_CONSOLEUSERSHAREURI};${GLB_SV_CONSOLEUSERSHAREDIRPATH}"
    GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "GLB_SV_CONSOLEUSERINFO ${GLB_SV_CONSOLEUSERINFO}"

  fi

  # ---
  
  GLB_SV_COMPUTERCONFIGDIRPATH="/Library/Preferences/${GLB_SC_PROJECTSIGNATURE}/V${GLB_SC_PROJECTMAJORVERSION}/Computers/localhost"

  # Decide the location of the preferences
  if [ "${GLB_SV_RUNUSERNAME}" = "root" ]
  then
    GLB_SV_RUNNINGCONFIGDIRPATH="${GLB_SV_COMPUTERCONFIGDIRPATH}"
  
  else
    GLB_SV_RUNNINGCONFIGDIRPATH=~/"Library/Preferences/${GLB_SC_PROJECTSIGNATURE}/V${GLB_SC_PROJECTMAJORVERSION}/Users/${GLB_SV_RUNUSERNAME}"
    
  fi
  
  # ---

  GLB_SV_LOGINFO="${GLB_BV_LOGISACTIVE};${GLB_IV_LOGLEVELTRAP};${GLB_IV_LOGSIZEMAXBYTES};${GLB_SV_LOGFILEPATH}"

  # ---

  GLB_BC_CORE_ISINCLUDED=${GLB_BC_TRUE}

fi
