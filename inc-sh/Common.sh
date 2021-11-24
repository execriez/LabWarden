#!/bin/bash
#
# Short:    Common routines (shell)
# Author:   Mark J Swift
# Version:  3.2.16
# Modified: 06-Nov-2021
#
# This include defines some global variables and functions that could be used in any project script.
#
# These globals can be referenced within config payloads by the use of %% characters
# For example the global GLB_SV_ADDNSDOMAINNAME can be referenced like this %SV_ADDNSDOMAINNAME%
#
# Defines the following globals:
#
#  GLB_IV_THISSCRIPTSTARTEPOCH            - When the script started running
#  GLB_SV_THISSCRIPTDIRPATH               - Directory location of running script
#  GLB_SV_THISSCRIPTFILEPATH              - Full source path of running script
#  GLB_SV_THISSCRIPTFILENAME              - filename of running script
#  GLB_SV_THISSCRIPTNAME                  - Filename without extension
#  GLB_IV_THISSCRIPTPID                   - Process ID of running script
#
#  GLB_SV_THISSCRIPTTEMPDIRPATH           - Temporary Directory for the currently running script
#  GLB_SV_RUNUSERTEMPDIRPATH              - Temporary Directory for the current user
#
#  GLB_SV_RUNUSERNAME                     - The name of the user that is running this script
#  GLB_IV_RUNUSERID                       - The user ID of the user that is running this script
#  GLB_BV_RUNUSERISADMIN                  - Whether the user running this script is an admin (true/false)
#
#  GLB_SV_ARCH                            - Processor architecture, i.e. i386 or arm
#  GLB_SV_MODELIDENTIFIER                 - Model ID, i.e. MacBookPro5,4
#
#  GLB_IV_BUILDVERSIONSTAMPASNUMBER       - The build version represented as a number, i.e. 14F1808 translates to 29745664
#  GLB_SV_BUILDVERSIONSTAMPASSTRING       - The build version represented as a string, i.e. 14F1808
#  GLB_IV_SYSTEMVERSIONSTAMPASNUMBER      - The system version represented as a number, i.e. 10.10.5 translates to 168428800
#  GLB_SV_SYSTEMVERSIONSTAMPASSTRING      - The system version represented as a string, i.e. 10.10.5
#
#  GLB_SV_IPV4PRIMARYSERVICEUUID          - A uuid like 9804EAB2-718C-42A7-891D-79B73F91CA4B
#  GLB_SV_IPV4PRIMARYSERVICEDHCPOPTION15  - The domain advertised by DHCP
#  GLB_SV_IPV4PRIMARYSERVICEINTERFACENAME - i.e. Wi-Fi
#  GLB_SV_IPV4PRIMARYSERVICEDEVICENAME    - i.e. en1
#  GLB_SV_IPV4PRIMARYSERVICEHARDWARENAME  - i.e. Airport
#
#  GLB_SV_HOSTNAME                        - i.e. the workstation name
#
#  GLB_SV_ADFLATDOMAINNAME                - Flat AD domain, i.e. YOURDOMAIN
#  GLB_SV_ADDNSDOMAINNAME                 - FQ AD domain, i.e. yourdomain.yourcompany.com
#  GLB_SV_ADCOMPUTERNAME                  - This should be the same as the workstation name
#  GLB_SV_ADTRUSTACCOUNTNAME              - This is the account used by the workstation for AD services - i.e. workstationname$
#
# And when GLB_SV_RUNUSERNAME=root, the following global is also defined
#  GLB_SV_ADTRUSTACCOUNTPASSWORD          - This is the password used by the workstation for AD services
#
# These globals are set to the default values, if they are null
#  GLB_BV_LOGISACTIVE                     - Whether we should log (true/false) 
#  GLB_IV_LOGSIZEMAXBYTES                 - Maximum length of LabWarden log(s)
#  GLB_IV_LOGLEVELTRAP                    - The logging level (see GLB_iv_MsgLevel...)
#  GLB_IV_NOTIFYLEVELTRAP                 - The user notify dialog level
#  GLB_SV_LOGFILEPATH                     - Location of the active log file
#
# Defines the following LabWarden functions:
#
#  GLB_IF_SYSTEMIDLESECS                                                   - Get the number of seconds that there has been no mouse or keyboard activity
#  GLB_SF_ORIGINALFILEPATH <FilePathString>                                - Get the original file path; resolving any links
#  GLB_NF_SCHEDULE4EPOCH <TagString> <WakeTypeString> <EpochInt>           - Schedule a "wake" or "poweron" wake type for the given epoch
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
#  GLB_IF_GETPLISTARRAYSIZE <plistfile> <property>                         - Get an array property size from a plist file
#  GLB_NF_SETPLISTPROPERTY <plistfile> <property> <value>                  - Set a property to a value in a plist file
#  GLB_NF_RAWSETPLISTPROPERTY<plistfile> <property> <value>                - Set a property to a value in a plist file, without checking that the value sticks
#  GLB_SF_GETPLISTPROPERTY <plistfile> <property> [defaultvalue]           - Get a property value from a plist file
#  GLB_SF_DELETEPLISTPROPERTY <plistfile> <property>                       - Delete a property from a plist file
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
#

# ---
  
# Assume that all code is run from a subdirectory of the main project directory
GLB_SV_PROJECTDIRPATH="$(dirname $(dirname ${0}))"

# ---
  
# Only run the code if it hasn't already been run
if [ -z "${GLB_BC_COMM_ISINCLUDED}" ]
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

  # -- Begin Function Definition --
  
  # set info lines on loginwindow and remote desktop computerinfo
  GLB_NF_SETLOGINWINDOWLINE() #index text
  {
    local iv_InfoIndex
    local sv_InfoText
    local sv_LoginwindowText
    local iv_LoopCount
    local sv_Text
  
    iv_InfoIndex=${1}
    sv_InfoText="${2}"
  
    if [ "$(GLB_BF_NAMEDLOCKGRAB "LoginwindowText" 10 ${GLB_BC_TRUE})" = ${GLB_BC_TRUE} ]
    then
      sv_LoginwindowText=""
  
      for (( iv_LoopCount=1; iv_LoopCount<=4; iv_LoopCount++ ))
      do
        if [ ${iv_LoopCount} -eq ${iv_InfoIndex} ]
        then
          # Update the RemoteDesktop Computer Info Fields
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Setting remote desktop computerinfo ${iv_InfoIndex} to '${sv_InfoText}'"
          /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -computerinfo -set${iv_InfoIndex} -${iv_InfoIndex} "${sv_InfoText}"

          if [ ${iv_LoopCount} -lt 4 ]
          then
            # Limit the maximum line length to something reasonable
            sv_Text=$(echo "${sv_InfoText}" | cut -c1-64)
          else
            sv_Text=""
          fi

        else
          # Get a line of the Loginwindow text which we dont want to overwrite
          sv_Text=$(echo $(/usr/bin/defaults read /Library/Preferences/com.apple.loginwindow LoginwindowText | tr "\n" ";")";;;" | cut -d";" -f ${iv_LoopCount})

        fi

        sv_LoginwindowText="${sv_LoginwindowText}${sv_Text};"
      done
      sv_LoginwindowText=$(echo "${sv_LoginwindowText}" | sed "s/;$//" | tr ";" "\n")
  
      # Update the Loginwindow Text
      GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Setting login window text line #${iv_InfoIndex} to '${sv_InfoText}'"
      /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText -string "${sv_LoginwindowText}"
      
      GLB_NF_NAMEDLOCKRELEASE "LoginwindowText"
      
    fi
  }

  # Get seconds that mac mouse/keyboard is idle - ref https://github.com/CLCMacTeam/IdleLogout
  GLB_if_HIDIdleTime()
  {
    echo $(($(ioreg -c IOHIDSystem | sed -e '/HIDIdleTime/ !{ d' -e 't' -e '}' -e 's/.* = //g' -e 'q') / 1000000000))
  }

  GLB_IF_SYSTEMIDLESECS()
  {
    local iv_LastIdleFlagEpoch
    local iv_LastIdleSecs
    local iv_IdleSecs
    local iv_NowEpoch
    
    iv_NowEpoch=$(date -u "+%s")
    iv_IdleSecs=$(GLB_if_HIDIdleTime)

    iv_LastIdleFlagEpoch=$(GLB_NF_NAMEDFLAGMEPOCH "LASTIDLEEVENT")
    if [ ${iv_LastIdleFlagEpoch} -eq 0 ]
    then
      iv_LastIdleFlagEpoch=$((${iv_NowEpoch}-${iv_IdleSecs}))
      GLB_NF_NAMEDFLAGCREATE "LASTIDLEEVENT" ${iv_LastIdleFlagEpoch}
    fi
    iv_LastIdleSecs=$((${iv_NowEpoch}-${iv_LastIdleFlagEpoch}))

    if [ ${iv_LastIdleSecs} -gt ${GLB_IC_FORCEIDLETRIGGERSECS} ]
    then
      # If we have had a long period without idle events, something is wrong.
      # (Maybe the mouse has been placed on top of the keyboard)
      iv_IdleSecs=999999
    fi

    # output result in seconds
    echo ${iv_IdleSecs}
  }
  
  # Get the original file path - resolving any links
  GLB_SF_ORIGINALFILEPATH()   # FilePath
  {
    local sv_Path
    local sv_TruePath
    local sv_PathPart
    
    sv_Path="${1}"
    
    sv_TruePath=""
    while read sv_PathPart
    do
      if test -n "${sv_PathPart}"
      then
        sv_TruePath="${sv_TruePath}/${sv_PathPart}"
        if test -L "${sv_TruePath}"
        then
          sv_TruePath="$(stat -f %Y "${sv_TruePath}")"
        fi
        if test -z "${sv_TruePath}"
        then
          break
        fi
      fi
    done < <(echo ${sv_Path}| tr "/" "\n")
    
    echo "${sv_TruePath}"
  }

  # Schedule event for specified EPOCH time. Identify the event with a unique TAG.
  # WAKETYPE can be one of sleep, wake, poweron, shutdown, wakeorpoweron
  GLB_NF_SCHEDULE4EPOCH()   # TAG WAKETYPE EPOCH
  {
    local iv_SchedEpoch
    local sv_SchedLine
    local iv_NowEpoch
  
    sv_Tag=${1}
    sv_WakeType=${2}
    iv_SchedEpoch=${3}
  
    if [ ${GLB_IV_SYSTEMVERSIONSTAMPASNUMBER} -ge 168558592 ]
    then
      sv_Tag="pmset"
      GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Setting the 'owner' in a 'pmset sched' command does not appear to work on MacOS 10.12 and later"
    fi

    iv_NowEpoch=$(date -u "+%s")
  
    if [ ${iv_NowEpoch} -lt ${iv_SchedEpoch} ]
    then
      # Cancel any existing named schedules
      GLB_NF_SCHEDULECANCEL "${sv_Tag}" "${sv_WakeType}"
  
      sv_SchedLine=$(date -r ${iv_SchedEpoch} "+%m/%d/%y %H:%M:%S")
      pmset schedule ${sv_WakeType} "${sv_SchedLine}" "${sv_Tag}"

      GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Scheduled ${sv_WakeType} $(date -r ${iv_SchedEpoch} "+%Y%m%d-%H:%M.%S")"
    fi
  }

  # Cancel a scheduled event. Identify the event with a unique TAG and WAKETYPE.
  # WAKETYPE can be one of sleep, wake, poweron, shutdown, wakeorpoweron
  GLB_NF_SCHEDULECANCEL()   # TAG WAKETYPE
  {
    local iv_SchedEpoch
    local sv_SchedLine
  
    sv_Tag=${1}
    sv_WakeType=${2}
  
    # Check there isnt a named schedule already - ignored on 10.12 since owner not set correctly
    pmset -g sched | grep -i "${sv_WakeType}" | grep -i "${sv_Tag}" | tr -s " " | cut -d " " -f5-6 | while read sv_SchedLine
    do
      if [ -n "${sv_SchedLine}" ]
      then
        pmset schedule cancel ${sv_WakeType} "${sv_SchedLine}" "${sv_Tag}" 2>/dev/null
      fi
    done
  }

  # List all scheduled events for specified WAKETYPE.
  # WAKETYPE can be one of sleep, wake, poweron, shutdown, wakeorpoweron
  GLB_IF_GETSCHEDULEDEPOCH()   # WAKETYPE
  {
    local iv_SchedEpoch
    local sv_SchedLine
  
    sv_WakeType=${1}
    
    pmset -g sched | grep -i "${sv_WakeType}" | tr -s " " | cut -d " " -f5-6 | while read sv_SchedLine
    do
      if [ -n "${sv_SchedLine}" ]
      then
        iv_SchedEpoch=$(date -jf "%d/%m/%y %H:%M:%S" "${sv_SchedLine}" "+%s")
      fi
    done
  }
  
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
      sv_EmbeddedGlobalValue=$(eval echo $sv_EmbeddedGlobalName)
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

          # Trigger Sys-Error, Sys-Alert, Sys-Critical event
          if [ ${iv_LogLevel} -le ${GLB_IC_MSGLEVELERR} ]
          then
            "${GLB_SV_PROJECTDIRPATH}"/bin/Trigger "Sys-${sv_LogLevel}" &

          fi
        fi
      fi
    fi    
  }
  
  # Show a pop-up notification
  GLB_NF_SHOWNOTIFICATION() # loglevel Text
  {
    local iv_LogLevel
    local sv_Text
    local sv_CocoaDialogFilePath
    local sv_Result
    local sv_LogLevel
    
    iv_LogLevel=${1}
    sv_Text="${2}"
  
    sv_LogLevel="$(GLB_SF_LOGLEVEL ${iv_LogLevel})"
  
    GLB_NF_LOGMESSAGE ${sv_LogLevel} "${sv_Text}"
  
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
  
    sv_CocoaDialogFilePath="${GLB_SV_PROJECTDIRPATH}"/bin/CocoaDialog.app/Contents/MacOS/CocoaDialog
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
      if ! test -s "${sv_LockDirPath}/${sv_LockName}"
      then
        echo "${GLB_IV_THISSCRIPTPID}" > "${sv_LockDirPath}/${sv_LockName}"
      fi
      # Ignore errors, because the file might disappear before we get a chance to do the cat
      sv_ActiveLockPID="$(cat 2>/dev/null "${sv_LockDirPath}/${sv_LockName}" | head -n1)"
      if [ "${sv_ActiveLockPID}" = "${GLB_IV_THISSCRIPTPID}" ]
      then
        if [ "${sv_LockName}" != "ManipulateLog" ]
        then
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Grabbed lock '${sv_LockName}'"
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
            GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Grab lock failed, another task is being greedy '${sv_LockName}'"
          fi
        fi
        break
      fi 
           
      if [ "${bv_SilentFlag}" = ${GLB_BC_FALSE} ]
      then
        if [ "${sv_LockName}" != "ManipulateLog" ]
        then
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Waiting for lock '${sv_LockName}'"
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
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Releasing lock '${sv_LockName}'"
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
#    GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Creating flag '${sv_FlagDirPath}/${sv_FlagName}'"
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
    
#    GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Testing flag '${sv_FlagDirPath}/${sv_FlagName}'"
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
#    GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Deleting flag '${sv_FlagDirPath}/${sv_FlagName}'"
  }
  
  # NOTE: if things go wrong, this function and code that uses this function, are good places to look
  GLB_SF_GETDIRECTORYOBJECTATTRVALUE()   # context name attr - given an array property name, returns the size of the array 
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
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "Failed to get property ${sv_PropertyName} from ${sv_PlistFilePath}"
          sv_EntryValue=""
        fi
      else
        GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "Failed to get property ${sv_PropertyName} from ${sv_PlistFilePath}"
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
  
  # -- Get workstation name
  
  GLB_SV_HOSTNAME=$(hostname -s)
  
  # -- Get some info about logging

  # If necessary, setup the location of the log file
  
  if [ -z "${GLB_SV_LOGFILEPATH}" ]
  then
    if [ "${GLB_SV_RUNUSERNAME}" = "root" ]
    then
      GLB_SV_LOGFILEPATH="/Library/Logs/${GLB_SC_PROJECTSIGNATURE}.log"
  
    else
      GLB_SV_LOGFILEPATH="${GLB_SV_RUNUSERHOMEDIRPATH}/Library/Logs/${GLB_SC_PROJECTSIGNATURE}.log"
    
    fi
  fi

  # If necessary, use the hard-coded log setting values 

  if [ -z "${GLB_BV_LOGISACTIVE}" ]
  then
    GLB_BV_LOGISACTIVE=${GLB_BV_DFLTLOGISACTIVE}
  fi

  if [ -z "${GLB_IV_LOGSIZEMAXBYTES}" ]
  then
    GLB_IV_LOGSIZEMAXBYTES=${GLB_IV_DFLTLOGSIZEMAXBYTES}
  fi
  
  if [ -z "${GLB_IV_LOGLEVELTRAP}" ]
  then
    GLB_IV_LOGLEVELTRAP=${GLB_IV_DFLTLOGLEVELTRAP}
  fi

  if [ -z "${GLB_IV_NOTIFYLEVELTRAP}" ]
  then
    GLB_IV_NOTIFYLEVELTRAP=${GLB_IV_DFLTNOTIFYLEVELTRAP}
  fi
  
  # -- Create temporary directories

  # The base locations of all temporary directories
  GLB_SV_TEMPROOT="/tmp/${GLB_SC_PROJECTNAME}"
  GLB_AV_TEMPUSERSROOT="${GLB_SV_TEMPROOT}/Users"
  
  # Create base temporary directories
  if [ "${GLB_SV_RUNUSERNAME}" = "root" ]
  then
    mkdir -p "${GLB_SV_TEMPROOT}"
    chown root:wheel "${GLB_SV_TEMPROOT}"
    chmod 1755 "${GLB_SV_TEMPROOT}"

    mkdir -p "${GLB_AV_TEMPUSERSROOT}"
    chown root:wheel "${GLB_AV_TEMPUSERSROOT}"
    chmod 1777 "${GLB_AV_TEMPUSERSROOT}"
  fi
    
  # Create a temporary directory private to this user (and admins)
  GLB_SV_RUNUSERTEMPDIRPATH=${GLB_AV_TEMPUSERSROOT}/${GLB_SV_RUNUSERNAME}
  if ! test -d "${GLB_SV_RUNUSERTEMPDIRPATH}"
  then
    mkdir -p "${GLB_SV_RUNUSERTEMPDIRPATH}"
    chown ${GLB_SV_RUNUSERNAME}:admin "${GLB_SV_RUNUSERTEMPDIRPATH}"
    chmod 770 "${GLB_SV_RUNUSERTEMPDIRPATH}"
  fi
  
  # Create a temporary directory private to this script
  GLB_SV_THISSCRIPTTEMPDIRPATH="$(mktemp -dq ${GLB_SV_RUNUSERTEMPDIRPATH}/${GLB_SV_THISSCRIPTFILENAME}-XXXXXXXX)"
  mkdir -p "${GLB_SV_THISSCRIPTTEMPDIRPATH}"
  
  # -- Get AD workstation name (the name when it was bound)
  
  # Get Computer AD trust account - i.e. yourcomputername$
  GLB_SV_ADTRUSTACCOUNTNAME="$(dsconfigad 2>/dev/null -show | grep "Computer Account" | sed "s|\([^=]*\)=[ ]*\([^ ]*$\)|\2|")"
  
  # AD computer name (without the trailing dollar sign)
  GLB_SV_ADCOMPUTERNAME=$(echo ${GLB_SV_ADTRUSTACCOUNTNAME} | sed "s|\$$||")
  
  # ---
  
  # Get Computer full AD domain - i.e. yourdomain.yourcompany.com
  GLB_SV_ADDNSDOMAINNAME="$(dsconfigad 2>/dev/null -show | grep "Active Directory Domain" | sed "s|\([^=]*\)=[ ]*\([^ ]*$\)|\2|")"
  
  # ---
  
  # If the workstation is bound to AD, make sure the computer name matches the AD object
  if test -n "${GLB_SV_ADCOMPUTERNAME}"
  then
    if [ "${GLB_SV_HOSTNAME}" != "${GLB_SV_ADCOMPUTERNAME}" ]
    then
      GLB_SV_HOSTNAME="${GLB_SV_ADCOMPUTERNAME}"
      /usr/sbin/systemsetup -setcomputername "${GLB_SV_ADCOMPUTERNAME}"
      /usr/sbin/scutil --set ComputerName "${GLB_SV_ADCOMPUTERNAME}"
      /usr/sbin/systemsetup -setlocalsubnetname "${GLB_SV_ADCOMPUTERNAME}"
      /usr/sbin/scutil --set LocalHostName "${GLB_SV_ADCOMPUTERNAME}"
      /usr/sbin/scutil --set HostName "${GLB_SV_ADCOMPUTERNAME}.${GLB_SV_ADDNSDOMAINNAME}"
    
    fi
  fi
  
  # ---
  
  # Get Computer short AD domain - i.e. YOURDOMAIN
  if test -n "${GLB_SV_ADDNSDOMAINNAME}"
  then
    # If we have just started up, we may need to wait a short time while the system populates the scutil vars
    iv_DelayCount=0
    while [ ${iv_DelayCount} -lt 5 ]
    do
      GLB_SV_ADFLATDOMAINNAME=$(echo "show com.apple.opendirectoryd.ActiveDirectory" | scutil | grep "DomainNameFlat" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
      if test -n "${GLB_SV_ADFLATDOMAINNAME}"
      then
        break
      fi
  
      # we don't want to hog the CPU - so lets sleep a while
      GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Waiting around until the scutil ActiveDirectory vars are populated"
      sleep 1
        
      iv_DelayCount=$((${iv_DelayCount}+1))
    done
  fi
  
  # --
  
  # Get Computer AD trust account password
  if test -n "${GLB_SV_ADTRUSTACCOUNTNAME}"
  then
    GLB_SV_ADTRUSTACCOUNTPASSWORD=$(security find-generic-password -w -s "/Active Directory/${GLB_SV_ADFLATDOMAINNAME}" /Library/Keychains/System.keychain)
  fi
  
  # -- Get Network info
  
  GLB_SV_IPV4PRIMARYSERVICEUUID=$(echo "show State:/Network/Global/IPv4" | scutil | grep "PrimaryService" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  if test -n "${GLB_SV_IPV4PRIMARYSERVICEUUID}"
  then
    # Get DHCP option 15 (domain)
    GLB_SV_IPV4PRIMARYSERVICEDHCPOPTION15=$(echo "show State:/Network/Service/${GLB_SV_IPV4PRIMARYSERVICEUUID}/DHCP" | scutil | grep "Option_15" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||" | sed -E "s/^<data> 0x//;s/00$//" | xxd -r -p)
  
    # Get user defined name - e.g. Wi-Fi
    GLB_SV_IPV4PRIMARYSERVICEINTERFACENAME=$(echo "show Setup:/Network/Service/${GLB_SV_IPV4PRIMARYSERVICEUUID}" | scutil | grep "UserDefinedName" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  
    # Get device name - e.g. en1
    GLB_SV_IPV4PRIMARYSERVICEDEVICENAME=$(echo "show Setup:/Network/Service/${GLB_SV_IPV4PRIMARYSERVICEUUID}/Interface" | scutil | grep "DeviceName" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  
    # Get device hardware - e.g. Airport
    GLB_SV_IPV4PRIMARYSERVICEHARDWARENAME=$(echo "show Setup:/Network/Service/${GLB_SV_IPV4PRIMARYSERVICEUUID}/Interface" | scutil | grep "Hardware" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  fi
  
  # Get the the device name for wireless (eg en1)
  GLB_SV_WIFIINTERFACEDEVICE="$(networksetup -listallhardwareports | tr "\n" ":" | sed "s|^[:]*||;s|::|;|g" | tr ";" "\n" | grep "Wi-Fi" | sed "s|\(.*Device:[ ]*\)\([^:]*\)\(.*\)|\2|" | head -n 1)"
  
  # -- Get Date/Time info

  sv_NowDate=$(date "+%s:%M:%H:%w:%a:%d:%m:%b:%Y")
  
  GLB_IV_EPOCH=$(echo ${sv_NowDate} | cut -d":" -f1)
  GLB_IV_MINUTE=$(echo ${sv_NowDate} | cut -d":" -f2 | sed "s|^0||")
  GLB_IV_HOUR=$(echo ${sv_NowDate} | cut -d":" -f3 | sed "s|^0||")
  GLB_IV_WEEKDAY=$(echo ${sv_NowDate} | cut -d":" -f4)
  GLB_SV_WEEKDAY=$(echo ${sv_NowDate} | cut -d":" -f5)
  GLB_IV_DAY=$(echo ${sv_NowDate} | cut -d":" -f6 | sed "s|^0||")
  GLB_IV_MONTH=$(echo ${sv_NowDate} | cut -d":" -f7 | sed "s|^0||")
  GLB_SV_MONTH=$(echo ${sv_NowDate} | cut -d":" -f8)
  GLB_IV_YEAR=$(echo ${sv_NowDate} | cut -d":" -f9)
  
  sv_YesterdayDate=$(date -v-1d "+%w:%a:%d:%m:%b:%Y")
  
  GLB_IV_YWEEKDAY=$(echo ${sv_YesterdayDate} | cut -d":" -f1)
  GLB_SV_YWEEKDAY=$(echo ${sv_YesterdayDate} | cut -d":" -f2)
  GLB_IV_YDAY=$(echo ${sv_YesterdayDate} | cut -d":" -f3 | sed "s|^0||")
  GLB_IV_YMONTH=$(echo ${sv_YesterdayDate} | cut -d":" -f4 | sed "s|^0||")
  GLB_SV_YMONTH=$(echo ${sv_YesterdayDate} | cut -d":" -f5)
  GLB_IV_YYEAR=$(echo ${sv_YesterdayDate} | cut -d":" -f6)
  
  # ---

  # Support some short-form equivalents for easy definitions within match strings
  GLB_SV_DHCPOPTION15=${GLB_SV_IPV4PRIMARYSERVICEDHCPOPTION15}
  GLB_IV_BUILDVERSION=${GLB_IV_BUILDVERSIONSTAMPASNUMBER}
  GLB_SV_BUILDVERSION=${GLB_SV_BUILDVERSIONSTAMPASSTRING}
  GLB_IV_OS=${GLB_IV_SYSTEMVERSIONSTAMPASNUMBER}
  GLB_SV_OS=${GLB_SV_SYSTEMVERSIONSTAMPASSTRING}
  GLB_SV_MODEL=${GLB_SV_MODELIDENTIFIER}
  
  # ---

  # Support pre version 3.0.2 global expansions
  GLB_COMPUTERNAME=${GLB_SV_HOSTNAME}
  GLB_USERNAME=${GLB_SV_CONSOLEUSERNAME}
  GLB_HOMEPATH=${GLB_SV_CONSOLEUSERHOMEDIRPATH}
  GLB_HOMESHARE=${GLB_SV_CONSOLEUSERSHAREDIRPATH}
  GLB_HOMELOCAL=${GLB_SV_CONSOLEUSERLOCALHOMEDIRPATH}
  GLB_DOMAIN=${GLB_SV_ADFLATDOMAINNAME}
  GLB_FQADDOMAIN=${GLB_SV_ADDNSDOMAINNAME}
  
  # ---
  
  GLB_BC_COMM_ISINCLUDED=${GLB_BC_TRUE}

fi
