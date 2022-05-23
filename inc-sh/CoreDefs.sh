#!/bin/bash
#
# Short:    Common routines (shell)
# Author:   Mark J Swift
# Version:  3.3.0
# Modified: 22-May-2022
#
# This include defines some global variables and functions that are used in core scripts and utilities.
# These variables and functions are not used the policy scripts, unless passed to the policy on the command line.
#
# Defines the following globals:
#
#  GLB_SV_COMPUTERCONFIGDIRPATH           - Directory for the computer prefs file
#  GLB_SV_RUNNINGCONFIGDIRPATH            - Directory for the running (user or computer) prefs file
#  GLB_SV_SYSDEFAULTSCONFIGFILEPATH       - Location of the system defaults file
#
#  GLB_BV_LOGISACTIVE                     - Whether we should log (true/false) 
#  GLB_IV_LOGSIZEMAXBYTES                 - Maximum length of LabWarden log(s)
#  GLB_IV_LOGLEVELTRAP                    - The logging level (see GLB_iv_MsgLevel...)
#  GLB_IV_NOTIFYLEVELTRAP                 - The user notify dialog level
#  GLB_SV_LOGINFO                         - LOGISACTIVE;LOGLEVELTRAP;LOGSIZEMAXBYTES;LOGFILEPATH
#
#
# Defines the following functions:
#
#  NONE
#
# Key:
#    GLB_ - global variable
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

if [ -z "${GLB_BC_COREDEFS_INCLUDED}" ]
then
  
  # Include the Base Defs library (if it is not already loaded)
  if [ -z "${GLB_BC_BASEDEFS_INCLUDED}" ]
  then
    . "${GLB_SV_PROJECTDIRPATH}"/inc-sh/BaseDefs.sh

    # Exit if something went wrong unexpectedly
    if [ -z "${GLB_BC_BASEDEFS_INCLUDED}" ]
    then
      echo >&2 "Something unexpected happened - '${0}' BASEDEFS"
      exit 90
    fi
  fi

  # ---
  
  # Include the constants library (if it is not already loaded)
  if [ -z "${GLB_BC_CORECONST_INCLUDED}" ]
  then
    . "${GLB_SV_PROJECTDIRPATH}"/inc-sh/CoreConst.sh

    # Exit if something went wrong unexpectedly
    if test -z "${GLB_BC_CORECONST_INCLUDED}"
    then
      echo >&2 "Something unexpected happened - '${0}' CORECONST"
      exit 90
    fi
  fi

  # By the time we get here, quite a few global variables have been set up.

  # ---

  if [ "${GLB_SV_RUNUSERNAME}" = "root" ]
  then

    # Delete previous version preferences
    if [ -e "/Library/Preferences/SystemConfiguration/com.github.execriez.labwarden" ]
    then
      rm -fR "/Library/Preferences/SystemConfiguration/com.github.execriez.labwarden"
    fi
   
  fi

  # ---

  # -- Begin Function Definition --


  # -- End Function Definition --
  
  GLB_SV_COMPUTERCONFIGDIRPATH="/Library/Preferences/${GLB_SC_PROJECTSIGNATURE}/V${GLB_SC_PROJECTMAJORVERSION}/Computers/localhost"

  # Decide the location of the preferences
  if [ "${GLB_SV_RUNUSERNAME}" = "root" ]
  then
    GLB_SV_RUNNINGCONFIGDIRPATH="${GLB_SV_COMPUTERCONFIGDIRPATH}"
  
  else
    GLB_SV_RUNNINGCONFIGDIRPATH=~/"Library/Preferences/${GLB_SC_PROJECTSIGNATURE}/V${GLB_SC_PROJECTMAJORVERSION}/Users/${GLB_SV_RUNUSERNAME}"
    
  fi
  
  # Location of the system defaults file
  GLB_SV_SYSDEFAULTSCONFIGFILEPATH="${GLB_SV_COMPUTERCONFIGDIRPATH}/Shared/Sys-Defaults.plist"
  
  # -- Read defaults from system globals
  
  if [ -f "${GLB_SV_SYSDEFAULTSCONFIGFILEPATH}" ]
  then
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

  GLB_SV_LOGINFO="${GLB_BV_LOGISACTIVE};${GLB_IV_LOGLEVELTRAP};${GLB_IV_LOGSIZEMAXBYTES};${GLB_SV_LOGFILEPATH}"

  # ---

  GLB_BC_COREDEFS_INCLUDED=${GLB_BC_TRUE}

fi
