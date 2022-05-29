#!/bin/bash
#
# Short:    Base routines (shell)
# Author:   Mark J Swift
# Version:  3.3.0
# Modified: 22-May-2022
#
# Defines base global variables and functions that are used in all project scripts.
#
# Should be included into scripts as follows:
#   . /usr/local/LabWarden/inc-sh/BaseDefs.sh
#

# Only INCLUDE the code if it isn't already included
if [ -z "${GLB_BC_BASEDEFS_INCLUDED}" ]
then
  
  # Defines the following globals:
  #
  #  GLB_BC_BASEDEFS_INCLUDED               - If true, this include is already included
  #
  #  GLB_SV_PROJECTDIRPATH                  - Root directory of this project
  #
  #  GLB_BV_LOGISACTIVE                     - Whether we should log (true/false) 
  #  GLB_IV_LOGSIZEMAXBYTES                 - Maximum length of LabWarden log(s)
  #  GLB_IV_LOGLEVELTRAP                    - The logging level (see GLB_iv_MsgLevel...)
  #  GLB_IV_NOTIFYLEVELTRAP                 - The user notify dialog level
  #  GLB_SV_LOGFILEPATH                     - Location of the active log file
  #
  #  GLB_SV_RUNUSERNAME                     - The name of the user that is running this script
  #  GLB_IV_RUNUSERID                       - The user ID of the user that is running this script
  #  GLB_BV_RUNUSERISADMIN                  - Whether the user running this script is an admin (true/false)
  #  GLB_SV_RUNUSERTEMPDIRPATH              - Temporary Directory for the current user
  #
  #  GLB_IV_THISSCRIPTSTARTEPOCH            - When the script started running
  #  GLB_SV_THISSCRIPTFILEPATH              - Full source path of running script
  #  GLB_SV_THISSCRIPTDIRPATH               - Directory location of running script
  #  GLB_SV_THISSCRIPTFILENAME              - filename of running script
  #  GLB_SV_THISSCRIPTNAME                  - Filename without extension
  #  GLB_IV_THISSCRIPTPID                   - Process ID of running script
  #  GLB_SV_THISSCRIPTTEMPDIRPATH           - Temporary Directory for the currently running script
  #
  #  GLB_SV_ARCH                            - Processor architecture, i.e. i386 or arm
  #  GLB_SV_MODELIDENTIFIER                 - Model ID, i.e. MacBookPro5,4
  #
  #  GLB_IV_BUILDVERSIONSTAMPASNUMBER       - The build version represented as a number, i.e. 14F1808 translates to 29745664
  #  GLB_SV_BUILDVERSIONSTAMPASSTRING       - The build version represented as a string, i.e. 14F1808
  #  GLB_IV_SYSTEMVERSIONSTAMPASNUMBER      - The system version represented as a number, i.e. 10.10.5 translates to 168428800
  #  GLB_SV_SYSTEMVERSIONSTAMPASSTRING      - The system version represented as a string, i.e. 10.10.5
  #
  #  GLB_SV_HOSTNAME                        - i.e. the workstation name
  #
  #
  # Defines the following base functions:
  #
  #  GLB_SF_URLENCODE <String>                                               - URL decode function - REFERENCE https://gist.github.com/cdown/1163649
  #  GLB_SF_URLDECODE <String>                                               - URL encode function - REFERENCE https://gist.github.com/cdown/1163649
  #  GLB_SF_EXPANDGLOBALSINSTRING <String>                                   - Replace %GLOBAL% references within a string with their GLB_GLOBAL values
  #  GLB_SF_LOGLEVEL <LogLevelInt>                                           - Convert log level integer into log level text
  #  GLB_NF_LOGMESSAGE <LogLevelInt> <MessageText>                           - Output message text to the log file
  #  GLB_NF_SHOWNOTIFICATION <LogLevelInt> <MessageText>                     - Show a pop-up notification
  #  GLB_BF_NAMEDLOCKGRAB <LockNameString> <MaxSecsInt> <SilentFlagBool>     - Grab a named lock
  #  GLB_NF_NAMEDLOCKRELEASE <LockNameString>                                - Release a named lock
  #  GLB_NF_NAMEDFLAGCREATE <FlagNameString>                                 - Create a named flag. FlagNameString can be anything you like.
  #  GLB_NF_NAMEDFLAGTEST <FlagNameString>                                   - Test if a named flag exists
  #  GLB_NF_NAMEDFLAGDELETE <FlagNameString>                                 - Delete a named flag
  #  GLB_SF_GETDIRECTORYOBJECTATTRVALUE <context> <name> <attr>              - Returns a directory attribute eg "/Search/Users" "SomeName" "HomeDirectory"
  #  GLB_IF_GETPLISTARRAYSIZE <plistfile> <property>                         - Get an array property size from a plist file
  #  GLB_NF_SETPLISTPROPERTY <plistfile> <property> <value>                  - Set a property to a value in a plist file
  #  GLB_NF_RAWSETPLISTPROPERTY<plistfile> <property> <value>                - Set a property to a value in a plist file, without checking that the value sticks
  #  GLB_SF_GETPLISTPROPERTY <plistfile> <property> [defaultvalue]           - Get a property value from a plist file
  #  GLB_SF_DELETEPLISTPROPERTY <plistfile> <property>                       - Delete a property from a plist file
  #
  #  Key:
  #    GLB_BASE_ - base global variable
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

  # Include the constants library (if it is not already loaded)
  if [ -z "${GLB_BC_BASECONST_INCLUDED}" ]
  then
    . "${GLB_SV_PROJECTDIRPATH}"/inc-sh/BaseConst.sh

    # Exit if something went wrong unexpectedly
    if test -z "${GLB_BC_BASECONST_INCLUDED}"
    then
      echo >&2 "Something unexpected happened - '${0}' BASECONST"
      exit 90
    fi
  fi

  # ---
  
  # -- Begin Function Definition --

  # URL decode function - REFERENCE https://gist.github.com/cdown/1163649
  GLB_SF_URLENCODE() {
      # urlencode <string>
  
      local length="${#1}"
      for (( i = 0; i < length; i++ )); do
          local c="${1:i:1}"
          case $c in
              [a-zA-Z0-9.~_-]) printf "$c" ;;
              *) printf '%s' "$c" | xxd -p -c1 |
                     while read c; do printf '%%%s' "$c"; done ;;
          esac
      done
  }
  
  # URL decode function - REFERENCE https://gist.github.com/cdown/1163649
  GLB_SF_URLDECODE() {
      # urldecode <string>
  
      local url_encoded="${1//+/ }"
      printf '%b' "${url_encoded//%/\\x}"
  }
    
  GLB_SF_EXPANDGLOBALSINSTRING() # ["some string containing %GLOBAL% vars"]
  {
    local sv_ExpandedString
    local sv_EmbeddedGlobalEscStr
    local sv_EmbeddedGlobalName
    local sv_EmbeddedGlobalValue
    
    sv_ExpandedString="${1}"
    sv_EmbeddedGlobalEscStr=$(echo "${sv_ExpandedString}" | sed "s|.*\(%[a-zA-Z][a-zA-Z0-9_]*%\).*|\1|" | grep "^%[a-zA-Z][a-zA-Z0-9_]*%$")
    while [ -n "${sv_EmbeddedGlobalEscStr}" ]
    do
      sv_EmbeddedGlobalName=$(echo "${sv_EmbeddedGlobalEscStr}" | sed "s|^%|\${GLB_|;s|%$|}|")
      sv_EmbeddedGlobalValue=$(eval echo ${sv_EmbeddedGlobalName})
      sv_ExpandedString="$(printf %s "${sv_ExpandedString}" | sed "s|"${sv_EmbeddedGlobalEscStr}"|"${sv_EmbeddedGlobalValue}"|")"
      sv_EmbeddedGlobalEscStr=$(echo "${sv_ExpandedString}" | sed "s|.*\(%[a-zA-Z][a-zA-Z0-9_]*%\).*|\1|" | grep "^%[a-zA-Z][a-zA-Z0-9_]*%$")
    done

    printf %s "${sv_ExpandedString}"
  }
  
  # Convert log level integer into log level text
  GLB_SF_LOGLEVEL()   # loglevel
  {  
    local iv_LogLevel
    local sv_LogLevel
    
    iv_LogLevel=${1}
    
    case ${iv_LogLevel} in
    ${GLB_IC_MSGLEVELEMERG})
      sv_LogLevel="Emergency"
      ;;
      
    ${GLB_IC_MSGLEVELALERT})
      sv_LogLevel="Alert"
      ;;
      
    ${GLB_IC_MSGLEVELCRIT})
      sv_LogLevel="Critical"
      ;;
      
    ${GLB_IC_MSGLEVELERR})
      sv_LogLevel="Error"
      ;;
      
    ${GLB_IC_MSGLEVELWARN})
      sv_LogLevel="Warning"
      ;;
      
    ${GLB_IC_MSGLEVELNOTICE})
      sv_LogLevel="Notice"
      ;;
      
    ${GLB_IC_MSGLEVELINFO})
      sv_LogLevel="Information"
      ;;
      
    ${GLB_IC_MSGLEVELDEBUG})
      sv_LogLevel="Debug"
      ;;
      
    *)
      sv_LogLevel="Unknown"
      ;;
      
    esac
    
    echo ${sv_LogLevel}
  }
  
  # Save a message to the log file
  GLB_NF_LOGMESSAGE()   # intloglevel strmessage
  {
    local iv_LogLevel
    local sv_Message
    local sv_LogDirPath
    local sv_LogFileName
    local sv_LogLevel
    local sv_WorkingDirPath
    local iv_LoopCount
    local iv_EmptyBackupIndex
    
    iv_LogLevel=${1}
    sv_Message="${2}"
    
    if [ -n "${GLB_SV_LOGFILEPATH}" ]
    then
    
      # Get dir of log file
      sv_LogDirPath="$(dirname "${GLB_SV_LOGFILEPATH}")"
  
      # Get filename of this script
      sv_LogFileName="$(basename "${GLB_SV_LOGFILEPATH}")"
  
      if test -z "${GLB_IV_LOGLEVELTRAP}"
      then
        # Use the hard-coded value if the value is not set
        GLB_IV_LOGLEVELTRAP=${GLB_IV_DFLTLOGLEVELTRAP}
      fi
    
      if [ "${GLB_BV_LOGISACTIVE}" = "${GLB_BC_TRUE}" ]
      then
        mkdir -p "${sv_LogDirPath}"

        if [ ${iv_LogLevel} -le ${GLB_IV_LOGLEVELTRAP} ]
        then
        
          # Backup log if it gets too big
          if [ -e "${GLB_SV_LOGFILEPATH}" ]
          then
            if [ $(stat -f "%z" "${GLB_SV_LOGFILEPATH}") -gt ${GLB_IV_LOGSIZEMAXBYTES} ]
            then
              if [ "$(GLB_BF_NAMEDLOCKGRAB "ManipulateLog" 0 ${GLB_BC_TRUE})" = ${GLB_BC_TRUE} ]
              then
                mv -f "${GLB_SV_LOGFILEPATH}" "${GLB_SV_LOGFILEPATH}.bak"
                for (( iv_LoopCount=0; iv_LoopCount<=8; iv_LoopCount++ ))
                do
                  if [ ! -e "${GLB_SV_LOGFILEPATH}.${iv_LoopCount}.tgz" ]
                  then
                    break
                  fi
                done
    
                iv_EmptyBackupIndex=${iv_LoopCount}
    
                for (( iv_LoopCount=${iv_EmptyBackupIndex}; iv_LoopCount>0; iv_LoopCount-- ))
                do
                  mv -f "${GLB_SV_LOGFILEPATH}.$((${iv_LoopCount}-1)).tgz" "${GLB_SV_LOGFILEPATH}.${iv_LoopCount}.tgz"
                done
    
                sv_WorkingDirPath="$(pwd)"
                cd "${sv_LogDirPath}"
                tar -czf "${sv_LogFileName}.0.tgz" "${sv_LogFileName}.bak"
                rm -f "${sv_LogFileName}.bak"
                cd "${sv_WorkingDirPath}"
              fi
              GLB_NF_NAMEDLOCKRELEASE "ManipulateLog"
            fi
          fi
  
          # Make the log entry
          sv_LogLevel="$(GLB_SF_LOGLEVEL ${iv_LogLevel})"
          echo "$(date '+%d %b %Y %H:%M:%S %Z') ${GLB_SV_THISSCRIPTFILENAME}[${GLB_IV_THISSCRIPTPID}]${GLB_SV_CODEVERSION}: ${sv_LogLevel}: ${sv_Message}"  >> "${GLB_SV_LOGFILEPATH}"
          echo >&2 "$(date '+%d %b %Y %H:%M:%S %Z') ${GLB_SV_THISSCRIPTFILENAME}[${GLB_IV_THISSCRIPTPID}]${GLB_SV_CODEVERSION}: ${sv_LogLevel}: ${sv_Message}"

        fi
      fi
    fi    
  }
  
  # Show a pop-up notification
  GLB_NF_SHOWNOTIFICATION() # loglevel Text
  {
    local iv_LogLevel
    local sv_Text
    local sv_LogLevel
    
    iv_LogLevel=${1}
    sv_Text="${2}"
  
    sv_LogLevel="$(GLB_SF_LOGLEVEL ${iv_LogLevel})"
  
    GLB_NF_LOGMESSAGE ${iv_LogLevel} "${sv_Text}"
  
    /usr/bin/osascript << EOF
display notification "${sv_Text}" with title "${sv_LogLevel}"
EOF

  }

  GLB_BF_NAMEDLOCKGRAB() # ; LockName [MaxSecs] [SilentFlag]; 
  # LockName can be anything 
  # MaxSecs is the max number of secs to wait for lock
  # SilentFlag, if true then lock waits and failures is not logged
  # Returns 'true' or 'false'
  {
    local sv_LockName
    local sv_MaxSecs
    local sv_LockDirPath
    local iv_Count
    local sv_ActiveLockPID
    local bv_Result
    local bv_SilentFlag

    sv_LockName="${1}"
    sv_MaxSecs="${2}"
    if test -z "${sv_MaxSecs}"
    then
      sv_MaxSecs=10
    fi
      
    bv_SilentFlag="${3}"
    if test -z "${bv_SilentFlag}"
    then
      bv_SilentFlag=${GLB_BC_FALSE}
    fi
    
    sv_LockDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}/Locks"
    mkdir -p "${sv_LockDirPath}"
 
    bv_Result=${GLB_BC_FALSE}
    while [ "${bv_Result}" = ${GLB_BC_FALSE} ]
    do
      if test -s "${sv_LockDirPath}/${sv_LockName}"
      then
        sv_ActiveLockPID="$(cat 2>/dev/null "${sv_LockDirPath}/${sv_LockName}" | head -n1)"
        if [ -z "$(ps -p ${sv_ActiveLockPID} -o pid= | tr -d " ")" ]
        then
          # If the active lock process doesn't exist, delete the lock
          rm -f "${sv_LockDirPath}/${sv_LockName}"
        fi
      fi
    
      if ! test -s "${sv_LockDirPath}/${sv_LockName}"
      then
        echo "${GLB_IV_THISSCRIPTPID}" >> "${sv_LockDirPath}/${sv_LockName}"
      fi
      # Ignore errors, because the file might disappear before we get a chance to do the cat
      sv_ActiveLockPID="$(cat 2>/dev/null "${sv_LockDirPath}/${sv_LockName}" | head -n1)"
      if [ "${sv_ActiveLockPID}" = "${GLB_IV_THISSCRIPTPID}" ]
      then
        if [ "${sv_LockName}" != "ManipulateLog" ]
        then
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Lock grab '${sv_LockName}'"
        fi
        bv_Result=${GLB_BC_TRUE}
        break
      fi
      
      iv_LockEpoch=$(stat 2>/dev/null -f "%m" "${sv_LockDirPath}/${sv_LockName}")
      if [ $? -gt 0 ]
      then
        # another task may have deleted the lock while we weren't looking
        iv_LockEpoch=$(date -u "+%s")
      fi
      if [ $(($(date -u "+%s")-${iv_LockEpoch})) -ge ${sv_MaxSecs} ]
      then
        if [ "${bv_SilentFlag}" = ${GLB_BC_FALSE} ]
        then
          if [ "${sv_LockName}" != "ManipulateLog" ]
          then
            GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Lock grab failed, another task is being greedy '${sv_LockName}'"
          fi
        fi
        break
      fi 
           
      if [ "${bv_SilentFlag}" = ${GLB_BC_FALSE} ]
      then
        if [ "${sv_LockName}" != "ManipulateLog" ]
        then
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Lock busy waiting... '${sv_LockName}'"
        fi
      fi
      sleep 1
    done
    
    echo "${bv_Result}"
  }  

  GLB_NF_NAMEDLOCKMEPOCH() # ; LockName
  {
    local sv_LockName
    local sv_LockDirPath
    local iv_LockEpoch

    sv_LockName="${1}"
    
    sv_LockDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}/Locks"

    if test -e "${sv_LockDirPath}/${sv_LockName}"
    then
      iv_LockEpoch=$(stat 2>/dev/null -f "%m" "${sv_LockDirPath}/${sv_LockName}")
      if [ $? -gt 0 ]
      then
        # another task may have deleted the lock while we weren't looking
        iv_LockEpoch=0
      fi
    else
      iv_LockEpoch=0
    fi
    
    echo ${iv_LockEpoch}
  }

  GLB_NF_NAMEDLOCKRELEASE() # ; LockName
  {
    local sv_LockName
    local sv_LockDirPath
    local sv_ActiveLockPID
    local bv_SilentFlag

    sv_LockName="${1}"

    sv_LockDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}/Locks"

    if test -s "${sv_LockDirPath}/${sv_LockName}"
    then
      sv_ActiveLockPID="$(cat 2>/dev/null "${sv_LockDirPath}/${sv_LockName}" | head -n1)"
      if [ "${sv_ActiveLockPID}" = "${GLB_IV_THISSCRIPTPID}" ]
      then
        if [ "${sv_LockName}" != "ManipulateLog" ]
        then
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Lock release '${sv_LockName}'"
        fi
        rm -f "${sv_LockDirPath}/${sv_LockName}"
      fi
    fi
  }  

  GLB_NF_NAMEDFLAGCREATE() # ; FlagName [epoch]
  # FlagName can be anything - LabWarden root user uses Restart, Shutdown
  {
    local sv_FlagName
    local sv_FlagDirPath

    sv_FlagName="${1}"
    sv_Epoch="${2}"
    
    sv_FlagDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}/Flags"
    mkdir -p "${sv_FlagDirPath}"
    
    if [ -z "${sv_Epoch}" ]
    then
      touch "${sv_FlagDirPath}/${sv_FlagName}"
    else
      touch -t $(date -r ${sv_Epoch} "+%Y%m%d%H%M.%S") "${sv_FlagDirPath}/${sv_FlagName}"
    fi
    
    chown "$(whoami)" "${sv_FlagDirPath}/${sv_FlagName}"
#    GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Flag create '${sv_FlagDirPath}/${sv_FlagName}'"
  }

  GLB_NF_NAMEDFLAGMEPOCH() # ; FlagName
  {
    local sv_FlagName
    local sv_FlagDirPath
    local iv_FlagEpoch

    sv_FlagName="${1}"
    
    sv_FlagDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}/Flags"

    if test -e "${sv_FlagDirPath}/${sv_FlagName}"
    then
      iv_FlagEpoch=$(stat -f "%m" "${sv_FlagDirPath}/${sv_FlagName}")
    else
      iv_FlagEpoch=0
    fi
    
    echo ${iv_FlagEpoch}
  }

  GLB_NF_NAMEDFLAGTEST()
  {
    local sv_FlagName
    local sv_FlagDirPath
    local sv_Result
    local sv_FlagOwner

    sv_FlagName="${1}"
    
    sv_FlagDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}/Flags"
    
#    GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Flag test '${sv_FlagDirPath}/${sv_FlagName}'"
    sv_Result=${GLB_BC_FALSE}
    if test -e "${sv_FlagDirPath}/${sv_FlagName}"
    then
      sv_FlagOwner=$(stat -f '%Su' "${sv_FlagDirPath}/${sv_FlagName}")
      if [ "${sv_FlagOwner}" = "$(whoami)" ]
      then
        sv_Result=${GLB_BC_TRUE}
      fi
    fi
    
    echo "${sv_Result}"
  }

  GLB_NF_NAMEDFLAGDELETE()
  {
    local sv_FlagName
    local sv_FlagDirPath

    sv_FlagName="${1}"
    
    sv_FlagDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}/Flags"
    
    rm -f "${sv_FlagDirPath}/${sv_FlagName}"
#    GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Flag delete '${sv_FlagDirPath}/${sv_FlagName}'"
  }
  
  # NOTE: if things go wrong, this function and code that uses this function, are good places to look
  GLB_SF_GETDIRECTORYOBJECTATTRVALUE()   # context name attr - eg "/Search/Users" "SomeName" "HomeDirectory"
 
  {
    local sv_ObjectContext
    local sv_ObjectName
    local sv_Attr
    local sv_Value
    local sv_Attr
  
    sv_ObjectContext="${1}"
    sv_ObjectName="${2}"
    sv_Attr="${3}"

    sv_Value="$(dscl 2>/dev/null localhost -read "${sv_ObjectContext}/${sv_ObjectName}" ${sv_Attr})"
    iv_Err=$?
    if [ ${iv_Err} -gt 0 ]
    then
      echo "ERROR"
      
    else
      echo "${sv_Value}" | sed "s|^[^:]*:${sv_Attr}:|${sv_Attr}:|" | tr -d "\r" | tr "\n" "\r" | sed 's|'${sv_Attr}':||'g | tail -n1 | tr "\r" "\n" | sed '/^\s*$/d' | sed 's|^[ ]*||'g

    fi
  }
  
  GLB_IF_GETPLISTARRAYSIZE()   # plistfile property - given an array property name, returns the size of the array 
  {
    local sv_PlistFilePath
    local sv_PropertyName
  
    sv_PlistFilePath="${1}"
    sv_PropertyName="${2}"
  
    /usr/libexec/PlistBuddy 2>/dev/null -c "Print ':${sv_PropertyName}'" "${sv_PlistFilePath}" | grep -E "^ " | grep -E "$(/usr/libexec/PlistBuddy 2>/dev/null -c "Print ':${sv_PropertyName}'" "${sv_PlistFilePath}" | grep -E "^ " | head -n1 | sed "s|\(^[ ]*\)\([^ ]*.*\)|\^\1\\[\^ }\]|")" | wc -l | sed "s|^[ ]*||"
  }

  # Set a property value in a plist file 
  GLB_NF_SETPLISTPROPERTY()   # plistfile property value
  {
    local sv_PlistFilePath
    local sv_PropertyName
    local sv_EntryValue
    local sv_StoredValue
    
    sv_PlistFilePath="${1}"
    sv_PropertyName="${2}"
    sv_EntryValue="${3}"

    GLB_NF_RAWSETPLISTPROPERTY "${sv_PlistFilePath}" "${sv_PropertyName}" "${sv_EntryValue}"
    
    # Check the stored value is not a special case
    if test -z "$(echo ${sv_EntryValue} | grep -E '^ARRAY$|^DICT$|^INTEGER$|^STRING$')"
    then
      sv_StoredValue=$(GLB_SF_GETPLISTPROPERTY "${sv_PlistFilePath}" "${sv_PropertyName}")
      if [ "${sv_StoredValue}" != "${sv_EntryValue}" ]
      then
        GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "Property value did not set at first attempt. File '${sv_PlistFilePath}' property '${sv_PropertyName}' value '${sv_EntryValue}'"

        # If the stored value doesn't match what we expect, try deleting first
        GLB_SF_DELETEPLISTPROPERTY "${sv_PlistFilePath}" "${sv_PropertyName}"

        # Set the value again
        GLB_NF_RAWSETPLISTPROPERTY "${sv_PlistFilePath}" "${sv_PropertyName}" "${sv_EntryValue}"    

        sv_StoredValue=$(GLB_SF_GETPLISTPROPERTY "${sv_PlistFilePath}" "${sv_PropertyName}")
        if [ "${sv_StoredValue}" = "${sv_EntryValue}" ]
        then
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "Property value did set OK at second attempt. File '${sv_PlistFilePath}' property '${sv_PropertyName}' value '${sv_EntryValue}'"
        else
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELERR} "Property value did not set. File '${sv_PlistFilePath}' property '${sv_PropertyName}' value '${sv_EntryValue}'"
        fi
      fi
    fi
  }

  # Set a property value in a plist file - without checking that the value sticks
  GLB_NF_RAWSETPLISTPROPERTY()   # plistfile property value
  {
    local sv_PlistFilePath
    local sv_PropertyName
    local sv_EntryValue
    local sv_EntryType
    local sv_ThisEntryIndex
    local sv_ThisEntryPath
    local sv_ThisEntryType
    local iv_EntryDepth
    local iv_LoopCount
    local iv_Nexti
    local sv_NextEntry
    local sv_SpecialCharList
    local sv_SpecialChar
    local iv_LoopCount
  
    sv_PlistFilePath="${1}"
    sv_PropertyName="${2}"
    sv_EntryValue="${3}"
    
    # Escape special characters
    sv_SpecialCharList='\"'"'"

    for (( iv_LoopCount=0; iv_LoopCount<${#sv_SpecialCharList}; iv_LoopCount++ ))
    do
      sv_SpecialChar="${sv_SpecialCharList:${iv_LoopCount}:1}"
      sv_EntryValue="$(echo "${sv_EntryValue}" | sed "s|\\${sv_SpecialChar}|\\\\\\${sv_SpecialChar}|g")"
    done

    # Discover Entry Value Type
    if test -n "$(echo ${sv_EntryValue} | grep -E '[^0-9]')"
    then
      if test -n "$(echo ${sv_EntryValue} | grep -iE '^True$|^False$')"
      then
        # value is a bool
        sv_EntryType="bool"
      else
        if test -n "$(echo ${sv_EntryValue} | grep -E '^ARRAY$|^DICT$|^INTEGER$|^STRING$')"
        then
          # value is special
          sv_EntryType="${sv_EntryValue}"
        else
          # value is a string
          sv_EntryType="string"
        fi
      fi
    else
      if test -n "${sv_EntryValue}"
      then
        # value is a integer
        sv_EntryType="integer"
      else
        # value is a string (null)
        sv_EntryType="string"
      fi
    fi
  
    # Create Entry path
    sv_ThisEntryPath=""
    iv_EntryDepth="$(echo "${sv_PropertyName}" | tr ":" "\n" | wc -l | sed "s|^[ ]*||")"
    for (( iv_LoopCount=2; iv_LoopCount<=${iv_EntryDepth}; iv_LoopCount++ ))
    do
      sv_ThisEntryIndex="$(echo "${sv_PropertyName}" | cut -d":" -f${iv_LoopCount} )"
      sv_ThisEntryPath="${sv_ThisEntryPath}:${sv_ThisEntryIndex}"
      if [ ${iv_LoopCount} -eq ${iv_EntryDepth} ]
      then
        sv_ThisEntryType=${sv_EntryType}
      else
        iv_Nexti=$((${iv_LoopCount}+1))
        sv_NextEntry="$(echo "${sv_PropertyName}" | cut -d":" -f${iv_Nexti} )"
        if test -n "$(echo ${sv_NextEntry} | grep -E '[^0-9]')"
        then
          sv_ThisEntryType="dict"  
        else
          sv_ThisEntryType="array" 
        fi
      fi
      /usr/libexec/PlistBuddy >/dev/null 2>&1 -c "Print '${sv_ThisEntryPath}'" "${sv_PlistFilePath}"
      if [ $? -ne 0 ]
      then
        /usr/libexec/PlistBuddy >/dev/null 2>&1 -c "Add '${sv_ThisEntryPath}' ${sv_ThisEntryType}" "${sv_PlistFilePath}"
      fi
    done
        
    # Set Entry Value (if its DICT then its already set)
    if [ "${sv_EntryValue}" != "DICT" ]
    then
      /usr/libexec/PlistBuddy >/dev/null 2>&1 -c "Set '${sv_PropertyName}' '${sv_EntryValue}'" "${sv_PlistFilePath}"
    fi
  #echo /usr/libexec/PlistBuddy -c "Set '${sv_PropertyName}' '${sv_EntryValue}'" "${sv_PlistFilePath}"
    if [ $? -ne 0 ]
    then
      GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELERR} "Property ${sv_PropertyName} in ${sv_PlistFilePath} may not have set correctly (or contains %GLOBALS%)"
    fi
  
  }
  
  # Get a property value from a plist file
  GLB_SF_GETPLISTPROPERTY()   # plistfile property [defaultvalue]
  {
    local sv_PlistFilePath
    local sv_PropertyName
    local sv_DefaultValue
    local sv_EntryValue
  
    sv_PlistFilePath="${1}"
    sv_PropertyName="${2}"
    sv_DefaultValue="${3}"
      
    sv_EntryValue=$(/usr/libexec/PlistBuddy 2>/dev/null -c "Print '${sv_PropertyName}'" "${sv_PlistFilePath}")
    if [ $? -ne 0 ]
    then
      if [ $# -eq 3 ]
      then
        GLB_NF_SETPLISTPROPERTY "${sv_PlistFilePath}" "${sv_PropertyName}" "${sv_DefaultValue}"
  
        sv_EntryValue=$(/usr/libexec/PlistBuddy 2>/dev/null -c "Print ':${sv_PropertyName}'" "${sv_PlistFilePath}")
        if [ $? -ne 0 ]
        then
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELERR} "Failed to get property ${sv_PropertyName} from ${sv_PlistFilePath}"
          sv_EntryValue=""
        fi
      else
        GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "Property ${sv_PropertyName} not found in ${sv_PlistFilePath}"
        sv_EntryValue=""
      fi
    fi
  
    if test -n "$(echo ${sv_EntryValue} | grep -iE '^True$|^False$')"
    then
      # value is a bool so make lower case for consistency
      sv_EntryValue="$(echo ${sv_EntryValue} | tr '[A-Z]' '[a-z]')"
    fi

    printf %s "$(GLB_SF_EXPANDGLOBALSINSTRING "${sv_EntryValue}")"
  }
  
  # Delete a property from a plist file
  GLB_SF_DELETEPLISTPROPERTY()   # plistfile property
  {
    local sv_PlistFilePath
    local sv_PropertyName
    local sv_EntryValue
  
    sv_PlistFilePath="${1}"
    sv_PropertyName="${2}"
      
    sv_EntryValue=$(/usr/libexec/PlistBuddy 2>/dev/null -c "Print '${sv_PropertyName}'" "${sv_PlistFilePath}")
    if [ $? -ne 0 ]
    then
      GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "Failed to delete property ${sv_PropertyName} from ${sv_PlistFilePath} - no such property exists"
      
    else
      /usr/libexec/PlistBuddy 2>/dev/null -c "Delete '${sv_PropertyName}'" "${sv_PlistFilePath}"
      if [ $? -ne 0 ]
      then
        GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELERR} "Failed to delete property ${sv_PropertyName} from ${sv_PlistFilePath}"
      fi
    fi
  }

  # -- End Function Definition --
  
  # Take a note when this script started running
  GLB_IV_THISSCRIPTSTARTEPOCH=$(date -u "+%s")
  
  # -- Get some info about this script
  
  # Full source of this script
  GLB_SV_THISSCRIPTFILEPATH="${0}"
  
  # Get dir of this script
  GLB_SV_THISSCRIPTDIRPATH="$(dirname "${GLB_SV_THISSCRIPTFILEPATH}")"
  
  # Get filename of this script
  GLB_SV_THISSCRIPTFILENAME="$(basename "${GLB_SV_THISSCRIPTFILEPATH}")"
  
  # Filename without extension
  GLB_SV_THISSCRIPTNAME="$(echo ${GLB_SV_THISSCRIPTFILENAME} | sed 's|\.[^.]*$||')"
  
  # Get Process ID of this script
  GLB_IV_THISSCRIPTPID=$$
  
  # -- Get some info about the running user
  
  # Get user name
  GLB_SV_RUNUSERNAME="$(whoami)"
  
  # Get user ID
  GLB_IV_RUNUSERID="$(id -u ${GLB_SV_RUNUSERNAME})"
  
  # Check if user is an admin (returns 'true' or 'false')
  if [ "$(dseditgroup -o checkmember -m "${GLB_SV_RUNUSERNAME}" -n . admin | cut -d" " -f1)" = "yes" ]
  then
    GLB_BV_RUNUSERISADMIN=${GLB_BC_TRUE}
  else
    GLB_BV_RUNUSERISADMIN=${GLB_BC_FALSE}
  fi

  # Get the Run User Home directory
  GLB_SV_RUNUSERHOMEDIRPATH=$(echo ~/)
  
  # -- Get workstation name
  
  GLB_SV_HOSTNAME=$(hostname -s)
  
  # -- Get some info about the hardware
  
  GLB_SV_ARCH=$(uname -p)
  
  GLB_SV_MODELIDENTIFIER=$(system_profiler SPHardwareDataType | grep "Model Identifier" | cut -d":" -f2 | tr -d " ")

  # -- Get some info about the OS

  # Last possible MacOS version is 255.255.255 unsurprisingly
  # Last possible build number is 2047Z2047z. 
  
  # Calculate BuildVersionStampAsNumber
  
  GLB_SV_BUILDVERSIONSTAMPASSTRING="$(sw_vers -buildVersion)"
  
  # Split build version (eg 14A379a) into parts (14,A,379,a). BuildMajorNum is the Darwin version
  # Starting 2001, there have been 20 BuildMajorNum in 20 years. So last build could be around the year 4048
  iv_BuildMajorNum=$(echo ${GLB_SV_BUILDVERSIONSTAMPASSTRING} | sed "s|[a-zA-Z][0-9]*||;s|[a-zA-Z]*$||")
  sv_BuildMinorChar=$(echo ${GLB_SV_BUILDVERSIONSTAMPASSTRING} | sed "s|^[0-9]*||;s|[0-9]*[a-zA-Z]*$||")
  iv_BuildRevisionNum=$(echo ${GLB_SV_BUILDVERSIONSTAMPASSTRING} | sed "s|^[0-9]*[a-zA-Z]||;s|[a-zA-Z]*$||")
  sv_BuildStageChar=$(echo ${GLB_SV_BUILDVERSIONSTAMPASSTRING} | sed "s|^[0-9]*[a-zA-Z][0-9]*||")
  
  iv_BuildMinorNum=$(($(printf "%d" "'${sv_BuildMinorChar}")-65))
  if [ -n "${sv_BuildStageChar}" ]
  then
    iv_BuildStageNum=$(($(printf "%d" "'${sv_BuildStageChar}")-96))
  else
    iv_BuildStageNum=0
  fi
  
  GLB_IV_BUILDVERSIONSTAMPASNUMBER=$((((${iv_BuildMajorNum}*32+${iv_BuildMinorNum})*2048+${iv_BuildRevisionNum})*32+${iv_BuildStageNum}))
  
  # Calculate SystemVersionStampAsNumber
  
  GLB_SV_SYSTEMVERSIONSTAMPASSTRING="$(sw_vers -productVersion)"
  
  GLB_IV_SYSTEMVERSIONSTAMPASNUMBER=0
  for iv_Num in $(echo ${GLB_SV_SYSTEMVERSIONSTAMPASSTRING}".0.0.0.0" | cut -d"." -f1-4 | tr "." "\n")
  do
    GLB_IV_SYSTEMVERSIONSTAMPASNUMBER=$((${GLB_IV_SYSTEMVERSIONSTAMPASNUMBER}*256+${iv_Num}))
  done
  
  # -- Get the number of CPU cores

  GLB_SV_HWNCPU="$(sysctl -n hw.ncpu)"
  
  # -- Get some info about logging

  # Use hard-coded defaults, these might be overwritten later 
  
  GLB_BV_LOGISACTIVE=${GLB_BV_DFLTLOGISACTIVE}
  GLB_IV_LOGSIZEMAXBYTES=${GLB_IV_DFLTLOGSIZEMAXBYTES}
  GLB_IV_LOGLEVELTRAP=${GLB_IV_DFLTLOGLEVELTRAP}
  GLB_IV_NOTIFYLEVELTRAP=${GLB_IV_DFLTNOTIFYLEVELTRAP}

  # If necessary, set the location of the log file
  
  if [ -z "${GLB_SV_LOGFILEPATH}" ]
  then
    if [ "${GLB_SV_RUNUSERNAME}" = "root" ]
    then
      GLB_SV_LOGFILEPATH="/Library/Logs/${GLB_SC_PROJECTSIGNATURE}.log"
  
    else
      GLB_SV_LOGFILEPATH="${GLB_SV_RUNUSERHOMEDIRPATH}/Library/Logs/${GLB_SC_PROJECTSIGNATURE}.log"
    
    fi
  fi

  # -- Create temporary directories
    
  # Create a temporary directory private to this user (and admins)
  GLB_SV_RUNUSERTEMPDIRPATH="/tmp/${GLB_SV_RUNUSERNAME}/${GLB_SC_PROJECTNAME}"
  if ! test -d "${GLB_SV_RUNUSERTEMPDIRPATH}"
  then
    mkdir -p "${GLB_SV_RUNUSERTEMPDIRPATH}"
    chown -R ${GLB_SV_RUNUSERNAME}:admin "/tmp/${GLB_SV_RUNUSERNAME}"
    chmod 770 "${GLB_SV_RUNUSERTEMPDIRPATH}"
  fi
  
  # Create a temporary directory private to this script
  GLB_SV_THISSCRIPTTEMPDIRPATH="$(mktemp -dq ${GLB_SV_RUNUSERTEMPDIRPATH}/${GLB_SV_THISSCRIPTFILENAME}-${GLB_IV_THISSCRIPTPID}-XXXXXXXX)"
  mkdir -p "${GLB_SV_THISSCRIPTTEMPDIRPATH}"
  
  # ---

  GLB_BC_BASEDEFS_INCLUDED=${GLB_BC_TRUE}

fi
