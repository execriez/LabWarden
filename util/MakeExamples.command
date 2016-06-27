#!/bin/bash
#
# Short:    Initialise the LabWarden configs
# Author:   Mark J Swift
# Version:  1.0.86
# Modified: 09-Jun-2016
#

# ---

# Change working directory to the location of this script
cd "$(dirname "${0}")"

# Filename of this script
GLB_MyFilename="$(basename "${0}")"

# Directory where script is running
GLB_MyDir="$(pwd)"
# ---

# Take a note when this script started
LCL_MyStartEpoch=$(date -u "+%s")

# Load the library, only if it is not already loaded
if test -z "${GLB_LabWardenLibLoaded}"
then
  . /usr/local/LabWarden/lib/CommonLib
fi

# ---

GLB_ExampleConfigDir=~/Desktop/LabWardenConfigs/Examples

GLB_ConfigLabDir="${GLB_ExampleConfigDir}/PolicyConfig"
mkdir -p "${GLB_ConfigLabDir}"

GLB_ConfigPtrDir="${GLB_ExampleConfigDir}/PrinterConfig"
mkdir -p "${GLB_ConfigPtrDir}"

# ---
LCL_PolicyName="AppDeleteDataOnQuit"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "AppDidTerminate"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppData:0:ApplicationBundleIdentifier" "com.apple.finder"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppData:0:Path:0" "/.Trash/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppData:1:ApplicationBundleIdentifier" "com.adobe.AdobePremierePro"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppData:1:Path:0" "/Library/Application Support/Adobe/Common/Media Cache Files/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppData:1:Path:1" "/Library/Application Support/Adobe/Common/Media Cache/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppData:2:ApplicationBundleIdentifier" "org.chromium.Chromium"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppData:2:Path:0" "/Library/Application Support/Chromium/Default/Pepper Data/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppData:3:ApplicationBundleIdentifier" "com.google.Chrome"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppData:3:Path:0" "/Library/Application Support/Google/Chrome/Default/Pepper Data/"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="AppExamplePolicy"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "AppWillLaunch"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:1" "AppDidLaunch"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:2" "AppDidTerminate"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleBool" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleNum" "42"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleString" "Example"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleArray:0" "First"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleArray:1" "Second"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleArray:2" "Third"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="AppFirstSetupFirefox"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "AppWillLaunch"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="AppNetworkFixFirefox"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "AppWillLaunch"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:1" "AppDidTerminate"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---

LCL_PolicyName="AppRestrict"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"


f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "AppWillLaunch"

  # Any Application in the ExceptionList is exempt from Whitelist/BlackList checking
  # This allows you to have Apps that will run from any location without having to implement a whitelist
  # The format is ApplicationName1/ApplicationBundleIdentifier1,ApplicationName2/ApplicationBundleIdentifier2,etc
  # If an application has no ApplicationBundleIdentifier then specify ApplicationName/(null) i.e TextWrangler/(null)
  # Regular expressions can be used.

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExceptionList:0:ApplicationName" "PrinterProxy"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExceptionList:0:ApplicationBundleIdentifier" 'com\.apple\.print\.PrinterProxy'
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExceptionList:1:ApplicationName" ".*"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExceptionList:1:ApplicationBundleIdentifier" "com\.google\.Chrome\.app\..*"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExceptionList:2:ApplicationName" "Citrix Online Launcher"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExceptionList:2:ApplicationBundleIdentifier" "com\.citrixonline\.mac\.WebDeploymentApp"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExceptionList:3:ApplicationName" "GoToMeeting.*"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExceptionList:3:ApplicationBundleIdentifier" "com\.citrixonline\.GoToMeeting"

  
  # If the WhiteList is not null, then these Applications (and only these) are allowed.
  # When the WhiteList is not null, then it should at least contain "Finder/com.apple.Finder" or maybe even ".*/com.apple\..*"
  # Regular expressions can be used.
  
  # Any Application in the comma-separated BlackList is always disallowed for non-admins
  # Regular expressions can be used.

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:BlackList:0:ApplicationName" "Terminal"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:BlackList:0:ApplicationBundleIdentifier" "com\.apple\.Terminal"
  
  # If the comma-separated path WhiteList is not null, then Applications at the specified paths (and only these paths) are allowed.
  # When the path WhiteList is not null, it should at least contain "/Applications/.*,/System/Library/CoreServices/.*"
  # ~/ is expanded to the current user home before comparison.
  # Regular expressions should be used.
  

  # Any application located at a path in this comma-separated path BlackList is always disallowed for non-admins
  # ~/ is expanded to the current user home before comparison.
  # Regular expressions should be used.
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:PathBlackList:0" "~/.*"
  
  # Should we disallow applications running on mounts
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OnlyAllowLocalApps" "true"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="AppShowHints"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "AppDidLaunch"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppHint:0:ApplicationBundleIdentifier" "com.apple.logic10"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppHint:0:IsAdmin" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppHint:0:IsLocalAccount" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppHint:0:IsLocalHome" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppHint:0:MessageTitle" "ON NETWORK"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppHint:0:MessageContent" "APPNAME works better off network"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppHint:1:ApplicationBundleIdentifier" "com.adobe.AdobePremierePro"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppHint:1:MessageTitle" "NOW SET YOUR PREFS"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppHint:1:MessageContent" "Setup your Media Cache File location (Premiere>Preferences>Media)"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppHint:2:ApplicationBundleIdentifier" "com.apple.FinalCutPro"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppHint:2:MessageTitle" "NOW SET YOUR PREFS"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AppHint:2:MessageContent" "Final Cut Pro>System Settings...>Scratch Disks"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
# ALTERNATIVE - STRICT HOURS EARLY CLOSE

LCL_PolicyName="Maintenance"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "LoginWindow"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:1" "LoginWindowIdle"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:2" "UserAtDesktop"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:3" "UserPoll"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:0:OpenTime" ""        # Sun
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:0:CloseTime" ""
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:1:OpenTime" "6:30"    # Mon
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:1:CloseTime" "20:50"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:2:OpenTime" "6:30"    # Tue
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:2:CloseTime" "20:50"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:3:OpenTime" "6:30"    # Wed
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:3:CloseTime" "20:50"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:4:OpenTime" "6:30"    # Thu
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:4:CloseTime" "20:50"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:5:OpenTime" "6:30"    # Fri
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:5:CloseTime" "16:50"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:6:OpenTime" "6:30"    # Sat
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:6:CloseTime" "15:50"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:UpdateMethodArguments:0" "YourUpdateScriptURI"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:UpdateMethodArguments:1" "Param1"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:UpdateMethodArguments:2" "Param2"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:UpdateMethodArguments:3" "Param3"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:UpdateMethodArguments:4" "Param4"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:MaintenanceAgeMaxDays" "10"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:SafetyNetMinutes" "150"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:IdleShutdownInWorkingHours" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:IdleShutdownSecs" "1200"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:StrictWorkingHours" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:LogoutWarningSecs" "600"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---

# ALTERNATIVE - LOOSEWORKING HOURS

LCL_PolicyName="Maintenance"
LCL_Tag="Radmind"

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "LoginWindow"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:1" "LoginWindowIdle"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:2" "UserAtDesktop"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:3" "UserPoll"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:0:OpenTime" ""        # Sun
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:0:CloseTime" ""
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:1:OpenTime" "6:30"    # Mon
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:1:CloseTime" "21:30"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:2:OpenTime" "6:30"    # Tue
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:2:CloseTime" "21:30"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:3:OpenTime" "6:30"    # Wed
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:3:CloseTime" "21:30"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:4:OpenTime" "6:30"    # Thu
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:4:CloseTime" "21:30"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:5:OpenTime" "6:30"    # Fri
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:5:CloseTime" "21:30"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:6:OpenTime" "6:30"    # Sat
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:OpeningHours:6:CloseTime" "21:30"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:UpdateMethodArguments:0" "file://localhost/usr/local/LabWarden/lib/RadmindUpdate"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:UpdateMethodArguments:1" "192.168.0.3,sha1,0,-I,42000"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:MaintenanceAgeMaxDays" "10"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:SafetyNetMinutes" "150"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:IdleShutdownInWorkingHours" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:IdleShutdownSecs" "1200"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:StrictWorkingHours" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:LogoutWarningSecs" "600"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemAddEntriesToHostsFile"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Entry:0:IP4" "127.0.0.1"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Entry:0:Host:0" "prod-w.nexus.live.com.akadns.net"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Entry:0:Host:1" "odc.officeapps.live.com"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Entry:0:Host:2" "omextemplates.content.office.net"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Entry:0:Host:3" "officeclient.microsoft.com"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemDeleteFiles"
LCL_Tag="FlashPlayer"

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:0" "/Applications/Utilities/Adobe Flash Player Install Manager.app/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:1" "/Library/Application Support/Adobe/Flash Player Install Manager/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:2" "/Library/Internet Plug-Ins/Flash Player.plugin/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:3" "/Library/Internet Plug-Ins/PepperFlashPlayer/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:4" "/Library/LaunchDaemons/com.adobe.fpsaud.plist"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:5" "/Library/PreferencePanes/Flash Player.prefPane/"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemDeleteOldUserProfiles"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "LoginWindowIdle"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:LoginMaxAgeDays" 62
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:UserCacheEarliestEpoch" 1462365175

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemGiveSystemProxyAccess"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Proxy:0:ProxyProtocol" "http"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Proxy:0:ProxyAddress" "PROXYADDRESS"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Proxy:0:ProxyPort" "PROXYPORT"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Proxy:0:Process:0" "/usr/sbin/ocspd"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Proxy:1:ProxyProtocol" "htps"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Proxy:1:ProxyAddress" "PROXYADDRESS"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Proxy:1:ProxyPort" "PROXYPORT"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Proxy:1:Process:0" "/usr/sbin/ocspd"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemInstallPackageFromFolder"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "LoginWindowIdle"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:0" "/usr/local/Updates"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---

# ALTERNATIVE - PROXY, AUTO

LCL_PolicyName="SystemNetworkProxy"
LCL_Tag="AutoProxy"

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "NetworkUp"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ProxyAutoDiscovery:Enabled" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AutoProxy:Enabled" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AutoProxy:URL" ""
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:WebProxy:Enabled" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:WebProxy:Address" ""
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:WebProxy:Port" "8080"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:SecureWebProxy:Enabled" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:SecureWebProxy:Address" ""
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:SecureWebProxy:Port" "8080"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:StreamingProxy:Enabled" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:StreamingProxy:Address" ""
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:StreamingProxy:Port" "8080"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:FTPProxy:Enabled" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:FTPProxy:Address" ""
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:FTPProxy:Port" "8080"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:SOCKSProxy:Enabled" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:SOCKSProxy:Address" ""
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:SOCKSProxy:Port" "8080"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:GopherProxy:Enabled" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:GopherProxy:Address" ""
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:GopherProxy:Port" "8080"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ProxyBypassDomains:0" "*.local"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ProxyBypassDomains:1" "169.254/16"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ProxyBypassDomains:2" "127.0.0.1"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ProxyBypassDomains:3" "localhost"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemEstablish8021XWiFi"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "NetworkUp"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:RenewCertBeforeDays" "28"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:RevokeCertBeforeEpoch" "0"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:CertTemplate" "Mac-Computer"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:CertAuthURL" "https://yourcaserer.yourdomain/certsrv"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:SSIDSTR" "YourSSID"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ProxyType" "Auto"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemExamplePolicy"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleBool" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleNum" "42"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleString" "Example"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleArray:0" "First"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleArray:1" "Second"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleArray:2" "Third"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemRestartIfNetMount"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "LoginWindow"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemSleepSettings"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "LoginWindow"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:1" "LoginBegin"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:LoginWindow:Power:SystemSleep" 0
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:LoginWindow:Power:DisplaySleep" 10
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:LoginWindow:Power:DiskSleep" 15
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:LoginWindow:Battery:SystemSleep" 0
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:LoginWindow:Battery:DisplaySleep" 1
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:LoginWindow:Battery:DiskSleep" 2

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:LoginBegin:Power:SystemSleep" 0
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:LoginBegin:Power:DisplaySleep" 10
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:LoginBegin:Power:DiskSleep" 15
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:LoginBegin:Battery:SystemSleep" 12
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:LoginBegin:Battery:DisplaySleep" 1
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:LoginBegin:Battery:DiskSleep" 2

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemTimeServer"
LCL_Tag="Apple"

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:TimeServer" "time.euro.apple.com"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:TimeZone" "Europe/London"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemUnloadAgentsAndDaemons"
LCL_Tag="ProxyPopup"

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Unload:0" "/System/Library/LaunchDaemons/com.apple.UserNotificationCenter.plist"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemUserExperience"
LCL_Tag="HomeForceLocal"

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:mobile" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:mobileconfirm" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:localhome" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:sharepoint" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:useuncpath" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:protocol" "smb"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:alldomains" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:preferredserver" ""

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemUserExperience"
LCL_Tag="Mobile"

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:mobile" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:mobileconfirm" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:localhome" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:sharepoint" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:useuncpath" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:protocol" "smb"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:alldomains" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:preferredserver" ""

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemUserExperience"
LCL_Tag="HomeOnNetwork"

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:mobile" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:mobileconfirm" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:localhome" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:sharepoint" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:useuncpath" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:protocol" "smb"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:alldomains" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:preferredserver" ""

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemWirelessForgetSSID"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:SSID:0" "College"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:SSID:1" "virginmedia1234567"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemWirelessSetState"
LCL_Tag="off"

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:WirelessState" "off"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:RequireAdminIBSS" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:RequireAdminNetworkChange" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:RequireAdminPowerToggle" "true"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="SystemWirelessSetState"
LCL_Tag="on"

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:WirelessState" "on"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:RequireAdminIBSS" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:RequireAdminNetworkChange" "false"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:RequireAdminPowerToggle" "true"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="UserCheckQuotaOnNetHome"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "UserPoll"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="UserCreateFolder"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "UserLogin"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:0" "/Desktop/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:1" "/Documents/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:2" "/Downloads/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:3" "/Library/Preferences/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:4" "/Movies/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:5" "/Music/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:6" "/Pictures/"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="UserDefaultHandlers"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Handler:0:BundleID" "com.apple.Safari"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Handler:0:UTI" "public.html"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Handler:0:Role" "all"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Handler:1:BundleID" "com.apple.Safari"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Handler:1:UTI" "public.xhtml"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Handler:1:Role" "all"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Handler:2:BundleID" "com.apple.Safari"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Handler:2:UTI" "http"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Handler:3:BundleID" "com.apple.Safari"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Handler:3:UTI" "https"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Handler:4:BundleID" "cx.c3.theunarchiver"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Handler:4:UTI" "zip"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Handler:4:Role" "all"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
# ALTERNATIVE - DESKTOP WALLPAPER
LCL_PolicyName="UserDesktopWallpaperURI"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:DesktopWallpaperURI" "smb://YOURSERVER/YOURSHARE/YOURFOLDER/desktop.bmp"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="UserExamplePolicy"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleBool" "true"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleNum" "42"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleString" "Example"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleArray:0" "First"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleArray:1" "Second"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:ExampleArray:2" "Third"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="UserKeychainFix"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="UserNoSpotlightOnNetHome"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="UserRedirLocalHomeToNetwork"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:NetworkHomeLinkName" "_H-Drive"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:0" "/Desktop/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:1" "/Documents/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:2" "/Movies/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:3" "/Music/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:4" "/Pictures/"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="UserRedirNetworkHomeToLocal"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "UserLogin"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:0" "/Library/Application Support/audacity/.audacity.sock"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:1" "/Library/Application Support/CrashReporter/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:2" "/Library/Caches/com.apple.helpd/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:3" "/Library/Calendars/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:4" "/Library/com.apple.nsurlsessiond/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:5" "/Library/Containers/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:6" "/Library/IdentityServices/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:7" "/Library/Keychains/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:8" "/Library/Logs/DiagnosticReports/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:9" "/Library/Messages/"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="UserSidebarList"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:DeleteItem:0" "All My Files"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:DeleteItem:1" "iCloud"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:DeleteItem:2" "iCloud Drive"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:DeleteItem:3" "AirDrop"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AddItem:0" "file:///Applications"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AddItem:1" "file://HOMEDIR"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AddItem:2" "file://HOMEDIR/Desktop"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AddItem:3" "file://HOMEDIR/Documents"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AddItem:4" "file://HOMEDIR/Downloads"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AddItem:5" "file://HOMEDIR/Movies"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AddItem:6" "file://HOMEDIR/Music"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:AddItem:7" "file://HOMEDIR/Pictures"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="UserSyncLocalHomeToNetwork"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:1" "UserLogout"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:0" "/Library/Fonts/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:1" "/Library/Application Support/Firefox/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:2" "/Library/Application Support/Google/Chrome/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:3" "/Library/Application Support/Chromium/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:4" "/Library/Safari/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:5" "/Library/Application Support/Microsoft/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:6" "/Library/Application Support/Spotify/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:7" "/Library/Caches/com.apple.helpd/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:8" "/Library/Group Containers/"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:9" "/Library/Preferences/com.microsoft.autoupdate2.plist"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:10" "/Library/Preferences/com.microsoft.error_reporting.plist"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:11" "/Library/Preferences/com.microsoft.office.plist"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:12" "/Library/Preferences/com.microsoft.outlook.databasedaemon.plist"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:13" "/Library/Preferences/com.microsoft.Word.plist"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:14" "/Library/Preferences/com.microsoft.office.plist"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:15" "/Library/Preferences/com.microsoft.Powerpoint.plist"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:16" "/Library/Preferences/com.microsoft.Excel.plist"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:17" "/Library/Preferences/com.microsoft.office.plist"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:18" "/Library/Preferences/com.microsoft.outlook.office_reminders.plist"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Path:19" "/Library/Preferences/com.microsoft.Outlook.plist"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PolicyName="Debug"
LCL_Tag=""

if test -z "${LCL_Tag}"
then
  LCL_PayloadName="${LCL_PolicyName}"
else
  LCL_PayloadName="${LCL_PolicyName}-${LCL_Tag}"
fi

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Policy"

f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:0" "Boot"
f_SetPlistProperty "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist" ":TriggeredBy:1" "UserAtDesktop"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigLabDir}/${LCL_PayloadName}.LabWarden.plist"

# ---

LCL_PayloadName="Marketing-Laser2020"

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Printer"

f_SetPlistProperty "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:PPDURI" "file://localhost/Library/Printers/PPDs/Contents/Resources/HP Color LaserJet CP2020 Series.gz"
f_SetPlistProperty "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:PrinterURI" "smb://PRINTSRV.example.com/Marketing-Laser2020"
f_SetPlistProperty "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Options" "-o printer-is-shared=false -o printer-error-policy=abort-job -o PageSize=A4 -o HPBookletPageSize=A4"
f_SetPlistProperty "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Location" "Marketing"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist"

# ---
LCL_PayloadName="Marketing-Laser2020-direct"

LCL_PayloadUUID=$(uuidgen)
rm -f "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist"

f_SetPlistProperty "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist" ":Name" "${LCL_PolicyName}"
f_SetPlistProperty "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist" ":UUID" "${LCL_PayloadUUID}"
f_SetPlistProperty "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist" ":Type" "Printer"

f_SetPlistProperty "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:PPDURI" "file://localhost/Library/Printers/PPDs/Contents/Resources/HP Color LaserJet CP2020 Series.gz"
f_SetPlistProperty "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:PrinterURI" "lpd://192.168.0.5/"
f_SetPlistProperty "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Options" "-o printer-is-shared=false -o printer-error-policy=abort-job -o PageSize=A4 -o HPBookletPageSize=A4"
f_SetPlistProperty "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist" ":Config:Location" "Marketing"

/usr/local/LabWarden/util/PackForDeployment "${GLB_ConfigPtrDir}/${LCL_PayloadName}.LabWarden.plist"

# ---

# Remove temporary files
srm -fR "${GLB_ThisScriptTempDir}"

