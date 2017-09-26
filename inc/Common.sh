#!/bin/bash
#
# Short:    Common routines (shell)
# Author:   Mark J Swift
# Version:  2.0.13
# Modified: 26-Jul-2017
#
# Should be included into scripts as follows:
#   . /usr/local/LabWarden/inc/Common.sh
#
# Take a look at the example policy scripts before getting bogged down with detail.
#  (AppExamplePolicy, SystemExamplePolicy and UserExamplePolicy)
#
# Enter with the following globals already defined
#  GLB_sv_LoggedInUserName                  - The name of the logged-in user. 
#                                           - A null string signifies no-one is logged in, or this is a system event that is unconcerned about who is logged in.
#                                           - The logged-in user may or may not be the user who is running the script
#
  
# Only run the code if it hasn't already been run
if test -z "${GLB_sv_ProjectSignature}"
then
  
  # Sets the following globals:
  #
  #  GLB_bv_UseLoginhook                    - Whether we should use the com.apple.loginwindow LoginHook & LogoutHook (true/false)
  #
  #  GLB_bv_LoadConfigsFromADnotes          - Whether we should load policy configs from the AD notes field (true/false)
  #
  #  GLB_bv_LogIsActive                     - Whether we should log (true/false) 
  #  GLB_iv_MaxLogSizeBytes                 - Maximum length of LabWarden log(s)
  #
  #  GLB_iv_LogLevelTrap                    - Sets the logging level (see GLB_iv_MsgLevel...)
  #  GLB_iv_NotifyLevelTrap                 - Set the user notify dialog level
  #
  #  GLB_iv_GPforceAgeMinutes               - How old the policies need to be for gpupdate -force to do updates
  #  GLB_iv_GPquickAgeMinutes               - How old the policies need to be for gpupdate -quick to do updates
  #  GLB_iv_GPdefaultAgeMinutes             - How old the policies need to be for gpupdate to do updates
  #
  #  GLB_sv_BinDirPath                      - Path to binaries such as rsync or CocoaDialog
  #  GLB_sv_ProjectConfigDirPath            - Path to main LabWarden settings files
  #
  #  GLB_iv_LogLevelTrap                    - The default logging level
  #  GLB_bv_LogIsActive                     - Whether the log is currently active (true/false)
  #
  #  GLB_iv_ThisScriptStartEpoch            - When the script started running
  #  GLB_sv_ThisScriptFilePath              - Full source path of running script
  #  GLB_sv_ThisScriptDirPath               - Directory location of running script
  #  GLB_sv_ThisScriptFileName              - filename of running script
  #  GLB_sv_ThisScriptName                  - Filename without extension
  #  GLB_iv_ThisScriptPID                   - Process ID of running script
  #
  #  GLB_sv_ThisScriptTempDirPath           - Temporary Directory for the currently running script
  #
  #  GLB_sv_ThisUserTempDirPath             - Temporary Directory for the current user
  #  GLB_sv_ThisUserLogDirPath              - Directory where the user log is stored
  #  GLB_sv_ThisUserPrefDirPath             - Directory for user configs
  #
  #  GLB_sv_ThisUserName                    - The name of the user that is running this script
  #  GLB_iv_ThisUserID                      - The user ID of the user that is running this script
  #
  #  GLB_iv_LoggedInUserID                  - The user ID of the logged-in user
  #  GLB_bv_LoggedInUserIsAdmin             - Whether the logged-in user is an admin (true/false)
  #  GLB_bv_LoggedInUserIsLocal             - Whether the logged-in user account is local (true/false)
  #  GLB_bv_LoggedInUserIsMobile            - Whether the logged-in user account is mobile (true/false)
  #
  #  GLB_sv_LoggedInUserHomeDirPath         - Home directory for the logged-in user
  #  GLB_sv_LoggedInUserLocalHomeDirPath    - Local home directory for the logged-in user (in /Users)
  #  GLB_sv_LoggedInUserHomeNetworkDirPath  - Network home directory path, i.e. /Volumes/staff/t/testuser
  #  GLB_sv_LoggedInUserHomeNetworkURI      - Network home directory URI, i.e smb://yourserver.com/staff/t/testuser
  #  GLB_bv_LoggedInUserHomeIsLocal         - Whether the logged-in user home is on a local drive (true/false)
  #
  #                                         - The logged-in user may or may not be the user who is running the script
  #
  #  GLB_iv_BuildVersionStampAsNumber       - The build version represented as a number, i.e. 14F1808 translates to 29745664
  #  GLB_sv_BuildVersionStampAsString       - The build version represented as a string, i.e. 14F1808
  #  GLB_iv_SystemVersionStampAsNumber      - The system version represented as a number, i.e. 10.10.5 translates to 168428800
  #  GLB_sv_SystemVersionStampAsString      - The system version represented as a string, i.e. 10.10.5
  #
  #  GLB_sv_IPv4PrimaryService              - A uuid like 9804EAB2-718C-42A7-891D-79B73F91CA4B
  #  GLB_sv_NetworkServiceDHCPOption15      - The domain advertised by DHCP
  #  GLB_sv_NetworkServiceInterfaceName     - i.e. Wi-Fi
  #  GLB_sv_NetworkServiceInterfaceDevice   - i.e. en1
  #  GLB_sv_NetworkServiceInterfaceHardware - i.e. Airport
  #
  #  GLB_sv_Hostname                        - i.e. the workstation name
  #
  #  GLB_sv_ADComputerName                  - This should be the same as the workstation name
  #  GLB_sv_ADTrustAccount                  - This is the account used by the workstation for AD services - i.e. workstationname$
  #  GLB_sv_ADDomainNameFlat                - Flat AD domain, i.e. YOURDOMAIN
  #  GLB_sv_ADDomainNameDNS                 - FQ AD domain, i.e. yourdomain.yourcompany.com
  # And when GLB_sv_ThisUserName=root, the following global is defined
  #  GLB_sv_ADTrustPassword                 - This is the password used by the workstation for AD services
  #
  # Defines the following LabWarden functions:
  #
  #  GLB_if_SystemIdleSecs
  #  GLB_sf_urlencode <string>                                        - URL encode a string
  #  GLB_sf_urldecode <string>                                        - URL decode a string
  #  GLB_nf_logmessage <loglevel> <messagetxt>                        - Output message text to the log file
  #  GLB_nf_ShowNotification <Title> <Text>                           - Show a notification dialog
  #  GLB_nf_SetPlistProperty <plistfile> <property> <value>           - Set a property to a value in a plist file
  #  GLB_sf_GetPlistProperty <plistfile> <property> [defaultvalue]    - Get a property value from a plist file
  #  GLB_if_GetPlistArraySize <plistfile> <property>                  - Get an array property size from a plist file
  #  GLB_nf_schedule4epoch <TAG> <WAKETYPE> <EPOCH>                   - Schedule a wake or power on for a given epoch
  #  GLB_sf_ResolveFileURItoPath <fileuri>                            - Resolve a file URI to a local path (downloading the file if necessary)
  #  GLB_nf_QuickExit                                                 - Quickly exit a script
  #  GLB_nf_TriggeredList <ConfigPlist> <EventName>                   - Internal private function
  #  GLB_nf_TriggerEvent <eventHistory> <event> [OptionalParam]       - Internal private function
  #
  #  Key:
  #    GLB_ - LabWarden global variable
  #
  #    bv_ - string variable with the values "true" or "false"
  #    iv_ - integer variable
  #    sv_ - string variable
  #
  #    nf_ - null function    (doesn't return a value)
  #    bf_ - boolean function (returns string values "true" or "false"
  #    if_ - integer function (returns an integer value)
  #    sf_ - string function  (returns a string value)
  
  # ---
  
  # All code is run from a subdirectory within the main project directory
  GLB_sv_ProjectDirPath="$(dirname $(dirname ${0}))"

  # Load the contants, only if they are not already loaded
  if test -z "${GLB_sv_ProjectName}"
  then
    . "${GLB_sv_ProjectDirPath}"/inc/Constants.sh
  fi
  
  # -- Begin Function Definition --
  
  # Get seconds that mac mouse/keyboard is idle - thanks to https://github.com/CLCMacTeam/IdleLogout
  GLB_if_SystemIdleSecs()
  {
    echo $(($(ioreg -c IOHIDSystem | sed -e '/HIDIdleTime/ !{ d' -e 't' -e '}' -e 's/.* = //g' -e 'q') / 1000000000))
  }
  
  # urlencode/urldecode functions - thanks to https://gist.github.com/cdown/1163649
  GLB_sf_urlencode() {
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
  
  GLB_sf_urldecode() {
      # urldecode <string>
  
      local url_encoded="${1//+/ }"
      printf '%b' "${url_encoded//%/\\x}"
  }
  
  # Convert log level integer into log level text
  GLB_sf_LogLevel()   # loglevel
  {  
    local iv_LogLevel
    local sv_LogLevel
    
    iv_LogLevel=${1}
    
    case ${iv_LogLevel} in
    0)
      sv_LogLevel="Emergency"
      ;;
      
    1)
      sv_LogLevel="Alert"
      ;;
      
    2)
      sv_LogLevel="Critical"
      ;;
      
    3)
      sv_LogLevel="Error"
      ;;
      
    4)
      sv_LogLevel="Warning"
      ;;
      
    5)
      sv_LogLevel="Notice"
      ;;
      
    6)
      sv_LogLevel="Information"
      ;;
      
    7)
      sv_LogLevel="Debug"
      ;;
      
    *)
      sv_LogLevel="Unknown"
      ;;
      
    esac
    
    echo ${sv_LogLevel}
  }
  
  # Save a message to the log file
  GLB_nf_logmessage()   # loglevel messagetxt
  {  
    local iv_HalfLen
    local iv_LogLevel
    local sv_Message
    local sv_LogLevel
    
    iv_LogLevel=${1}
    sv_Message="${2}"
    
    if test -n "${GLB_sv_ThisUserLogDirPath}"
    then
      # Only log stuff if the log directory is set (should always be set)
      
      if test -z "${GLB_iv_LogLevelTrap}"
      then
        # Use the hard-coded value if the value is not set
        GLB_iv_LogLevelTrap=${GLB_iv_LogLevelTrapDefault}
      fi
    
      if [ ${iv_LogLevel} -le ${GLB_iv_LogLevelTrap} ]
      then
        sv_LogLevel="$(GLB_sf_LogLevel ${iv_LogLevel})"
  
        if [ "${GLB_bv_LogIsActive}" = "true" ]
        then
          # Check if we need to start a new log
          if test -e "${GLB_sv_ThisUserLogDirPath}/${GLB_sv_ProjectSignature}.log"
          then
            if [ $(stat -f "%z" "${GLB_sv_ThisUserLogDirPath}/${GLB_sv_ProjectSignature}.log") -gt ${GLB_iv_MaxLogSizeBytes} ]
            then
              mv -f "${GLB_sv_ThisUserLogDirPath}/${GLB_sv_ProjectSignature}.log" "${GLB_sv_ThisUserLogDirPath}/${GLB_sv_ProjectSignature}.previous.log"
            fi
          fi
  
          echo "$(date '+%d %b %Y %H:%M:%S') ${GLB_sv_ThisScriptFileName}[${GLB_iv_ThisScriptPID}]: ${sv_LogLevel}: ${sv_Message}"  >> "${GLB_sv_ThisUserLogDirPath}/${GLB_sv_ProjectSignature}.log"
          echo >&2 "$(date '+%d %b %Y %H:%M:%S') ${GLB_sv_ThisScriptFileName}[${GLB_iv_ThisScriptPID}]: ${sv_LogLevel}: ${sv_Message}"
        fi
      fi
    fi
  }
  
  GLB_bf_GrabNamedLock() # ; Flag MaxSecs ; Flag can be Restart,Shutdown,ReloadFinder,ReloadDock Secs is max number of secs to wait for lock
  {
    local sv_Flag
    local sv_MaxSecs
    local sv_LockDirPath
    local iv_Count
    local sv_ActiveLockPID
    local bv_Result

    sv_Flag="${1}"
    sv_MaxSecs="${2}"
    
    if test -z "${sv_MaxSecs}"
    then
      sv_MaxSecs=10
    fi
      
    sv_LockDirPath="${GLB_sv_TempRoot}/Locks"
 
    bv_Result="false"
    while [ "${bv_Result}" = "false" ]
    do
      if ! test -s "${sv_LockDirPath}/${sv_Flag}"
      then
        echo "${GLB_iv_ThisScriptPID}" > "${sv_LockDirPath}/${sv_Flag}"
      fi
      sv_ActiveLockPID="$(cat "${sv_LockDirPath}/${sv_Flag}")"
      if [ "${sv_ActiveLockPID}" = "${GLB_iv_ThisScriptPID}" ]
      then
        GLB_nf_logmessage ${GLB_iv_MsgLevelNotice} "Grabbed lock '${sv_Flag}'"
        bv_Result="true"
        break
      fi
      
      iv_LockEpoch=$(stat -f "%m" "${sv_LockDirPath}/${sv_Flag}")
      if [ $(($(date -u "+%s")-${iv_LockEpoch})) -gt ${sv_MaxSecs} ]
      then
        GLB_nf_logmessage ${GLB_iv_MsgLevelNotice} "Grab lock failed, another task is being greedy '${sv_Flag}'"
        break
      fi 
           
      GLB_nf_logmessage ${GLB_iv_MsgLevelNotice} "Waiting for lock '${sv_Flag}'"
      sleep 1
    done
    
    echo "${bv_Result}"
  }  

  GLB_nf_ReleaseNamedLock() # ; Flag ; Flag can be Restart,Shutdown,ReloadFinder,ReloadDock Secs is max number of secs to wait for lock
  {
    local sv_Flag
    local sv_LockDirPath
    local sv_ActiveLockPID

    sv_Flag="${1}"
    
    sv_LockDirPath="${GLB_sv_TempRoot}/Locks"

    if test -s "${sv_LockDirPath}/${sv_Flag}"
    then
      sv_ActiveLockPID="$(cat "${sv_LockDirPath}/${sv_Flag}")"
      if [ "${sv_ActiveLockPID}" = "${GLB_iv_ThisScriptPID}" ]
      then
        GLB_nf_logmessage ${GLB_iv_MsgLevelNotice} "Releasing lock '${sv_Flag}'"
        rm -f "${sv_LockDirPath}/${sv_Flag}"
      fi
    fi
  }  

  GLB_nf_CreateNamedFlag()
  {
    local sv_Flag
    local sv_FlagDirPath

    sv_Flag="${1}"
    
    sv_FlagDirPath="${GLB_sv_TempRoot}/Flags"
    touch "${sv_FlagDirPath}/${sv_Flag}"
    chown "$(whoami)" "${sv_FlagDirPath}/${sv_Flag}"
#    GLB_nf_logmessage ${GLB_iv_MsgLevelInfo} "Creating flag '${sv_FlagDirPath}/${sv_Flag}'"
  }

  GLB_nf_TestNamedFlag()
  {
    local sv_Flag
    local sv_FlagDirPath
    local sv_Result
    local sv_FlagOwner

    sv_Flag="${1}"
    
    sv_FlagDirPath="${GLB_sv_TempRoot}/Flags"
    
#    GLB_nf_logmessage ${GLB_iv_MsgLevelInfo} "Testing flag '${sv_FlagDirPath}/${sv_Flag}'"
    sv_Result="false"
    if test -e "${sv_FlagDirPath}/${sv_Flag}"
    then
      sv_FlagOwner=$(stat -f '%Su' "${sv_FlagDirPath}/${sv_Flag}")
      if [ "${sv_FlagOwner}" = "$(whoami)" ]
      then
        sv_Result="true"
      fi
    fi
    
    echo "${sv_Result}"
  }

  GLB_nf_DeleteNamedFlag()
  {
    local sv_Flag
    local sv_FlagDirPath

    sv_Flag="${1}"
    
    sv_FlagDirPath="${GLB_sv_TempRoot}/Flags"
    rm -f "${sv_FlagDirPath}/${sv_Flag}"
#    GLB_nf_logmessage ${GLB_iv_MsgLevelInfo} "Deleting flag '${sv_FlagDirPath}/${sv_Flag}'"
  }

  GLB_nf_QuickExit()   # Quickly exit the script 
  {
    if test -n "${1}"
    then
      GLB_nf_logmessage ${GLB_iv_MsgLevelWarn} "${1}"
    fi
    
    # Remove temporary files
    rm -fPR "${GLB_sv_ThisScriptTempDirPath}"
    
    exit 99
  }
  
  # Show a pop-up notification
  GLB_nf_ShowNotification() # loglevel Text
  {
    local iv_LogLevel
    local sv_Text
    local sv_CocoaDialogFilePath
    local sv_Result
    local sv_LogLevel
    
    iv_LogLevel=${1}
    sv_Text="${2}"
  
    sv_LogLevel="$(GLB_sf_LogLevel ${iv_LogLevel})"
  
    GLB_nf_logmessage ${sv_LogLevel} "${sv_Text}"
  
    case ${iv_LogLevel} in
    0)
      # Emergency (Red text, Grey background, Black border)
      sv_text_col="ffffff"
      sv_border_col="ff2020"
      sv_bckgnd_bot="4f4f4f"
      sv_bckgnd_top="4f4f4f"
      sv_icon="hazard"
      ;;
      
    1)
      # Alert (White text, Red background, Red border)
      sv_text_col="ffffff"
      sv_border_col="ff2020"
      sv_bckgnd_bot="800000"
      sv_bckgnd_top="800000"
      sv_icon="hazard"
      ;;
      
    2)
      # Critical (White text, Orange background, Orange border)
      sv_text_col="ffffff"
      sv_border_col="ff2020"
      sv_bckgnd_bot="a06020"
      sv_bckgnd_top="a06020"
      sv_icon="hazard"
      ;;
      
    3)
      # Error (Black text, Red background, Red border)
      sv_text_col="000000"
      sv_border_col="ff2020"
      sv_bckgnd_bot="ffd0d0"
      sv_bckgnd_top="ffe8e8"
      sv_icon="hazard"
      ;;
      
    4)
      # Warning (Black text, Orange background, Orange border)
      sv_text_col="000000"
      sv_border_col="d08000"
      sv_bckgnd_bot="ffe880"
      sv_bckgnd_top="ffe880"
      sv_icon="hazard"
      ;;
      
    5)
      # Notice (Black text, Green background, Green border)
      sv_text_col="000000"
      sv_border_col="008000"
      sv_bckgnd_bot="d0ffd0"
      sv_bckgnd_top="e8ffe8"
      sv_icon="info"
      ;;
      
    6)
      # Information (Black text, Blue background, Blue border)
      sv_text_col="000000"
      sv_border_col="000080"
      sv_bckgnd_bot="d0d0ff"
      sv_bckgnd_top="e8e8ff"
      sv_icon="info"
      ;;
      
    7)
      # Debug  (White text, Grey background, Black border)
      sv_text_col="000000"
      sv_border_col="000000"
      sv_bckgnd_bot="ffffff"
      sv_bckgnd_top="ffffff"
      sv_icon="info"
      ;;
      
    *)
      # Unknown   (White text, Grey background, Black border)
      sv_text_col="ffffff"
      sv_border_col="000000"
      sv_bckgnd_bot="4f4f4f"
      sv_bckgnd_top="4f4f4f"
      sv_icon="info"
      ;;
      
    esac
  
    sv_CocoaDialogFilePath="${GLB_sv_BinDirPath}/CocoaDialog.app/Contents/MacOS/CocoaDialog"
    if test -f "${sv_CocoaDialogFilePath}"
    then
      sv_Result=$("${sv_CocoaDialogFilePath}" bubble \
      --timeout "15" \
      --x-placement "center" \
      --y-placement "center" \
      --title "${sv_LogLevel}" \
      --text "${sv_Text}" \
      --text-color "${sv_text_col}" \
      --border-color "${sv_border_col}" \
      --background-bottom "${sv_bckgnd_bot}" \
      --background-top "${sv_bckgnd_top}" \
      --debug \
      --icon "${sv_icon}")
    fi
  
  }
  
  GLB_if_GetPlistArraySize()   # plistfile property - given an array property name, returns the size of the array 
  {
    local sv_PlistFilePath
    local sv_PropertyName
  
    sv_PlistFilePath="${1}"
    sv_PropertyName="${2}"
  
    /usr/libexec/PlistBuddy 2>/dev/null -c "Print ':${sv_PropertyName}'" "${sv_PlistFilePath}" | grep -E "^ " | grep -E "$(/usr/libexec/PlistBuddy 2>/dev/null -c "Print ':${sv_PropertyName}'" "${sv_PlistFilePath}" | grep -E "^ " | head -n1 | sed "s|\(^[ ]*\)\([^ ]*.*\)|\^\1\\[\^ }\]|")" | wc -l | sed "s|^[ ]*||"
  }
  
  # Set a property value in a plist file
  GLB_nf_SetPlistProperty()   # plistfile property value
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
  
    sv_PlistFilePath="${1}"
    sv_PropertyName="${2}"
    
    # We need to escape the escape character if we want to store it as expected
    sv_EntryValue="$(echo "${3}" | sed 's|\\|\\\\\\|g')"
  
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
      GLB_nf_logmessage ${GLB_iv_MsgLevelErr} "Failed to set property ${sv_PropertyName} in ${sv_PlistFilePath}"
    fi
  
  }
  
  # Get a property value from a plist file
  GLB_sf_GetPlistProperty()   # plistfile property [defaultvalue]
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
        GLB_nf_SetPlistProperty "${sv_PlistFilePath}" "${sv_PropertyName}" "${sv_DefaultValue}"
  
        sv_EntryValue=$(/usr/libexec/PlistBuddy 2>/dev/null -c "Print ':${sv_PropertyName}'" "${sv_PlistFilePath}")
        if [ $? -ne 0 ]
        then
          GLB_nf_logmessage ${GLB_iv_MsgLevelNotice} "Failed to get property ${sv_PropertyName} from ${sv_PlistFilePath}"
          sv_EntryValue=""
        fi
      else
        GLB_nf_logmessage ${GLB_iv_MsgLevelNotice} "Failed to get property ${sv_PropertyName} from ${sv_PlistFilePath}"
        sv_EntryValue=""
      fi
    fi
  
    printf %s "${sv_EntryValue}"
  }
  
  # Get a property value from a plist file
  GLB_sf_DeletePlistProperty()   # plistfile property
  {
    local sv_PlistFilePath
    local sv_PropertyName
    local sv_EntryValue
  
    sv_PlistFilePath="${1}"
    sv_PropertyName="${2}"
      
    sv_EntryValue=$(/usr/libexec/PlistBuddy 2>/dev/null -c "Print '${sv_PropertyName}'" "${sv_PlistFilePath}")
    if [ $? -ne 0 ]
    then
      GLB_nf_logmessage ${GLB_iv_MsgLevelNotice} "Failed to delete property ${sv_PropertyName} from ${sv_PlistFilePath} - no such property exists"
      
    else
      /usr/libexec/PlistBuddy 2>/dev/null -c "Delete '${sv_PropertyName}'" "${sv_PlistFilePath}"
      if [ $? -ne 0 ]
      then
        GLB_nf_logmessage ${GLB_iv_MsgLevelNotice} "Failed to delete property ${sv_PropertyName} from ${sv_PlistFilePath}"
      fi
    fi
  }

  # Schedule event for specified EPOCH time. Identify the event with a unique TAG.
  # WAKETYPE can be one of sleep, wake, poweron, shutdown, wakeorpoweron
  GLB_nf_schedule4epoch()   # TAG WAKETYPE EPOCH
  {
    local iv_SchedEpoch
    local sv_SchedLine
    local iv_NowEpoch
  
    sv_Tag=${1}
    sv_WakeType=${2}
    iv_SchedEpoch=${3}
  
    if [ ${GLB_iv_SystemVersionStampAsNumber} -ge 168558592]
    then
      sv_Tag="pmset"
      GLB_nf_logmessage ${GLB_iv_MsgLevelNotice} "Setting the 'owner' in a 'pmset sched' command does not appear to work on MacOS 10.12 and later"
    fi

    iv_NowEpoch=$(date -u "+%s")
  
    if [ ${iv_NowEpoch} -lt ${iv_SchedEpoch} ]
    then
      # Check there isnt a named scheduled already - ignored on 10.12 since owner not set correctly
      pmset -g sched | grep -i "${sv_WakeType}" | grep -i "${sv_Tag}" | tr -s " " | cut -d " " -f5-6 | while read sv_SchedLine
      do
        pmset schedule cancel ${sv_WakeType} "${sv_SchedLine}" "${sv_Tag}" 2>/dev/null
      done
  
      sv_SchedLine=$(date -r ${iv_SchedEpoch} "+%m/%d/%y %H:%M:%S")
      pmset schedule ${sv_WakeType} "${sv_SchedLine}" "${sv_Tag}"

      GLB_nf_logmessage ${GLB_iv_MsgLevelNotice} "Scheduled ${sv_WakeType} $(date -r ${iv_SchedEpoch} "+%Y%m%d-%H:%M.%S")"
    fi
  }
  
  # Takes a uri, and returns a local filename.
  # Remote files (http, ftp, smb), will be downloaded to a local file.
  # The returned filename may or may not exist
  # Has got quite complex - Wish it was simpler
  GLB_sf_ResolveFileURItoPath()   # fileuri - if fileuri ends in a / it is assumed to be a dir, otherwise it is assumed to be a file
  {
  
    local bv_IsDir
    local sv_DstFilePath
    local sv_ExistingMountDirPath
    local sv_FileURI
    local sv_Host
    local sv_KUser
    local sv_KprincipalAfter
    local sv_KprincipalBefore
    local sv_RemoteConn
    local sv_RemoteDirPath
    local sv_SrcFileName
    local sv_SrcFilePath
    local sv_SrcFileProtocol
    local sv_SrcMountDirPath
    local sv_SrvrConnHost
    local sv_SrvrConnPass
    local sv_SrvrConnString
    local sv_SrvrConnUser
    local sv_TempDirPath
      
    sv_FileURI=${1}
  
    sv_SrcFileProtocol=$(echo ${sv_FileURI} | cut -d ":" -f1)    
    sv_SrcFileName="$(basename "${sv_FileURI}")"
     
    if test -n "$(echo ${sv_FileURI} | grep -E ".*/$")"
    then
      bv_IsDir="true"
    else
      bv_IsDir="false"
    fi
  
    case "$sv_SrcFileProtocol" in
    file)
      sv_Host=$(echo $sv_FileURI | cut -d "/" -f3 | tr "[A-Z]" "[a-z]" )
      if [ "$sv_Host" = "localhost" -o "$sv_Host" = "" ]
      then
        sv_SrcFilePath="/"$(echo $sv_FileURI | cut -d "/" -f4-)
        sv_DstFilePath="${sv_SrcFilePath}"
      fi
      ;;
  
    http|https|ftp)
      sv_TempDirPath="$(mktemp -dq ${GLB_sv_ThisUserTempDirPath}/${GLB_sv_ThisScriptFileName}-Resolved-XXXXXXXX)"
      sv_DstFilePath="${sv_TempDirPath}/${sv_SrcFileName}"
        
      curl --max-time 120 --connect-timeout 10 -s -S "${sv_FileURI}" > "$sv_DstFilePath"
      if ! test -s "$sv_DstFilePath"
      then
        # if the file is empty, delete it
        rm -f "$sv_DstFilePath"
      fi
      ;;
  
    smb)
      # Get Kerberos principal before the mount
      sv_KprincipalBefore="$(klist 2>/dev/null | grep "Principal:" | head -n1 | cut -d":" -f2 | sed "s|^[ ]*||")"
      
      # Get Kerberos user (if any)
      sv_KUser="$(echo "${sv_KprincipalBefore}" | cut -d"@" -f1)"
  
      # Get User, Password & Host
      sv_SrvrConnString="$(echo ${sv_FileURI} | cut -d"/" -f3)"
      sv_SrvrConnHost="$(echo ${sv_SrvrConnString} | cut -sd"@" -f2)"
      if test -z "${sv_SrvrConnHost}"
      then
        sv_SrvrConnHost="${sv_SrvrConnString}"
        sv_SrvrConnPass=""
        if test -n "${sv_KUser}"
        then
          sv_SrvrConnUser="${sv_KUser}"
        else
          sv_SrvrConnUser="Guest"
          
          if [ "${GLB_sv_ThisUserName}" = "root" ]
          then
            if test -n "${GLB_sv_ADTrustAccount}"
            then
              sv_SrvrConnUser="${GLB_sv_ADTrustAccount}"
              sv_SrvrConnPass="${GLB_sv_ADTrustPassword}"   
            fi
          fi   
  
        fi
        
      else
        sv_SrvrConnString="$(echo ${sv_SrvrConnString} | cut -d"@" -f1)"
        sv_SrvrConnPass="$(echo ${sv_SrvrConnString} | cut -sd":" -f2)"
        if test -z "${sv_SrvrConnPass}"
        then
          sv_SrvrConnUser="${sv_SrvrConnString}"
          sv_SrvrConnPass=""
        else
          sv_SrvrConnUser="$(echo ${sv_SrvrConnString} | cut -d":" -f1)" 
        fi
      fi
      sv_SrvrConnPass=$(GLB_sf_urlencode "${sv_SrvrConnPass}")
  
      
      sv_RemoteDirPath="$(echo ${sv_FileURI} | cut -d "/" -f4- | sed "s|/$||")"
      if [ "${bv_IsDir}" = "false" ]
      then
        sv_RemoteDirPath="$(dirname "${sv_RemoteDirPath}")"
      fi    
      
      sv_ExistingMountDirPath=$(mount | grep " (smbfs," | grep -i "//${sv_SrvrConnUser}@${sv_SrvrConnHost}/${sv_RemoteDirPath}" | sed -E "s|(.*)(\(smbfs,).*|\1|;s|(.*) on (.*)|\2|;s|[ ]*$||")
  
  	if test -n "${sv_ExistingMountDirPath}"
  	then
  	  sv_SrcMountDirPath="${sv_ExistingMountDirPath}"
  	  
  	else
  	
  	  # Decide where we will mount the remote directory
        sv_SrcMountDirPath="$(mktemp -dq ${GLB_sv_ThisUserTempDirPath}/${GLB_sv_ThisScriptFileName}-Mount-XXXXXXXX)"
  
  	  # Build a connection string
        if test -z "${sv_SrvrConnUser}"
        then
          sv_RemoteConn="//${sv_SrvrConnHost}/${sv_RemoteDirPath}"
        else
          if test -z "${sv_SrvrConnPass}"
          then
            sv_RemoteConn="//${sv_SrvrConnUser}@${sv_SrvrConnHost}/${sv_RemoteDirPath}"
          else
            sv_RemoteConn="//${sv_SrvrConnUser}:${sv_SrvrConnPass}@${sv_SrvrConnHost}/${sv_RemoteDirPath}"
          fi
        fi
        
        # echo DEBUG /sbin/mount_smbfs -N "${sv_RemoteConn}" "${sv_SrcMountDirPath}"
        if ! /sbin/mount_smbfs 2>/dev/null -N "${sv_RemoteConn}" "${sv_SrcMountDirPath}"
        then
          # Mount failed
          
          # Make double sure it's not mounted
          if [ "$(stat -f%Sd "${sv_SrcMountDirPath}")" = "$(stat -f%Sd "/")" ]
          then
            # Only delete it if its empty
            rmdir "${sv_SrcMountDirPath}"
            sv_SrcMountDirPath=""
          fi
        fi    
      
      fi
  
      if test -n "${sv_SrcMountDirPath}"
      then
        # Remote directory is mounted
        sv_TempDirPath="$(mktemp -dq ${GLB_sv_ThisUserTempDirPath}/${GLB_sv_ThisScriptFileName}-Resolved-XXXXXXXX)"
        sv_DstFilePath="${sv_TempDirPath}/${sv_SrcFileName}"
        
        if [ "${bv_IsDir}" = "false" ]
        then
          # copy file
          if test -e "${sv_SrcMountDirPath}/${sv_SrcFileName}"
          then
            cp -p "${sv_SrcMountDirPath}/${sv_SrcFileName}" "${sv_DstFilePath}"
          fi
        else
          # copy directory
          mkdir -p "${sv_DstFilePath}"
          cp -pR "${sv_SrcMountDirPath}/" "${sv_DstFilePath}/"
        fi
  
      fi
      
      if test -z "${sv_ExistingMountDirPath}"
      then
        if test -n "${sv_SrcMountDirPath}"
        then
          # unmount mount, only if it didnt already exist
          # echo DEBUG /sbin/umount "${sv_SrcMountDirPath}"
          /sbin/umount "${sv_SrcMountDirPath}"
          
          # Make double sure it's not mounted
          if [ "$(stat -f%Sd "${sv_SrcMountDirPath}")" = "$(stat -f%Sd "/")" ]
          then
            # Only delete it if its empty
            rmdir "${sv_SrcMountDirPath}"
          fi
  
        fi
      fi
      
      # Get Kerberos principal after all this kerfuffle
      sv_KprincipalAfter="$(klist 2>/dev/null | grep "Principal:" | head -n1 | cut -d":" -f2 | sed "s|^[ ]*||")"
      
      # If there is a new Kerberos principal - destroy it
      if [ "${sv_KprincipalAfter}" != "${sv_KprincipalBefore}" ]
      then
        kdestroy
      fi
  
      ;;
  
    afp)
      ;;
  
    *)
      # assume that we were passed a path rather than a uri
      sv_DstFilePath="${sv_FileURI}"
      ;;
  
    esac	    
  
    if test -n "${sv_DstFilePath}"
    then
      # check that file exists
      if ! test -e "${sv_DstFilePath}"
      then
        sv_DstFilePath=""
      fi
    fi
      
    echo "${sv_DstFilePath}"
  }
  
  GLB_sf_PolicyFilePath() # <ConfigFilePath> <ConfigEntryName> - return path to policy given ConfigFilePath and ConfigEntryName
  {
    local sv_PolicyName
    local sv_ConfigFilePath
    local sv_ConfigEntryName
    local sv_PolicyFilePath
    
    sv_ConfigFilePath="${1}"
    sv_ConfigEntryName="${2}"
    
    sv_PolicyFilePath=""
   
    sv_PolicyName=$(GLB_sf_GetPlistProperty "${sv_ConfigFilePath}" ":${sv_ConfigEntryName}:Name")
    if test -n "${sv_PolicyName}"
    then
      sv_PolicyFilePath="/usr/local/${GLB_sv_ProjectName}/Custom-Policies/${sv_PolicyName}"
      if ! test -e "${sv_PolicyFilePath}"
      then
        sv_PolicyFilePath="/usr/local/${GLB_sv_ProjectName}/Policies/${sv_PolicyName}"
        if ! test -e "${sv_PolicyFilePath}"
        then
          sv_PolicyFilePath="/usr/local/${GLB_sv_ProjectName}/Legacy-Policies/${sv_PolicyName}"
          if ! test -e "${sv_PolicyFilePath}"
          then
            sv_PolicyFilePath=""
          fi
        fi
      fi
    fi
    echo "${sv_PolicyFilePath}"
  }
  
  # List policies in config that are triggered by the event - Internal function used by GLB_nf_TriggerEvent
  GLB_nf_TriggeredList() # <ConfigPlist> <EventName>
  {
    local sv_ConfigPlist
    local sv_EventName
    local iv_DoesTriggerCount
    local iv_DoesTriggerIndex
    local sv_ConfigEntryName
    
    sv_ConfigPlist="${1}"
    sv_EventName="${2}"
    iv_DoesTriggerCount="$(GLB_if_GetPlistArraySize "${sv_ConfigPlist}" ":${sv_EventName}:DoesTrigger")"
    for (( iv_DoesTriggerIndex=0; iv_DoesTriggerIndex<${iv_DoesTriggerCount}; iv_DoesTriggerIndex++ ))
    do
      sv_ConfigEntryName=$(GLB_sf_GetPlistProperty "${sv_ConfigPlist}" ":${sv_EventName}:DoesTrigger:${iv_DoesTriggerIndex}")
      echo ${sv_ConfigEntryName}
    done
  }
  
  GLB_nf_TriggerEvent() # <eventHistory> <event> [OptionalParam]
  {
    local bv_EventHasPolicies
    local iv_DoesTriggerCount
    local sv_ConfigDirPath
    local sv_EventHistory
    local sv_EventName
    local sv_OptionalParam
    local sv_PolicyFilePath
    local sv_PolicyName
    local sv_ConfigEntryName
    local sv_Flag
    local sv_FlagDirPath
    
    # Get (full) event History
    sv_EventHistory="${1}"
  
    # Get event that triggered this policy
    sv_EventName="${2}"
  
    # Get optional parameter
    sv_OptionalParam="${3}"
   
    GLB_nf_logmessage ${GLB_iv_MsgLevelInfo} "Event occurred, '${sv_EventHistory}:${sv_EventName}' '${GLB_sv_LoggedInUserName}' '${sv_OptionalParam}' as user '${GLB_sv_ThisUserName}'"
  
    # Make sure a badly defined config doesnt put us in an endless trigger loop
    if test -n "$(echo ${sv_EventHistory} | tr ":" "\n" | grep -E "^"${sv_EventName}"$")"
    then
      GLB_nf_logmessage ${GLB_iv_MsgLevelErr} "Event loop in config."
      
    else
      bv_EventHasPolicies="false"
      
      if test -n "${GLB_sv_LoggedInUserName}"
      then
        # Run through the user policies
        sv_ConfigDirPath="${GLB_sv_ProjectConfigDirPath}/Config/Users/${GLB_sv_LoggedInUserName}"
        while read sv_ConfigEntryName
        do
          if test -n "${sv_ConfigEntryName}"
          then
            sv_ConfigFilePath="${sv_ConfigDirPath}/${sv_ConfigEntryName}.plist"
            sv_PolicyFilePath=$(GLB_sf_PolicyFilePath "${sv_ConfigFilePath}" "${sv_ConfigEntryName}")
            if test -n "${sv_PolicyFilePath}"
            then
              # Run script in background
              GLB_nf_logmessage ${GLB_iv_MsgLevelDebug} "Executing: '${sv_PolicyFilePath}' '${sv_ConfigFilePath}' '${sv_ConfigEntryName}' '${sv_EventHistory}:${sv_EventName}' '${GLB_sv_LoggedInUserName}' '${sv_OptionalParam}'"
              "${sv_PolicyFilePath}" "${sv_ConfigFilePath}" "${sv_ConfigEntryName}" "${sv_EventHistory}:${sv_EventName}" "${GLB_sv_LoggedInUserName}" "${sv_OptionalParam}" &
              bv_EventHasPolicies="true"
            fi
          fi
        done < <(GLB_nf_TriggeredList "${sv_ConfigDirPath}/${GLB_sv_ProjectName}-Events.plist" "${sv_EventName}" | sort -u)
      fi
  
      # Run through the workstation policies
      sv_ConfigDirPath="${GLB_sv_ProjectConfigDirPath}/Config/Computers/${GLB_sv_Hostname}"
      while read sv_ConfigEntryName
      do
        if test -n "${sv_ConfigEntryName}"
        then
          sv_ConfigFilePath="${sv_ConfigDirPath}/${sv_ConfigEntryName}.plist"
          sv_PolicyFilePath=$(GLB_sf_PolicyFilePath "${sv_ConfigFilePath}" "${sv_ConfigEntryName}")
          if test -n "${sv_PolicyFilePath}"
          then
            # Run script in background
            GLB_nf_logmessage ${GLB_iv_MsgLevelDebug} "Executing: '${sv_PolicyFilePath}' '${sv_ConfigFilePath}' '${sv_ConfigEntryName}' '${sv_EventHistory}:${sv_EventName}' '${GLB_sv_LoggedInUserName}' '${sv_OptionalParam}'"
            "${sv_PolicyFilePath}" "${sv_ConfigFilePath}" "${sv_ConfigEntryName}" "${sv_EventHistory}:${sv_EventName}" "${GLB_sv_LoggedInUserName}" "${sv_OptionalParam}" &
            bv_EventHasPolicies="true"
          fi
        fi
      done < <(GLB_nf_TriggeredList "${sv_ConfigDirPath}/${GLB_sv_ProjectName}-Events.plist" "${sv_EventName}" | sort -u)
      
      if [ "${bv_EventHasPolicies}" = "false" ]
      then
        GLB_nf_logmessage ${GLB_iv_MsgLevelInfo} "Event ignored, '${sv_EventHistory}:${sv_EventName}' '${GLB_sv_LoggedInUserName}' '${sv_OptionalParam}' as user '${GLB_sv_ThisUserName}' (no associated policy)"
      fi
    
      # We dont want to quit until the background scripts are finished or they might terminate early
      while [ -n "$(jobs -r)" ]
      do
        # we don't want to hog the CPU - so lets sleep a while
        GLB_nf_logmessage ${GLB_iv_MsgLevelDebug} "Waiting for events triggered by '${sv_EventHistory}:${sv_EventName}' to finish"
        sleep 1
      done

      if [ "$(GLB_nf_TestNamedFlag Restart)" = "true" ]
      then
        GLB_nf_logmessage ${GLB_iv_MsgLevelNotice} "Restarting workstation"
        shutdown -r now
      fi
      
      if [ "$(GLB_nf_TestNamedFlag Shutdown)" = "true" ]
      then
        GLB_nf_logmessage ${GLB_iv_MsgLevelNotice} "Shutting down workstation"
        shutdown -h now
      fi
  
    fi
  }
  
  # -- End Function Definition --
  
  # Take a note when this script started running
  GLB_iv_ThisScriptStartEpoch=$(date -u "+%s")
  
  # -- Get some info about this project
  
  # Decide where the config/pref files go
  GLB_sv_ProjectConfigDirPath="/Library/Preferences/SystemConfiguration/${GLB_sv_ProjectSignature}/V${GLB_sv_ProjectMajorVersion}"
  
  # Path to useful binaries
  GLB_sv_BinDirPath="/usr/local/${GLB_sv_ProjectName}/bin"
  
  # -- Set Defaults
  
  # Location of the system defaults file
  sv_SysDefaultsGlobalPrefFilePath="${GLB_sv_ProjectConfigDirPath}/Config/Global/Sys-Defaults.plist"

  if test -f "${sv_SysDefaultsGlobalPrefFilePath}"
  then
    # Get a value from the global config
    GLB_bv_LoadConfigsFromADnotes="$(GLB_sf_GetPlistProperty "${sv_SysDefaultsGlobalPrefFilePath}" ":Sys-Defaults:GlobalPrefs:LoadConfigsFromADnotes")"
    if test -z "${GLB_bv_LoadConfigsFromADnotes}"
    then
      # Use the hard-coded values if there is no global config entry
      GLB_bv_LoadConfigsFromADnotes=${GLB_bv_LoadConfigsFromADnotesDefault}
    fi
  
    # Get a value from the global config
    GLB_bv_UseLoginhook="$(GLB_sf_GetPlistProperty "${sv_SysDefaultsGlobalPrefFilePath}" ":Sys-Defaults:GlobalPrefs:UseLoginhook")"
    if test -z "${GLB_bv_UseLoginhook}"
    then
      # Use the hard-coded values if there is no global config entry
      GLB_bv_UseLoginhook=${GLB_bv_UseLoginhookDefault}
    fi
  
    # Get a value from the global config
    GLB_bv_LogIsActive="$(GLB_sf_GetPlistProperty "${sv_SysDefaultsGlobalPrefFilePath}" ":Sys-Defaults:GlobalPrefs:LogIsActive")"
    if test -z "${GLB_bv_LogIsActive}"
    then
      # Use the hard-coded values if there is no global config entry
      GLB_bv_LogIsActive=${GLB_bv_LogIsActiveDefault}
    fi
  
    # Get a value from the global config
    GLB_iv_MaxLogSizeBytes="$(GLB_sf_GetPlistProperty "${sv_SysDefaultsGlobalPrefFilePath}" ":Sys-Defaults:GlobalPrefs:MaxLogSizeBytes")"
    if test -z "${GLB_iv_MaxLogSizeBytes}"
    then
      # Use the hard-coded values if there is no global config entry
      GLB_iv_MaxLogSizeBytes=${GLB_iv_MaxLogSizeBytesDefault}
    fi
  
    # Get a value from the global config
    GLB_iv_LogLevelTrap="$(GLB_sf_GetPlistProperty "${sv_SysDefaultsGlobalPrefFilePath}" ":Sys-Defaults:GlobalPrefs:LogLevelTrap")"
    if test -z "${GLB_iv_LogLevelTrap}"
    then
      # Use the hard-coded values if there is no global config entry
      GLB_iv_LogLevelTrap=${GLB_iv_LogLevelTrapDefault}
    fi

    # Get a value from the global config
    GLB_iv_NotifyLevelTrap="$(GLB_sf_GetPlistProperty "${sv_SysDefaultsGlobalPrefFilePath}" ":Sys-Defaults:GlobalPrefs:NotifyLevelTrap")"
    if test -z "${GLB_iv_NotifyLevelTrap}"
    then
      # Use the hard-coded values if there is no global config entry
      GLB_iv_NotifyLevelTrap=${GLB_iv_NotifyLevelTrapDefault}
    fi
  
    # Get a value from the global config
    GLB_iv_GPforceAgeMinutes="$(GLB_sf_GetPlistProperty "${sv_SysDefaultsGlobalPrefFilePath}" ":Sys-Defaults:GlobalPrefs:GPforceAgeMinutes")"
    if test -z "${GLB_iv_GPforceAgeMinutes}"
    then
      # Use the hard-coded values if there is no global config entry
      GLB_iv_GPforceAgeMinutes=${GLB_iv_GPforceAgeMinutesDefault}
    fi
  
    # Get a value from the global config
    GLB_iv_GPquickAgeMinutes="$(GLB_sf_GetPlistProperty "${sv_SysDefaultsGlobalPrefFilePath}" ":Sys-Defaults:GlobalPrefs:GPquickAgeMinutes")"
    if test -z "${GLB_iv_GPquickAgeMinutes}"
    then
      # Use the hard-coded values if there is no global config entry
      GLB_iv_GPquickAgeMinutes=${GLB_iv_GPquickAgeMinutesDefault}
    fi
  
    # Get a value from the global config
    GLB_iv_GPdefaultAgeMinutes="$(GLB_sf_GetPlistProperty "${sv_SysDefaultsGlobalPrefFilePath}" ":Sys-Defaults:GlobalPrefs:GPdefaultAgeMinutes")"
    if test -z "${GLB_iv_GPdefaultAgeMinutes}"
    then
      # Use the hard-coded values if there is no global config entry
      GLB_iv_GPdefaultAgeMinutes=${GLB_iv_GPdefaultAgeMinutesDefault}
    fi
  
  else
    # Set whether we should use the loginhook
    GLB_bv_UseLoginhook=${GLB_bv_UseLoginhookDefault}
  
    # Set whether the log is on by default
    GLB_bv_LogIsActive=${GLB_bv_LogIsActiveDefault}
  
    # Set the maximum log size
    GLB_iv_MaxLogSizeBytes=${GLB_iv_MaxLogSizeBytesDefault}
  
    # Set the logging level
    GLB_iv_LogLevelTrap=${GLB_iv_LogLevelTrapDefault}

    # Set the user notify dialog level
    GLB_iv_NotifyLevelTrap=${GLB_iv_NotifyLevelTrapDefault}
  
    # gpupdate -force update value (default 1 minute)
    GLB_iv_GPforceAgeMinutes=${GLB_iv_GPforceAgeMinutesDefault}

    # gpupdate -quick update value (default 180 days)
    GLB_iv_GPquickAgeMinutes=${GLB_iv_GPquickAgeMinutesDefault}

    # gpupdate update value (default 1 day)
    GLB_iv_GPdefaultAgeMinutes=${GLB_iv_GPdefaultAgeMinutesDefault}
  
  fi

  # -- Get some info about this script
  
  # Full source of this script
  GLB_sv_ThisScriptFilePath="${0}"
  
  # Get dir of this script
  GLB_sv_ThisScriptDirPath="$(dirname "${GLB_sv_ThisScriptFilePath}")"
  
  # Get filename of this script
  GLB_sv_ThisScriptFileName="$(basename "${GLB_sv_ThisScriptFilePath}")"
  
  # Filename without extension
  GLB_sv_ThisScriptName="$(echo ${GLB_sv_ThisScriptFileName} | sed 's|\.[^.]*$||')"
  
  # Get Process ID of this script
  GLB_iv_ThisScriptPID=$$
  
  # -- Get some info about the running user
  
  # Get user name
  GLB_sv_ThisUserName="$(whoami)"
  
  # Get user ID
  GLB_iv_ThisUserID="$(id -u ${GLB_sv_ThisUserName})"
  
  # Only allow specifying a different logged in user, if we are root
  if [ "${GLB_sv_ThisUserName}" != "root" ]
  then
    GLB_sv_LoggedInUserName="${GLB_sv_ThisUserName}"
  fi
  
  # -- Get some info about the OS
  
  # Last OS X version would probably be 10.255.25 (259Z2047)
  
  # Calculate BuildVersionStampAsNumber
  
  GLB_sv_BuildVersionStampAsString="$(sw_vers -buildVersion)"
  
  # Split build version (eg 14A379a) into parts (14,A,379,a)
  iv_BuildMajorNum=$(echo ${GLB_sv_BuildVersionStampAsString} | sed "s|[a-zA-Z][0-9]*||;s|[a-zA-Z]*$||")
  sv_BuildMinorChar=$(echo ${GLB_sv_BuildVersionStampAsString} | sed "s|^[0-9]*||;s|[0-9]*[a-zA-Z]*$||")
  iv_BuildRevisionNum=$(echo ${GLB_sv_BuildVersionStampAsString} | sed "s|^[0-9]*[a-zA-Z]||;s|[a-zA-Z]*$||")
  sv_BuildStageChar=$(echo ${GLB_sv_BuildVersionStampAsString} | sed "s|^[0-9]*[a-zA-Z][0-9]*||")
  
  iv_BuildMinorNum=$(($(printf "%d" "'${sv_BuildMinorChar}")-65))
  if [ -n "${sv_BuildStageChar}" ]
  then
    iv_BuildStageNum=$(($(printf "%d" "'${sv_BuildStageChar}")-96))
  else
    iv_BuildStageNum=0
  fi
  
  GLB_iv_BuildVersionStampAsNumber=$((((${iv_BuildMajorNum}*32+${iv_BuildMinorNum})*2048+${iv_BuildRevisionNum})*32+${iv_BuildStageNum}))
  
  # Calculate SystemVersionStampAsNumber
  
  GLB_sv_SystemVersionStampAsString="$(sw_vers -productVersion)"
  
  GLB_iv_SystemVersionStampAsNumber=0
  for iv_Num in $(echo ${GLB_sv_SystemVersionStampAsString}".0.0.0.0" | cut -d"." -f1-4 | tr "." "\n")
  do
    GLB_iv_SystemVersionStampAsNumber=$((${GLB_iv_SystemVersionStampAsNumber}*256+${iv_Num}))
  done
  
  # -- Get some info about the logged in user
  
  if test -n "${GLB_sv_LoggedInUserName}"
  then
  
    # Get user ID
    GLB_iv_LoggedInUserID="$(id -u ${GLB_sv_LoggedInUserName})"
  
    # Check if user is an admin (returns "true" or "false")
    if [ "$(dseditgroup -o checkmember -m "${GLB_sv_LoggedInUserName}" -n . admin | cut -d" " -f1)" = "yes" ]
    then
      GLB_bv_LoggedInUserIsAdmin="true"
    else
      GLB_bv_LoggedInUserIsAdmin="false"
    fi
  
    # Check if user is a local account (returns "true" or "false")
    if [ "$(dseditgroup -o checkmember -m "${GLB_sv_LoggedInUserName}" -n . localaccounts | cut -d" " -f1)" = "yes" ]
    then
      GLB_bv_LoggedInUserIsLocal="true"
    else
      GLB_bv_LoggedInUserIsLocal="false"
    fi
  
  #  if test -n "$(dscl 2>/dev/null localhost -read /Local/Default/Users/${GLB_sv_LoggedInUserName} OriginalHomeDirectory)"
    sv_Attr="OriginalHomeDirectory";sv_Value="$(dscl 2>/dev/null localhost -read "/Local/Default/Users/${GLB_sv_LoggedInUserName}" ${sv_Attr})";iv_Err=$?;sv_Value="$(echo "${sv_Value}" | sed "s|^[^:]*:${sv_Attr}:| ${sv_Attr}: |" | tr -d "\r" | tr "\n" "\r" | sed 's| '${sv_Attr}': |\
  |'g | tail -n1 | tr "\r" "\n" | sed '/^\s*$/d')"
    if test -n "${sv_Value}"
    then
      GLB_bv_LoggedInUserIsMobile="true"
    else
      GLB_bv_LoggedInUserIsMobile="false"
    fi
  
    # Get the User Home directory
    GLB_sv_LoggedInUserHomeDirPath=$(eval echo ~${GLB_sv_LoggedInUserName})
    
    # Make sure that we got a valid home
    if test -n "$(echo ${GLB_sv_LoggedInUserHomeDirPath} | grep '~')"
    then
      GLB_sv_LoggedInUserHomeDirPath="/Users/${GLB_sv_LoggedInUserName}"
    fi
  
    # Decide whether the user home is on the local drive
    if test -n "$(stat -f "%Sd" "${GLB_sv_LoggedInUserHomeDirPath}" | grep "^disk")"
    then
      GLB_bv_LoggedInUserHomeIsLocal="true"
    else
      GLB_bv_LoggedInUserHomeIsLocal="false"
    fi
  
    # Get the network defined home directory
    if [ "${GLB_bv_LoggedInUserIsLocal}" = "false" ]
    then
      # - Network account -
  
      # Get UserHomeNetworkURI 
      # ie: smb://yourserver.com/staff/t/testuser
      # or  smb://yourserver.com/Data/Student%20Homes/Active_Q2/pal/teststudpal
  
  #    GLB_sv_LoggedInUserHomeNetworkURI=$(dscl 2>/dev/null localhost -read /Search/Users/${GLB_sv_LoggedInUserName} HomeDirectory | sed "s|HomeDirectory: ||;s|<[^>]*>||g;s|/$||;s|^[^:]*:||")
      sv_Attr="HomeDirectory";sv_Value="$(dscl 2>/dev/null localhost -read "/Search/Users/${GLB_sv_LoggedInUserName}" ${sv_Attr})";iv_Err=$?;sv_Value="$(echo "${sv_Value}" | sed "s|^[^:]*:${sv_Attr}:| ${sv_Attr}: |" | tr -d "\r" | tr "\n" "\r" | sed 's| '${sv_Attr}': |\
  |'g | tail -n1 | tr "\r" "\n" | sed '/^\s*$/d')"
      GLB_sv_LoggedInUserHomeNetworkURI=$(echo "${sv_Value}" | sed "s|<[^>]*>||g;s|/$||;s|^[^:]*:||")
      if test -z "${GLB_sv_LoggedInUserHomeNetworkURI}"
      then
  #      GLB_sv_LoggedInUserHomeNetworkURI=$(dscl 2>/dev/null localhost -read /Search/Users/${GLB_sv_LoggedInUserName} OriginalHomeDirectory | sed "s|OriginalHomeDirectory: ||;s|<[^>]*>||g;s|/$||")
        sv_Attr="OriginalHomeDirectory";sv_Value="$(dscl 2>/dev/null localhost -read "/Search/Users/${GLB_sv_LoggedInUserName}" ${sv_Attr})";iv_Err=$?;sv_Value="$(echo "${sv_Value}" | sed "s|^[^:]*:${sv_Attr}:| ${sv_Attr}: |" | tr -d "\r" | tr "\n" "\r" | sed 's| '${sv_Attr}': |\
  |'g | tail -n1 | tr "\r" "\n" | sed '/^\s*$/d')"
        GLB_sv_LoggedInUserHomeNetworkURI=$(echo "${sv_Value}" | sed "s|<[^>]*>||g;s|/$||;s|^[^:]*:||")
    
      fi  
    
      if test -n "${GLB_sv_LoggedInUserHomeNetworkURI}"
      then
        # The user home directory has been forced from the network to a local drive
  
        # Get full path to the network HomeDirectory 
        # ie: /Volumes/staff/t/testuser
        # or  /Volumes/Data/Student Homes/Active_Q2/pal/teststudpal
        while read sv_MountEntry
        do
          sv_MountPoint=$(echo ${sv_MountEntry} | sed -E 's|(^.*) on (.*) (\(.*\))|\2|' | grep -v '^/$')
          sv_MountShare=$(echo ${sv_MountEntry} | sed -E 's|(^.*) on (.*) (\(.*\))|\1|' | sed 's|'${GLB_sv_LoggedInUserName}'@||')
          if test -n "$(echo "${GLB_sv_LoggedInUserHomeNetworkURI}" | sed "s|^[^:]*:||" | grep -E "^${sv_MountShare}")"
          then
            sv_LoggedInUserHomeNetworkDirPath=$(GLB_sf_urldecode "${sv_MountPoint}$(echo ${GLB_sv_LoggedInUserHomeNetworkURI} | sed "s|^[^:]*:||;s|^"${sv_MountShare}"||")")
            if test -e "${sv_LoggedInUserHomeNetworkDirPath}"
            then
              GLB_sv_LoggedInUserHomeNetworkDirPath="${sv_LoggedInUserHomeNetworkDirPath}"
              break
            fi
          fi
        done < <(mount | grep "//${GLB_sv_LoggedInUserName}@")
      
      fi
    fi
  
    # Where would the user home normally be if it were local
    if [ "${GLB_sv_LoggedInUserName}" = "root" ]
    then
      GLB_sv_LoggedInUserLocalHomeDirPath="/var/root"
  
    else
      GLB_sv_LoggedInUserLocalHomeDirPath="/Users/${GLB_sv_LoggedInUserName}"
      
    fi
  
  fi
  
  
  # -- Get workstation name
  
  GLB_sv_Hostname=$(hostname -s)
  
  # -- Get AD workstation name (the name when it was bound)
  
  # Get Computer AD trust account - i.e. yourcomputername$
  GLB_sv_ADTrustAccount="$(dsconfigad 2>/dev/null -show | grep "Computer Account" | sed "s|\([^=]*\)=[ ]*\([^ ]*$\)|\2|")"
  
  # AD computer name (without the trailing dollar sign)
  GLB_sv_ADComputerName=$(echo ${GLB_sv_ADTrustAccount} | sed "s|\$$||")
  
  # ---
  
  # Get Computer full AD domain - i.e. yourdomain.yourcompany.com
  GLB_sv_ADDomainNameDNS="$(dsconfigad 2>/dev/null -show | grep "Active Directory Domain" | sed "s|\([^=]*\)=[ ]*\([^ ]*$\)|\2|")"
  
  # ---
  
  # If the workstation is bound to AD, make sure the computer name matches the AD object
  if test -n "${GLB_sv_ADComputerName}"
  then
    if [ "${GLB_sv_Hostname}" != "${GLB_sv_ADComputerName}" ]
    then
      GLB_sv_Hostname="${GLB_sv_ADComputerName}"
      /usr/sbin/systemsetup -setcomputername "${GLB_sv_ADComputerName}"
      /usr/sbin/scutil --set ComputerName "${GLB_sv_ADComputerName}"
      /usr/sbin/systemsetup -setlocalsubnetname "${GLB_sv_ADComputerName}"
      /usr/sbin/scutil --set LocalHostName "${GLB_sv_ADComputerName}"
      /usr/sbin/scutil --set HostName "${GLB_sv_ADComputerName}.${GLB_sv_ADDomainNameDNS}"
    
    fi
  fi
  
  # ---
  
  # The root of all temporary files
  GLB_sv_TempRoot="/tmp/${GLB_sv_ProjectName}"
  GLB_sv_TempUsersRoot="/tmp/${GLB_sv_ProjectName}/Users"
  
  # Create some temp folders
  if [ "${GLB_sv_ThisUserName}" = "root" ]
  then
    mkdir -p "${GLB_sv_TempRoot}"
    chown root:wheel "${GLB_sv_TempRoot}"
    chmod 1755 "${GLB_sv_TempRoot}"

    mkdir -p "${GLB_sv_TempUsersRoot}"
    chown root:wheel "${GLB_sv_TempUsersRoot}"
    chmod 1777 "${GLB_sv_TempUsersRoot}"

    mkdir -p "${GLB_sv_TempRoot}/Locks"
    chown root:wheel "${GLB_sv_TempRoot}/Locks"
    chmod 1777 "${GLB_sv_TempRoot}/Locks"

    mkdir -p "${GLB_sv_TempRoot}/Flags"
    chown root:wheel "${GLB_sv_TempRoot}/Flags"
    chmod 1755 "${GLB_sv_TempRoot}/Flags"
  fi
    
  # Create a temporary directory private to this user (and admins)
  GLB_sv_ThisUserTempDirPath=/${GLB_sv_TempUsersRoot}/${GLB_sv_ThisUserName}
  if ! test -d "${GLB_sv_ThisUserTempDirPath}"
  then
    mkdir -p "${GLB_sv_ThisUserTempDirPath}"
    chown ${GLB_sv_ThisUserName}:admin "${GLB_sv_ThisUserTempDirPath}"
    chmod 770 "${GLB_sv_ThisUserTempDirPath}"
  fi
  
  # Create a temporary directory private to this script
  GLB_sv_ThisScriptTempDirPath="$(mktemp -dq ${GLB_sv_ThisUserTempDirPath}/${GLB_sv_ThisScriptFileName}-XXXXXXXX)"
  
  # Decide where the config/pref/log files go
  if [ "${GLB_sv_ThisUserName}" = "root" ]
  then
    mkdir -p "${GLB_sv_ProjectConfigDirPath}/Config/Computers/${GLB_sv_Hostname}"
    GLB_sv_ThisUserLogDirPath="/Library/Logs"
    GLB_sv_ThisUserPrefDirPath="${GLB_sv_ProjectConfigDirPath}/Config/Computers/${GLB_sv_Hostname}"
  
  else
    GLB_sv_ThisUserLogDirPath="${GLB_sv_LoggedInUserHomeDirPath}/Library/Logs"
    GLB_sv_ThisUserPrefDirPath="${GLB_sv_LoggedInUserHomeDirPath}/Library/Preferences/${GLB_sv_ProjectSignature}/V${GLB_sv_ProjectMajorVersion}/${GLB_sv_ADComputerName}"
    
  fi
  
  mkdir -p "${GLB_sv_ThisUserPrefDirPath}"
  mkdir -p "${GLB_sv_ThisUserLogDirPath}"
  
  # ---
  
  # Get Computer short AD domain - i.e. YOURDOMAIN
  if test -n "${GLB_sv_ADDomainNameDNS}"
  then
    # If we have just started up, we may need to wait a short time while the system populates the scutil vars
    iv_DelayCount=0
    while [ ${iv_DelayCount} -lt 5 ]
    do
      GLB_sv_ADDomainNameFlat=$(echo "show com.apple.opendirectoryd.ActiveDirectory" | scutil | grep "DomainNameFlat" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
      if test -n "${GLB_sv_ADDomainNameFlat}"
      then
        break
      fi
  
      # we don't want to hog the CPU - so lets sleep a while
      GLB_nf_logmessage ${GLB_iv_MsgLevelNotice} "Waiting around until the scutil ActiveDirectory vars are populated"
      sleep 1
        
      iv_DelayCount=$((${iv_DelayCount}+1))
    done
  fi
  
  # --
  
  # Get Computer AD trust account password
  if test -n "${GLB_sv_ADTrustAccount}"
  then
    GLB_sv_ADTrustPassword=$(security find-generic-password -w -s "/Active Directory/${GLB_sv_ADDomainNameFlat}" /Library/Keychains/System.keychain)
  fi
  
  # -- Get Network info
  
  GLB_sv_IPv4PrimaryService=$(echo "show State:/Network/Global/IPv4" | scutil | grep "PrimaryService" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  if test -n "${GLB_sv_IPv4PrimaryService}"
  then
    # Get DHCP option 15 (domain)
    GLB_sv_NetworkServiceDHCPOption15=$(echo "show State:/Network/Service/${GLB_sv_IPv4PrimaryService}/DHCP" | scutil | grep "Option_15" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||" | sed -E "s/^<data> 0x//;s/00$//" | xxd -r -p)
  
    # Get user defined name - e.g. Wi-Fi
    GLB_sv_NetworkServiceInterfaceName=$(echo "show Setup:/Network/Service/${GLB_sv_IPv4PrimaryService}" | scutil | grep "UserDefinedName" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  
    # Get device name - e.g. en1
    GLB_sv_NetworkServiceInterfaceDevice=$(echo "show Setup:/Network/Service/${GLB_sv_IPv4PrimaryService}/Interface" | scutil | grep "DeviceName" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  
    # Get device hardware - e.g. Airport
    GLB_sv_NetworkServiceInterfaceHardware=$(echo "show Setup:/Network/Service/${GLB_sv_IPv4PrimaryService}/Interface" | scutil | grep "Hardware" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  fi
  
  # Get the the device name for wireless (eg en1)
  GLB_sv_WirelessInterfaceDevice="$(networksetup -listallhardwareports | tr "\n" ":" | sed "s|^[:]*||;s|::|;|g" | tr ";" "\n" | grep "Wi-Fi" | sed "s|\(.*Device:[ ]*\)\([^:]*\)\(.*\)|\2|" | head -n 1)"
  
  # ---
  
fi
