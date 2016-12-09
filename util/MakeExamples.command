#!/bin/bash
#
# Short:    Initialise the LabWarden configs
# Author:   Mark J Swift
# Version:  1.0.101
# Modified: 09-Dec-2016
#

# ---

# Change working directory to the location of this script
cd "$(dirname "${0}")"

# ---

# Load the library, only if it is not already loaded
if test -z "${LW_sv_BuildVersionStampAsString}"
then
  . /usr/local/LabWarden/lib/CommonLib
fi

# ---

sv_ExampleConfigDirPath=~/Desktop/LabWardenConfigs/Examples

sv_ConfigLabDirPath="${sv_ExampleConfigDirPath}/PolicyConfig"
mkdir -p "${sv_ConfigLabDirPath}"

sv_ConfigPtrDirPath="${sv_ExampleConfigDirPath}/PrinterConfig"
mkdir -p "${sv_ConfigPtrDirPath}"

sv_ConfigType="LabWardenConfig"

# ---

# Create a config and return ConfigFilePath and PropertyBase
sf_MakeConfigFile()   # PolicyName Tag ConfigType - returns string "<ConfigFilePath>,<PropertyBase>"
{
  local sv_PolicyName
  local sv_Tag
  local sv_ConfigType
  local sv_ConfigFileName
  local sv_PayloadUUID
  local sv_ConfigFilePath
  local sv_PropertyBase
  local sv_PayloadIdentifier

  sv_PolicyName="${1}"
  sv_Tag="${2}"
  sv_ConfigType="${3}"
  
  if test -z "${sv_Tag}"
  then
    sv_ConfigFileName="${sv_PolicyName}"
  else
    sv_ConfigFileName="${sv_PolicyName}-${sv_Tag}"
  fi

  sv_PayloadUUID=$(uuidgen)

  case "$sv_ConfigType" in
  LabWardenConfig)
    sv_ConfigFilePath="${sv_ConfigDirPath}/${sv_ConfigFileName}.LabWarden.plist"
    rm -f "${sv_ConfigFilePath}"
    LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":UUID" "${sv_PayloadUUID}"
    sv_PropertyBase=""
    ;;
    
  MobileConfig)
    sv_ConfigFilePath="${sv_ConfigDirPath}/${sv_ConfigFileName}.mobileconfig"
    rm -f "${sv_ConfigFilePath}"
    sv_PayloadIdentifier=$(uuidgen)
    LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadContent:0:PayloadUUID" "${sv_PayloadUUID}"
    LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadContent:0:PayloadIdentifier" "${sv_PayloadUUID}"
    LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadContent:0:PayloadType" "com.apple.ManagedClient.preferences"
    LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadContent:0:PayloadVersion" "1"
    LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadContent:0:PayloadContent:com.github.execriez.LabWarden:Set-Once:0:mcx_preference_settings:${sv_PayloadUUID}" "DICT"
    LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadContent:0:PayloadEnabled" "true"
    LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadUUID" "${sv_PayloadIdentifier}"
    LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadIdentifier" "${sv_PayloadIdentifier}"
    LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadType" "Configuration"
    LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadVersion" "1"
    LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadDescription" ""
    if test -z "${sv_Tag}"
    then
      LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadDisplayName" "LW ${sv_PolicyName}"
    else
      LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadDisplayName" "LW ${sv_PolicyName} (${sv_Tag})"
    fi
    LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadOrganization" ""
    LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadRemovalDisallowed" "true"
    LW_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadScope" "System"
    sv_PropertyBase=":PayloadContent:0:PayloadContent:com.github.execriez.LabWarden:Set-Once:0:mcx_preference_settings:${sv_PayloadUUID}"
    ;;
    
  esac
  
  echo "${sv_ConfigFilePath},${sv_PropertyBase}"
}

# ---

sv_ConfigDirPath="${sv_ConfigLabDirPath}"

# ---
sv_PolicyName="AppDeleteDataOnQuit"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "AppDidTerminate"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:0:ApplicationBundleIdentifier" "com.apple.finder"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:0:Path:0" "/.Trash/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:1:ApplicationBundleIdentifier" "com.adobe.AdobePremierePro"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:1:Path:0" "/Library/Application Support/Adobe/Common/Media Cache Files/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:1:Path:1" "/Library/Application Support/Adobe/Common/Media Cache/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:2:ApplicationBundleIdentifier" "org.chromium.Chromium"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:2:Path:0" "/Library/Application Support/Chromium/Default/Pepper Data/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:3:ApplicationBundleIdentifier" "com.google.Chrome"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:3:Path:0" "/Library/Application Support/Google/Chrome/Default/Pepper Data/"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="AppExamplePolicy"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "AppWillLaunch"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "AppDidLaunch"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:2" "AppDidTerminate"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleBool" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleNum" "42"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleString" "Example"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:0" "First"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:1" "Second"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:2" "Third"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="AppFirstSetupFirefox"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "AppWillLaunch"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="AppNetworkFixFirefox"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "AppWillLaunch"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "AppDidTerminate"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---

sv_PolicyName="AppRestrict"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "AppWillLaunch"

  # Any Application in the ExceptionList is exempt from Whitelist/BlackList checking
  # This allows you to have Apps that will run from any location without having to implement a whitelist
  # The format is ApplicationName1/ApplicationBundleIdentifier1,ApplicationName2/ApplicationBundleIdentifier2,etc
  # If an application has no ApplicationBundleIdentifier then specify ApplicationName/(null) i.e TextWrangler/(null)
  # Regular expressions can be used.

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:0:ApplicationName" "PrinterProxy"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:0:ApplicationBundleIdentifier" 'com\.apple\.print\.PrinterProxy'
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:1:ApplicationName" ".*"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:1:ApplicationBundleIdentifier" "com\.google\.Chrome\.app\..*"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:2:ApplicationName" "Citrix Online Launcher"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:2:ApplicationBundleIdentifier" "com\.citrixonline\.mac\.WebDeploymentApp"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:3:ApplicationName" "GoToMeeting.*"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:3:ApplicationBundleIdentifier" "com\.citrixonline\.GoToMeeting"

  
  # If the WhiteList is not null, then these Applications (and only these) are allowed.
  # When the WhiteList is not null, then it should at least contain "Finder/com.apple.Finder" or maybe even ".*/com.apple\..*"
  # Regular expressions can be used.
  
  # Any Application in the comma-separated BlackList is always disallowed for non-admins
  # Regular expressions can be used.

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:BlackList:0:ApplicationName" "Terminal"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:BlackList:0:ApplicationBundleIdentifier" "com\.apple\.Terminal"
  
  # If the comma-separated path WhiteList is not null, then Applications at the specified paths (and only these paths) are allowed.
  # When the path WhiteList is not null, it should at least contain "/Applications/.*,/System/Library/CoreServices/.*"
  # ~/ is expanded to the current user home before comparison.
  # Regular expressions should be used.
  

  # Any application located at a path in this comma-separated path BlackList is always disallowed for non-admins
  # ~/ is expanded to the current user home before comparison.
  # Regular expressions should be used.
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:PathBlackList:0" "~/.*"
  
  # Should we disallow applications running on mounts
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:OnlyAllowLocalApps" "true"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="AppShowHints"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "AppDidLaunch"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:ApplicationBundleIdentifier" "com.apple.logic10"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:IsAdmin" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:IsLocalAccount" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:IsLocalHome" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:MessageTitle" "ON NETWORK"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:MessageContent" "APPNAME works better off network"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:1:ApplicationBundleIdentifier" "com.adobe.AdobePremierePro"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:1:MessageTitle" "NOW SET YOUR PREFS"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:1:MessageContent" "Setup your Media Cache File location (Premiere>Preferences>Media)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:2:ApplicationBundleIdentifier" "com.apple.FinalCutPro"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:2:MessageTitle" "NOW SET YOUR PREFS"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:2:MessageContent" "Final Cut Pro>System Settings...>Scratch Disks"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---

sv_PolicyName="SystemUpdate"
sv_Tag="Radmind"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "LoginWindowIdle"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "ManualUpdate"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:OutOfHoursPowerOn" "true"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:OutOfHoursStartTime" "22:00"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:OutOfHoursEndTime" "05:00"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Script:Exe:0" "file://localhost/usr/local/LabWarden/lib/RadmindUpdate"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Script:Exe:1" "192.168.0.3,sha1,0,-I,42000"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginWindowIdleShutdownSecs" "1200"        # Should we shut workstations down if idle at the LoginWindow    

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---

# OFFICE HOURS

sv_PolicyName="SystemOfficeHours"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Boot"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "SystemPoll"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:2" "UserAtDesktop"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:3" "UserPoll"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:Start:Day" "25"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:Start:Month" "11"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:Start:Year" "2016"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:End:Day" "03"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:End:Month" "09"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:End:Year" "2017"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LogoutUserOutOfHours" "true"               # Should we force user logout out-of-hours

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LogoutWarningSecs" "600"                   # Warn user 10 mins before force logout

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ForceLogoutExceptionGroup:0" "All-Staff"   # list of groups that are exempt from force logout

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LogoutEarlySecs" "600"                     # if LogoutUserOutOfHours is true, logout user 10 mins before closing
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginEarlySecs" "3600"                     # if LogoutUserOutOfHours is true, allow user login 60 mins before opening

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:UnrestrictedHoursOnClosedDays" "true"      # Should we allow unrestricted access on days that are defined as closed

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LogoutUserIdleSecs" "1800"                 # How long before we force logout idle users (0 = never)  

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AuditHideUntilAgeSecs" "604800"            # Dont show audit at LoginWindow until its at least 1 day old

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day1:OpenTime" "8:30"    # Mon
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day1:CloseTime" "21:00"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day2:OpenTime" "8:30"    # Tue
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day2:CloseTime" "21:00"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day3:OpenTime" "8:30"    # Wed
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day3:CloseTime" "21:00"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day4:OpenTime" "8:30"    # Thu
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day4:CloseTime" "21:00"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day5:OpenTime" "8:30"    # Fri
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day5:CloseTime" "17:00"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day6:OpenTime" ""   # Sat
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day6:CloseTime" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day7:OpenTime" ""        # Sun
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day7:CloseTime" ""

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:Start:Day" "23"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:Start:Month" "12"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:Start:Year" "2016"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:End:Day" "8"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:End:Month" "1"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:End:Year" "2017"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:Start:Day" "14"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:Start:Month" "4"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:Start:Year" "2017"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:End:Day" "14"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:End:Month" "4"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:End:Year" "2017"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:Start:Day" "29"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:Start:Month" "10"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:Start:Year" "2016"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:End:Day" "6"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:End:Month" "11"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:End:Year" "2016"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:Start:Day" "14"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:Start:Month" "1"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:Start:Year" "2017"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:End:Day" "22"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:End:Month" "1"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:End:Year" "2017"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day1:OpenTime" "8:30"    # Mon
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day1:CloseTime" "16:00"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day2:OpenTime" "8:30"    # Tue
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day2:CloseTime" "16:00"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day3:OpenTime" "8:30"    # Wed
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day3:CloseTime" "16:00"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day4:OpenTime" "8:30"    # Thu
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day4:CloseTime" "16:00"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day5:OpenTime" "8:30"    # Fri
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day5:CloseTime" "16:00"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day6:OpenTime" ""   # Sat
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day6:CloseTime" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day7:OpenTime" ""        # Sun
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day7:CloseTime" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemAddEntriesToHostsFile"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:IP4" "127.0.0.1"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:Host:0" "prod-w.nexus.live.com.akadns.net"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:Host:1" "odc.officeapps.live.com"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:Host:2" "omextemplates.content.office.net"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:Host:3" "officeclient.microsoft.com"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:Host:4" "store.office.com"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:Host:5" "nexusrules.officeapps.live.com"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:Host:6" "nexus.officeapps.live.com"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemDeleteFiles"
sv_Tag="FlashPlayer"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:0" "/Applications/Utilities/Adobe Flash Player Install Manager.app/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:1" "/Library/Application Support/Adobe/Flash Player Install Manager/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:2" "/Library/Internet Plug-Ins/Flash Player.plugin/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:3" "/Library/Internet Plug-Ins/PepperFlashPlayer/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:4" "/Library/LaunchDaemons/com.adobe.fpsaud.plist"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:5" "/Library/PreferencePanes/Flash Player.prefPane/"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemDeleteOldUserProfiles"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "LoginWindowIdle"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginMaxAgeDays" 62
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:UserCacheEarliestEpoch" 1462365175

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemGiveSystemProxyAccess"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:0:ProxyProtocol" "http"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:0:ProxyAddress" "PROXYADDRESS"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:0:ProxyPort" "PROXYPORT"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:0:Process:0" "/usr/sbin/ocspd"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:1:ProxyProtocol" "htps"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:1:ProxyAddress" "PROXYADDRESS"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:1:ProxyPort" "PROXYPORT"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:1:Process:0" "/usr/sbin/ocspd"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemInstallPackageFromFolder"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "LoginWindowIdle"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:0" "/usr/local/Updates"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---

# ALTERNATIVE - PROXY, AUTO

sv_PolicyName="SystemNetworkProxy"
sv_Tag="AutoProxy"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "NetworkUp"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ProxyAutoDiscovery:Enabled" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AutoProxy:Enabled" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AutoProxy:URL" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:WebProxy:Enabled" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:WebProxy:Address" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:WebProxy:Port" "8080"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SecureWebProxy:Enabled" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SecureWebProxy:Address" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SecureWebProxy:Port" "8080"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:StreamingProxy:Enabled" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:StreamingProxy:Address" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:StreamingProxy:Port" "8080"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:FTPProxy:Enabled" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:FTPProxy:Address" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:FTPProxy:Port" "8080"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SOCKSProxy:Enabled" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SOCKSProxy:Address" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SOCKSProxy:Port" "8080"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:GopherProxy:Enabled" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:GopherProxy:Address" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:GopherProxy:Port" "8080"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ProxyBypassDomains:0" "*.local"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ProxyBypassDomains:1" "169.254/16"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ProxyBypassDomains:2" "127.0.0.1"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ProxyBypassDomains:3" "localhost"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemEstablish8021XWiFi"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "NetworkUp"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RenewCertBeforeDays" "28"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RevokeCertBeforeEpoch" "0"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:CertTemplate" "Mac-Computer"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:CertAuthURL" "https://yourcaserer.yourdomain/certsrv"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SSIDSTR" "YourSSID"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ProxyType" "Auto"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemExamplePolicy"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleBool" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleNum" "42"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleString" "Example"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:0" "First"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:1" "Second"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:2" "Third"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemRemoteManagement"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Boot"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "NetworkUp"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Groups:0:Name" "dirgroup1"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Groups:0:Access" "admin"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Groups:1:Name" "dirgroup2"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Groups:1:Access" "interact"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:0:Name" "diruser1"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:0:Access" "admin"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:1:Name" "diruser2"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:1:Access" "interact"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:1:Name" "diruser3"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:1:Access" "manage"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:1:Name" "diruser4"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:1:Access" "reports"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:0:Name" "localuser1"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:0:Privs:0" "all"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Name" "localuser2"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:0" "DeleteFiles"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:1" "ControlObserve"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:2" "TextMessages"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:3" "ShowObserve"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:4" "OpenQuitApps"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:5" "GenerateReports"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:6" "RestartShutDown"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:7" "SendFiles"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:8" "ChangeSettings"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:9" "ObserveOnly"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemRestartIfNetMount"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "LoginWindow"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemSleepSettings"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "LoginWindow"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "LoginBegin"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginBegin:Battery:DiskSleep" 3
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginBegin:Battery:DisplaySleep" 2
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginBegin:Battery:SystemSleep" 15
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginBegin:Power:DiskSleep" 15
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginBegin:Power:DisplaySleep" 10
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginBegin:Power:SystemSleep" 0

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginWindow:Battery:DiskSleep" 3
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginWindow:Battery:DisplaySleep" 2
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginWindow:Battery:SystemSleep" 0
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginWindow:Power:DiskSleep" 15
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginWindow:Power:DisplaySleep" 10
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginWindow:Power:SystemSleep" 0

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemTimeServer"
sv_Tag="Apple"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:TimeServer" "time.euro.apple.com"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:TimeZone" "Europe/London"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemUnloadAgentsAndDaemons"
sv_Tag="ProxyPopup"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Unload:0" "/System/Library/LaunchDaemons/com.apple.UserNotificationCenter.plist"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemUserExperience"
sv_Tag="HomeForceLocal"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:mobile" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:mobileconfirm" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:localhome" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:sharepoint" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:useuncpath" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:protocol" "smb"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:alldomains" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:preferredserver" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemUserExperience"
sv_Tag="Mobile"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:mobile" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:mobileconfirm" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:localhome" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:sharepoint" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:useuncpath" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:protocol" "smb"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:alldomains" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:preferredserver" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemUserExperience"
sv_Tag="HomeOnNetwork"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:mobile" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:mobileconfirm" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:localhome" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:sharepoint" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:useuncpath" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:protocol" "smb"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:alldomains" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:preferredserver" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemWirelessForgetSSID"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SSID:0" "College"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SSID:1" "virginmedia1234567"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemWirelessSetState"
sv_Tag="off"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:WirelessState" "off"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminIBSS" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminNetworkChange" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminPowerToggle" "true"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="SystemWirelessSetState"
sv_Tag="on"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:WirelessState" "on"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminIBSS" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminNetworkChange" "false"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminPowerToggle" "true"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="UserCheckQuotaOnNetHome"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "UserPoll"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="UserCreateFolder"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "UserLogin"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:0" "/Desktop/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:1" "/Documents/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:2" "/Downloads/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:3" "/Library/Preferences/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:4" "/Movies/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:5" "/Music/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:6" "/Pictures/"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="UserDefaultHandlers"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "UserAtDesktop"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:0:BundleID" "com.apple.Safari"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:0:UTI" "public.html"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:0:Role" "all"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:1:BundleID" "com.apple.Safari"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:1:UTI" "public.xhtml"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:1:Role" "all"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:2:BundleID" "com.apple.Safari"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:2:UTI" "http"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:3:BundleID" "com.apple.Safari"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:3:UTI" "https"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:4:BundleID" "cx.c3.theunarchiver"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:4:UTI" "zip"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:4:Role" "all"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
# ALTERNATIVE - DESKTOP WALLPAPER
sv_PolicyName="UserDesktopWallpaperURI"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "UserAtDesktop"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:DesktopWallpaperURI" "smb://YOURSERVER/YOURSHARE/YOURFOLDER/desktop.bmp"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="UserExamplePolicy"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "UserAtDesktop"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleBool" "true"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleNum" "42"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleString" "Example"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:0" "First"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:1" "Second"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:2" "Third"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="UserKeychainFix"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "UserAtDesktop"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="UserNoSpotlightOnNetHome"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "UserAtDesktop"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="UserHomeMakePathRedirections"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "UserLogin"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "UserAtDesktop"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:MakePathRedirections" "true"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:0" "/Desktop/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:1" "/Documents/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:2" "/Movies/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:3" "/Music/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:4" "/Pictures/"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:0" "/Library/Application Support/audacity/.audacity.sock"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:1" "/Library/Application Support/CrashReporter/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:2" "/Library/Caches/com.apple.helpd/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:3" "/Library/Calendars/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:4" "/Library/com.apple.nsurlsessiond/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:5" "/Library/Containers/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:6" "/Library/IdentityServices/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:7" "/Library/Keychains/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:8" "/Library/Logs/DiagnosticReports/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:9" "/Library/Messages/"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="UserSidebarContent"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "UserAtDesktop"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Replace" "false"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:0:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:0:Label" "All My Files"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:1:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:1:Label" "iCloud"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:2:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:2:Label" "AirDrop"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:0:URI" "file://HOMEDIR"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:0:Label" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:1:URI" "file://HOMEDIR/Desktop"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:1:Label" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:2:URI" "file://HOMEDIR/Documents"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:2:Label" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:3:URI" "file://HOMEDIR/Downloads"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:3:Label" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:4:URI" "file://HOMEDIR/Movies"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:4:Label" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:5:URI" "file://HOMEDIR/Music"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:5:Label" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:6:URI" "file://HOMEDIR/Pictures"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:6:Label" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="UserDockContent"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "UserAtDesktop"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Replace" "false"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:0:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:0:Label" "Mail"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:1:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:1:Label" "Contacts"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:2:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:2:Label" "Calendar"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:3:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:3:Label" "Notes"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:4:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:4:Label" "Reminders"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:5:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:5:Label" "Messages"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:6:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:6:Label" "FaceTime"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:7:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:7:Label" "App Store"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:0:URI" "file://HOMEDIR"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:0:Label" ""
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:1:URI" "file://HOMEDIR/Downloads"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:1:Label" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="UserSidebarList"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "UserAtDesktop"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:DeleteItem:0" "All My Files"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:DeleteItem:1" "iCloud"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:DeleteItem:2" "iCloud Drive"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:DeleteItem:3" "AirDrop"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AddItem:0" "file:///Applications"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AddItem:1" "file://HOMEDIR"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AddItem:2" "file://HOMEDIR/Desktop"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AddItem:3" "file://HOMEDIR/Documents"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AddItem:4" "file://HOMEDIR/Downloads"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AddItem:5" "file://HOMEDIR/Movies"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AddItem:6" "file://HOMEDIR/Music"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AddItem:7" "file://HOMEDIR/Pictures"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="UserSyncLocalHomeToNetwork"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "UserAtDesktop"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "UserLogout"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:0" "/Library/Fonts/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:1" "/Library/Application Support/Firefox/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:2" "/Library/Application Support/Google/Chrome/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:3" "/Library/Application Support/Chromium/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:4" "/Library/Safari/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:5" "/Library/Application Support/Microsoft/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:6" "/Library/Application Support/Spotify/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:7" "/Library/Caches/com.apple.helpd/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:8" "/Library/Group Containers/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:9" "/Library/Preferences/com.microsoft.autoupdate2.plist"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:10" "/Library/Preferences/com.microsoft.error_reporting.plist"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:11" "/Library/Preferences/com.microsoft.office.plist"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:12" "/Library/Preferences/com.microsoft.outlook.databasedaemon.plist"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:13" "/Library/Preferences/com.microsoft.Word.plist"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:14" "/Library/Preferences/com.microsoft.office.plist"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:15" "/Library/Preferences/com.microsoft.Powerpoint.plist"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:16" "/Library/Preferences/com.microsoft.Excel.plist"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:17" "/Library/Preferences/com.microsoft.office.plist"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:18" "/Library/Preferences/com.microsoft.outlook.office_reminders.plist"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:19" "/Library/Preferences/com.microsoft.Outlook.plist"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
# Policy that deploys the mounthome.sh script from https://github.com/amsysuk/public_scripts
# Script should be renamed to "mounthome" and placed in "/usr/local/LabWarden/Custom/Policies"
# The mounthome script has no configurable options so can be used as-is
sv_PolicyName="mounthome"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "UserLogin"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Debug"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Boot"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "UserAtDesktop"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---

sv_ConfigDirPath="${sv_ConfigPtrDirPath}"

# ---

sv_PolicyName="Marketing-Laser2020"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Printer"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:PPDURI" "file://localhost/Library/Printers/PPDs/Contents/Resources/HP Color LaserJet CP2020 Series.gz"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:PrinterURI" "smb://PRINTSRV.example.com/Marketing-Laser2020"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Options" "-o printer-is-shared=false -o printer-error-policy=abort-job -o PageSize=A4 -o HPBookletPageSize=A4"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Location" "Marketing"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Marketing-Laser2020-direct"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Printer"

LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:PPDURI" "file://localhost/Library/Printers/PPDs/Contents/Resources/HP Color LaserJet CP2020 Series.gz"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:PrinterURI" "lpd://192.168.0.5/"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Options" "-o printer-is-shared=false -o printer-error-policy=abort-job -o PageSize=A4 -o HPBookletPageSize=A4"
LW_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Location" "Marketing"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---

# Remove temporary files
rm -fPR "${LW_sv_ThisScriptTempDirPath}"

