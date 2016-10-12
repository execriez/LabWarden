#!/bin/bash
#
# Short:    Initialise the LabWarden configs
# Author:   Mark J Swift
# Version:  1.0.98
# Modified: 11-Oct-2016
#

# ---

# Change working directory to the location of this script
cd "$(dirname "${0}")"

# ---

# Load the library, only if it is not already loaded
if test -z "${LW_sv_LabWardenVersion}"
then
  . /usr/local/LabWarden/lib/CommonLib
fi

# ---

sv_ExampleConfigDirPath=~/Desktop/LabWardenConfigs/Examples

sv_ConfigLabDirPath="${sv_ExampleConfigDirPath}/PolicyConfig"
mkdir -p "${sv_ConfigLabDirPath}"

sv_ConfigPtrDirPath="${sv_ExampleConfigDirPath}/PrinterConfig"
mkdir -p "${sv_ConfigPtrDirPath}"

# ---
sv_PolicyName="AppDeleteDataOnQuit"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "AppDidTerminate"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppData:0:ApplicationBundleIdentifier" "com.apple.finder"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppData:0:Path:0" "/.Trash/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppData:1:ApplicationBundleIdentifier" "com.adobe.AdobePremierePro"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppData:1:Path:0" "/Library/Application Support/Adobe/Common/Media Cache Files/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppData:1:Path:1" "/Library/Application Support/Adobe/Common/Media Cache/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppData:2:ApplicationBundleIdentifier" "org.chromium.Chromium"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppData:2:Path:0" "/Library/Application Support/Chromium/Default/Pepper Data/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppData:3:ApplicationBundleIdentifier" "com.google.Chrome"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppData:3:Path:0" "/Library/Application Support/Google/Chrome/Default/Pepper Data/"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="AppExamplePolicy"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "AppWillLaunch"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:1" "AppDidLaunch"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:2" "AppDidTerminate"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleBool" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleNum" "42"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleString" "Example"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleArray:0" "First"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleArray:1" "Second"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleArray:2" "Third"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="AppFirstSetupFirefox"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "AppWillLaunch"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="AppNetworkFixFirefox"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "AppWillLaunch"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:1" "AppDidTerminate"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---

sv_PolicyName="AppRestrict"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"


LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "AppWillLaunch"

  # Any Application in the ExceptionList is exempt from Whitelist/BlackList checking
  # This allows you to have Apps that will run from any location without having to implement a whitelist
  # The format is ApplicationName1/ApplicationBundleIdentifier1,ApplicationName2/ApplicationBundleIdentifier2,etc
  # If an application has no ApplicationBundleIdentifier then specify ApplicationName/(null) i.e TextWrangler/(null)
  # Regular expressions can be used.

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExceptionList:0:ApplicationName" "PrinterProxy"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExceptionList:0:ApplicationBundleIdentifier" 'com\.apple\.print\.PrinterProxy'
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExceptionList:1:ApplicationName" ".*"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExceptionList:1:ApplicationBundleIdentifier" "com\.google\.Chrome\.app\..*"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExceptionList:2:ApplicationName" "Citrix Online Launcher"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExceptionList:2:ApplicationBundleIdentifier" "com\.citrixonline\.mac\.WebDeploymentApp"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExceptionList:3:ApplicationName" "GoToMeeting.*"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExceptionList:3:ApplicationBundleIdentifier" "com\.citrixonline\.GoToMeeting"

  
  # If the WhiteList is not null, then these Applications (and only these) are allowed.
  # When the WhiteList is not null, then it should at least contain "Finder/com.apple.Finder" or maybe even ".*/com.apple\..*"
  # Regular expressions can be used.
  
  # Any Application in the comma-separated BlackList is always disallowed for non-admins
  # Regular expressions can be used.

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:BlackList:0:ApplicationName" "Terminal"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:BlackList:0:ApplicationBundleIdentifier" "com\.apple\.Terminal"
  
  # If the comma-separated path WhiteList is not null, then Applications at the specified paths (and only these paths) are allowed.
  # When the path WhiteList is not null, it should at least contain "/Applications/.*,/System/Library/CoreServices/.*"
  # ~/ is expanded to the current user home before comparison.
  # Regular expressions should be used.
  

  # Any application located at a path in this comma-separated path BlackList is always disallowed for non-admins
  # ~/ is expanded to the current user home before comparison.
  # Regular expressions should be used.
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:PathBlackList:0" "~/.*"
  
  # Should we disallow applications running on mounts
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OnlyAllowLocalApps" "true"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="AppShowHints"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "AppDidLaunch"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppHint:0:ApplicationBundleIdentifier" "com.apple.logic10"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppHint:0:IsAdmin" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppHint:0:IsLocalAccount" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppHint:0:IsLocalHome" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppHint:0:MessageTitle" "ON NETWORK"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppHint:0:MessageContent" "APPNAME works better off network"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppHint:1:ApplicationBundleIdentifier" "com.adobe.AdobePremierePro"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppHint:1:MessageTitle" "NOW SET YOUR PREFS"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppHint:1:MessageContent" "Setup your Media Cache File location (Premiere>Preferences>Media)"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppHint:2:ApplicationBundleIdentifier" "com.apple.FinalCutPro"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppHint:2:MessageTitle" "NOW SET YOUR PREFS"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AppHint:2:MessageContent" "Final Cut Pro>System Settings...>Scratch Disks"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
# ALTERNATIVE - STRICT HOURS EARLY CLOSE

sv_PolicyName="Maintenance"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "LoginWindow"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:1" "LoginWindowIdle"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:2" "UserAtDesktop"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:3" "UserPoll"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:0:OpenTime" ""        # Sun
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:0:CloseTime" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:1:OpenTime" "6:30"    # Mon
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:1:CloseTime" "20:50"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:2:OpenTime" "6:30"    # Tue
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:2:CloseTime" "20:50"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:3:OpenTime" "6:30"    # Wed
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:3:CloseTime" "20:50"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:4:OpenTime" "6:30"    # Thu
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:4:CloseTime" "20:50"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:5:OpenTime" "6:30"    # Fri
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:5:CloseTime" "16:50"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:6:OpenTime" "6:30"    # Sat
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:6:CloseTime" "15:50"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:UpdateMethodArguments:0" "YourUpdateScriptURI"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:UpdateMethodArguments:1" "Param1"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:UpdateMethodArguments:2" "Param2"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:UpdateMethodArguments:3" "Param3"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:UpdateMethodArguments:4" "Param4"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:MaintenanceAgeMaxDays" "10"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:SafetyNetMinutes" "150"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:IdleShutdownInWorkingHours" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:IdleShutdownSecs" "1200"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:StrictWorkingHours" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:LogoutWarningSecs" "600"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---

# ALTERNATIVE - LOOSEWORKING HOURS

sv_PolicyName="Maintenance"
sv_Tag="Radmind"

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "LoginWindow"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:1" "LoginWindowIdle"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:2" "UserAtDesktop"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:3" "UserPoll"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:0:OpenTime" ""        # Sun
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:0:CloseTime" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:1:OpenTime" "6:30"    # Mon
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:1:CloseTime" "21:30"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:2:OpenTime" "6:30"    # Tue
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:2:CloseTime" "21:30"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:3:OpenTime" "6:30"    # Wed
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:3:CloseTime" "21:30"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:4:OpenTime" "6:30"    # Thu
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:4:CloseTime" "21:30"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:5:OpenTime" "6:30"    # Fri
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:5:CloseTime" "21:30"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:6:OpenTime" "6:30"    # Sat
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:OpeningHours:6:CloseTime" "21:30"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:UpdateMethodArguments:0" "file://localhost/usr/local/LabWarden/lib/RadmindUpdate"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:UpdateMethodArguments:1" "192.168.0.3,sha1,0,-I,42000"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:MaintenanceAgeMaxDays" "10"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:SafetyNetMinutes" "150"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:IdleShutdownInWorkingHours" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:IdleShutdownSecs" "1200"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:StrictWorkingHours" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:LogoutWarningSecs" "600"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemAddEntriesToHostsFile"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Entry:0:IP4" "127.0.0.1"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Entry:0:Host:0" "prod-w.nexus.live.com.akadns.net"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Entry:0:Host:1" "odc.officeapps.live.com"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Entry:0:Host:2" "omextemplates.content.office.net"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Entry:0:Host:3" "officeclient.microsoft.com"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Entry:0:Host:4" "store.office.com"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Entry:0:Host:5" "nexusrules.officeapps.live.com"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Entry:0:Host:6" "nexus.officeapps.live.com"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemDeleteFiles"
sv_Tag="FlashPlayer"

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:0" "/Applications/Utilities/Adobe Flash Player Install Manager.app/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:1" "/Library/Application Support/Adobe/Flash Player Install Manager/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:2" "/Library/Internet Plug-Ins/Flash Player.plugin/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:3" "/Library/Internet Plug-Ins/PepperFlashPlayer/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:4" "/Library/LaunchDaemons/com.adobe.fpsaud.plist"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:5" "/Library/PreferencePanes/Flash Player.prefPane/"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemDeleteOldUserProfiles"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "LoginWindowIdle"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:LoginMaxAgeDays" 62
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:UserCacheEarliestEpoch" 1462365175

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemGiveSystemProxyAccess"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Proxy:0:ProxyProtocol" "http"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Proxy:0:ProxyAddress" "PROXYADDRESS"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Proxy:0:ProxyPort" "PROXYPORT"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Proxy:0:Process:0" "/usr/sbin/ocspd"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Proxy:1:ProxyProtocol" "htps"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Proxy:1:ProxyAddress" "PROXYADDRESS"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Proxy:1:ProxyPort" "PROXYPORT"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Proxy:1:Process:0" "/usr/sbin/ocspd"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemInstallPackageFromFolder"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "LoginWindowIdle"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:0" "/usr/local/Updates"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---

# ALTERNATIVE - PROXY, AUTO

sv_PolicyName="SystemNetworkProxy"
sv_Tag="AutoProxy"

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "NetworkUp"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ProxyAutoDiscovery:Enabled" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AutoProxy:Enabled" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AutoProxy:URL" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:WebProxy:Enabled" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:WebProxy:Address" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:WebProxy:Port" "8080"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:SecureWebProxy:Enabled" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:SecureWebProxy:Address" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:SecureWebProxy:Port" "8080"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:StreamingProxy:Enabled" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:StreamingProxy:Address" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:StreamingProxy:Port" "8080"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:FTPProxy:Enabled" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:FTPProxy:Address" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:FTPProxy:Port" "8080"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:SOCKSProxy:Enabled" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:SOCKSProxy:Address" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:SOCKSProxy:Port" "8080"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:GopherProxy:Enabled" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:GopherProxy:Address" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:GopherProxy:Port" "8080"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ProxyBypassDomains:0" "*.local"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ProxyBypassDomains:1" "169.254/16"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ProxyBypassDomains:2" "127.0.0.1"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ProxyBypassDomains:3" "localhost"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemEstablish8021XWiFi"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "NetworkUp"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:RenewCertBeforeDays" "28"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:RevokeCertBeforeEpoch" "0"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:CertTemplate" "Mac-Computer"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:CertAuthURL" "https://yourcaserer.yourdomain/certsrv"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:SSIDSTR" "YourSSID"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ProxyType" "Auto"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemExamplePolicy"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleBool" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleNum" "42"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleString" "Example"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleArray:0" "First"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleArray:1" "Second"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleArray:2" "Third"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemRestartIfNetMount"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "LoginWindow"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemSleepSettings"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "LoginWindow"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:1" "LoginBegin"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:LoginBegin:Battery:DiskSleep" 3
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:LoginBegin:Battery:DisplaySleep" 2
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:LoginBegin:Battery:SystemSleep" 15
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:LoginBegin:Power:DiskSleep" 15
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:LoginBegin:Power:DisplaySleep" 10
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:LoginBegin:Power:SystemSleep" 0

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:LoginWindow:Battery:DiskSleep" 3
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:LoginWindow:Battery:DisplaySleep" 2
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:LoginWindow:Battery:SystemSleep" 0
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:LoginWindow:Power:DiskSleep" 15
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:LoginWindow:Power:DisplaySleep" 10
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:LoginWindow:Power:SystemSleep" 0

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemTimeServer"
sv_Tag="Apple"

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:TimeServer" "time.euro.apple.com"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:TimeZone" "Europe/London"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemUnloadAgentsAndDaemons"
sv_Tag="ProxyPopup"

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Unload:0" "/System/Library/LaunchDaemons/com.apple.UserNotificationCenter.plist"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemUserExperience"
sv_Tag="HomeForceLocal"

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:mobile" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:mobileconfirm" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:localhome" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:sharepoint" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:useuncpath" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:protocol" "smb"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:alldomains" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:preferredserver" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemUserExperience"
sv_Tag="Mobile"

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:mobile" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:mobileconfirm" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:localhome" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:sharepoint" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:useuncpath" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:protocol" "smb"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:alldomains" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:preferredserver" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemUserExperience"
sv_Tag="HomeOnNetwork"

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:mobile" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:mobileconfirm" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:localhome" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:sharepoint" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:useuncpath" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:protocol" "smb"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:alldomains" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:preferredserver" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemWirelessForgetSSID"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:SSID:0" "College"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:SSID:1" "virginmedia1234567"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemWirelessSetState"
sv_Tag="off"

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:WirelessState" "off"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:RequireAdminIBSS" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:RequireAdminNetworkChange" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:RequireAdminPowerToggle" "true"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="SystemWirelessSetState"
sv_Tag="on"

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "Boot"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:WirelessState" "on"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:RequireAdminIBSS" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:RequireAdminNetworkChange" "false"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:RequireAdminPowerToggle" "true"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="UserCheckQuotaOnNetHome"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "UserPoll"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="UserCreateFolder"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "UserLogin"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:0" "/Desktop/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:1" "/Documents/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:2" "/Downloads/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:3" "/Library/Preferences/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:4" "/Movies/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:5" "/Music/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:6" "/Pictures/"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="UserDefaultHandlers"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Handler:0:BundleID" "com.apple.Safari"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Handler:0:UTI" "public.html"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Handler:0:Role" "all"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Handler:1:BundleID" "com.apple.Safari"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Handler:1:UTI" "public.xhtml"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Handler:1:Role" "all"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Handler:2:BundleID" "com.apple.Safari"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Handler:2:UTI" "http"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Handler:3:BundleID" "com.apple.Safari"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Handler:3:UTI" "https"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Handler:4:BundleID" "cx.c3.theunarchiver"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Handler:4:UTI" "zip"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Handler:4:Role" "all"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
# ALTERNATIVE - DESKTOP WALLPAPER
sv_PolicyName="UserDesktopWallpaperURI"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:DesktopWallpaperURI" "smb://YOURSERVER/YOURSHARE/YOURFOLDER/desktop.bmp"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="UserExamplePolicy"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleBool" "true"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleNum" "42"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleString" "Example"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleArray:0" "First"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleArray:1" "Second"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:ExampleArray:2" "Third"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="UserKeychainFix"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="UserNoSpotlightOnNetHome"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="UserHomeMakePathRedirections"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "UserLogin"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:1" "UserAtDesktop"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:MakePathRedirections" "true"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:HomeIsLocal:Path:0" "/Desktop/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:HomeIsLocal:Path:1" "/Documents/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:HomeIsLocal:Path:2" "/Movies/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:HomeIsLocal:Path:3" "/Music/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:HomeIsLocal:Path:4" "/Pictures/"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:HomeIsOnNetwork:Path:0" "/Library/Application Support/audacity/.audacity.sock"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:HomeIsOnNetwork:Path:1" "/Library/Application Support/CrashReporter/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:HomeIsOnNetwork:Path:2" "/Library/Caches/com.apple.helpd/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:HomeIsOnNetwork:Path:3" "/Library/Calendars/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:HomeIsOnNetwork:Path:4" "/Library/com.apple.nsurlsessiond/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:HomeIsOnNetwork:Path:5" "/Library/Containers/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:HomeIsOnNetwork:Path:6" "/Library/IdentityServices/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:HomeIsOnNetwork:Path:7" "/Library/Keychains/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:HomeIsOnNetwork:Path:8" "/Library/Logs/DiagnosticReports/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:HomeIsOnNetwork:Path:9" "/Library/Messages/"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="UserSidebarContent"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Replace" "false"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:0:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:0:Label" "All My Files"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:1:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:1:Label" "iCloud"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:2:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:2:Label" "AirDrop"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:0:URI" "file://HOMEDIR"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:0:Label" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:1:URI" "file://HOMEDIR/Desktop"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:1:Label" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:2:URI" "file://HOMEDIR/Documents"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:2:Label" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:3:URI" "file://HOMEDIR/Downloads"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:3:Label" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:4:URI" "file://HOMEDIR/Movies"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:4:Label" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:5:URI" "file://HOMEDIR/Music"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:5:Label" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:6:URI" "file://HOMEDIR/Pictures"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:6:Label" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="UserDockContent"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Replace" "false"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:0:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:0:Label" "Mail"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:1:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:1:Label" "Contacts"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:2:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:2:Label" "Calendar"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:3:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:3:Label" "Notes"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:4:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:4:Label" "Reminders"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:5:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:5:Label" "Messages"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:6:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:6:Label" "FaceTime"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:7:URI" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Remove:7:Label" "App Store"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:0:URI" "file://HOMEDIR"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:0:Label" ""
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:1:URI" "file://HOMEDIR/Downloads"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Add:1:Label" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="UserSidebarList"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:DeleteItem:0" "All My Files"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:DeleteItem:1" "iCloud"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:DeleteItem:2" "iCloud Drive"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:DeleteItem:3" "AirDrop"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AddItem:0" "file:///Applications"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AddItem:1" "file://HOMEDIR"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AddItem:2" "file://HOMEDIR/Desktop"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AddItem:3" "file://HOMEDIR/Documents"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AddItem:4" "file://HOMEDIR/Downloads"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AddItem:5" "file://HOMEDIR/Movies"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AddItem:6" "file://HOMEDIR/Music"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:AddItem:7" "file://HOMEDIR/Pictures"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="UserSyncLocalHomeToNetwork"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "UserAtDesktop"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:1" "UserLogout"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:0" "/Library/Fonts/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:1" "/Library/Application Support/Firefox/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:2" "/Library/Application Support/Google/Chrome/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:3" "/Library/Application Support/Chromium/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:4" "/Library/Safari/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:5" "/Library/Application Support/Microsoft/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:6" "/Library/Application Support/Spotify/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:7" "/Library/Caches/com.apple.helpd/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:8" "/Library/Group Containers/"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:9" "/Library/Preferences/com.microsoft.autoupdate2.plist"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:10" "/Library/Preferences/com.microsoft.error_reporting.plist"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:11" "/Library/Preferences/com.microsoft.office.plist"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:12" "/Library/Preferences/com.microsoft.outlook.databasedaemon.plist"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:13" "/Library/Preferences/com.microsoft.Word.plist"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:14" "/Library/Preferences/com.microsoft.office.plist"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:15" "/Library/Preferences/com.microsoft.Powerpoint.plist"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:16" "/Library/Preferences/com.microsoft.Excel.plist"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:17" "/Library/Preferences/com.microsoft.office.plist"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:18" "/Library/Preferences/com.microsoft.outlook.office_reminders.plist"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Path:19" "/Library/Preferences/com.microsoft.Outlook.plist"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
# Policy that deploys the mounthome.sh script from https://github.com/amsysuk/public_scripts
# Script should be renamed to "mounthome" and placed in "/usr/local/LabWarden/Policies/custom"
# The mounthome script has no configurable options so can be used as-is
sv_PolicyName="mounthome"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "UserLogin"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="Debug"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Policy"

LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:0" "Boot"
LW_nf_SetPlistProperty "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":TriggeredBy:1" "UserAtDesktop"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigLabDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---

sv_PolicyName="Marketing-Laser2020"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Printer"

LW_nf_SetPlistProperty "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:PPDURI" "file://localhost/Library/Printers/PPDs/Contents/Resources/HP Color LaserJet CP2020 Series.gz"
LW_nf_SetPlistProperty "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:PrinterURI" "smb://PRINTSRV.example.com/Marketing-Laser2020"
LW_nf_SetPlistProperty "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Options" "-o printer-is-shared=false -o printer-error-policy=abort-job -o PageSize=A4 -o HPBookletPageSize=A4"
LW_nf_SetPlistProperty "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Location" "Marketing"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---
sv_PolicyName="Marketing-Laser2020-direct"
sv_Tag=""

if test -z "${sv_Tag}"
then
  sv_PayloadFileName="${sv_PolicyName}"
else
  sv_PayloadFileName="${sv_PolicyName}-${sv_Tag}"
fi

sv_PayloadUUID=$(uuidgen)
rm -f "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist"

LW_nf_SetPlistProperty "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Name" "${sv_PolicyName}"
LW_nf_SetPlistProperty "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":UUID" "${sv_PayloadUUID}"
LW_nf_SetPlistProperty "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Type" "Printer"

LW_nf_SetPlistProperty "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:PPDURI" "file://localhost/Library/Printers/PPDs/Contents/Resources/HP Color LaserJet CP2020 Series.gz"
LW_nf_SetPlistProperty "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:PrinterURI" "lpd://192.168.0.5/"
LW_nf_SetPlistProperty "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Options" "-o printer-is-shared=false -o printer-error-policy=abort-job -o PageSize=A4 -o HPBookletPageSize=A4"
LW_nf_SetPlistProperty "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist" ":Config:Location" "Marketing"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigPtrDirPath}/${sv_PayloadFileName}.LabWarden.plist"

# ---

# Remove temporary files
rm -fPR "${LW_sv_ThisScriptTempDirPath}"

