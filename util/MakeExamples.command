#!/bin/bash
#
# Short:    Initialise the LabWarden configs
# Author:   Mark J Swift
# Version:  2.0.19
# Modified: 22-Oct-2017
#

# ---

sv_CodeVersion="2.0.19"

# ---

# Change working directory to the location of this script
cd "$(dirname "${0}")"

# ---

# Load the library, only if it is not already loaded
if test -z "${GLB_sv_ProjectSignature}"
then
  . /usr/local/LabWarden/inc/Common.sh
fi

# ---

sv_ConfigType="MobileConfig"

sv_ConfigLabDirPath=~/Desktop/${GLB_sv_ProjectInitials}-Examples/${sv_ConfigType}/${GLB_sv_ProjectName}
mkdir -p "${sv_ConfigLabDirPath}"

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
    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":UUID" "${sv_PayloadUUID}"
    sv_PropertyBase=""
    ;;
    
  MobileConfig)
    sv_ConfigFilePath="${sv_ConfigDirPath}/LW-${sv_ConfigFileName}.mobileconfig"
    rm -f "${sv_ConfigFilePath}"
    sv_PayloadIdentifier=$(uuidgen)
    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadContent:0:PayloadUUID" "${sv_PayloadUUID}"
    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadContent:0:PayloadIdentifier" "${sv_PayloadUUID}"
    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadContent:0:PayloadType" "${GLB_sv_ProjectSignature}"
    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadContent:0:PayloadVersion" "1"
#    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadContent:0:PayloadContent:${GLB_sv_ProjectSignature}:Set-Once:0:mcx_preference_settings:${sv_PayloadUUID}" "DICT"
    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadContent:0:${sv_PayloadUUID}" "DICT"
    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadContent:0:PayloadEnabled" "true"
    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadUUID" "${sv_PayloadIdentifier}"
    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadIdentifier" "${sv_PayloadIdentifier}"
    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadType" "Configuration"
    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadVersion" "1"
    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadDescription" ""
    if test -z "${sv_Tag}"
    then
      GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadDisplayName" "${GLB_sv_ProjectInitials} ${sv_PolicyName}"
    else
      GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadDisplayName" "${GLB_sv_ProjectInitials} ${sv_PolicyName} (${sv_Tag})"
    fi
    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadOrganization" ""
    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadRemovalDisallowed" "true"
    GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" ":PayloadScope" "System"
#    sv_PropertyBase=":PayloadContent:0:PayloadContent:${GLB_sv_ProjectSignature}:Set-Once:0:mcx_preference_settings:${sv_PayloadUUID}"
    sv_PropertyBase=":PayloadContent:0:${sv_PayloadUUID}"
    ;;
    
  esac
  
  echo "${sv_ConfigFilePath},${sv_PropertyBase}"
}

# ---

sv_ConfigDirPath="${sv_ConfigLabDirPath}"

# ---

sv_PolicyName="Usr-SyncLocalHomeToNetwork"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Usr-AtDesktop"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Usr-Poll"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SafeFlag" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:0" "/Library/Fonts/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:1" "/Library/Application Support/Chromium/Default/Bookmarks"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:2" "/Library/Application Support/Chromium/Default/Current Tabs"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:3" "/Library/Application Support/Chromium/Default/History"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:4" "/Library/Application Support/Chromium/Default/Preferences"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:5" "/Library/Application Support/Chromium/First Run"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:6" "/Library/Application Support/Google/Chrome/Default/Bookmarks"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:7" "/Library/Application Support/Google/Chrome/Default/Current Tabs"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:8" "/Library/Application Support/Google/Chrome/Default/History"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:9" "/Library/Application Support/Google/Chrome/Default/Preferences"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:10" "/Library/Application Support/Google/Chrome/First Run"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:11" "/Library/Application Support/Firefox/profiles.ini"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:12" "/Library/Application Support/Firefox/Profiles/mozilla.default/bookmarkbackups/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:13" "/Library/Application Support/Firefox/Profiles/mozilla.default/places.sqlite"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:14" "/Library/Application Support/Firefox/Profiles/mozilla.default/prefs.js"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:15" "/Library/Safari/Bookmarks.plist"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:16" "/Library/Safari/History.db"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:17" "/Library/Safari/TopSites.plist"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
exit 0
# ---
sv_PolicyName="Sys-DeleteOldUserProfiles"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Poll"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:DeleteMobileAccounts" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:MinDiskSpaceMegs" 2048
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginMinAgeDays" 8
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginMaxAgeDays" 62
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:UserCacheEarliestEpoch" 1462365175

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"
# ---
exit 0
# ---

sv_PolicyName="Sys-UpdatePackage"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Idle"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Sys-ManualTrigger"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Package:0:ID" "${GLB_sv_ProjectSignature}"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Package:0:VersionString" "2.0.20"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Package:0:URI" "https://raw.githubusercontent.com/execriez/LabWarden/master/SupportFiles/LabWarden.pkg"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---

sv_PolicyName="Sys-UpdatePackage"
sv_Tag="netlogon"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Idle"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Sys-ManualTrigger"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Package:0:ID" "${GLB_sv_ProjectSignature}"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Package:0:VersionString" "2.0.20"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Package:0:URI" "smb://%DOMAIN%/NETLOGON/MacOS/Packages/LabWarden.pkg"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
exit 0
# ---

sv_PolicyName="App-PrefsPrimer"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "App-WillLaunch"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
exit 0
# ---

sv_PolicyName="Sys-RestartAfterLongSleep"
sv_Tag="3hr"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-WillSleep"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Sys-WillWake"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LongSleepMins" "180"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
exit 0
# ---
sv_PolicyName="Usr-DeleteFiles"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Usr-AtDesktop"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Usr-Idle"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SafeFlag" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Delete:0:Path" "/Library/LaunchAgents/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Delete:0:Exclude:0" "org.virtualbox.vboxwebsrv.plist"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
exit 0
# ---
sv_PolicyName="Usr-DockContent"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Usr-AtDesktop"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Replace" "false"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:0:URI" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:0:Label" "Mail"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:1:URI" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:1:Label" "Contacts"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:2:URI" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:2:Label" "Calendar"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:3:URI" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:3:Label" "Notes"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:4:URI" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:4:Label" "Reminders"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:5:URI" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:5:Label" "Messages"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:6:URI" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:6:Label" "FaceTime"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:7:URI" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:7:Label" "App Store"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:0:URI" "file://%HOMEPATH%"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:0:Label" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:1:URI" "file://%HOMEPATH%/Downloads"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:1:Label" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Usr-SidebarContent"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Usr-AtDesktop"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Replace" "true"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:0:URI" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:0:Label" "All My Files"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:1:URI" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:1:Label" "iCloud"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:2:URI" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:2:Label" "AirDrop"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:3:URI" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Remove:3:Label" "domain-AirDrop"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:0:URI" "file://%HOMEPATH%"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:0:Label" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:1:URI" "file://%HOMEPATH%/Desktop"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:1:Label" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:2:URI" "file://%HOMEPATH%/Documents"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:2:Label" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:3:URI" "file://%HOMEPATH%/Downloads"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:3:Label" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:4:URI" "file://%HOMEPATH%/Movies"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:4:Label" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:5:URI" "file://%HOMEPATH%/Music"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:5:Label" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:6:URI" "file://%HOMEPATH%/Pictures"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Add:6:Label" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Gen-Debug"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "App-DidLaunch"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "App-DidTerminate"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:2" "App-WillLaunch"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:3" "Sys-ActiveDirectoryUp"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:4" "Sys-ActiveDirectoryDown"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:5" "Sys-Boot"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:6" "Sys-ConsoleUserLoggedIn"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:7" "Sys-ConsoleUserLoggedOut"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:8" "Sys-ConsoleUserSwitch"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:9" "Sys-HasWoken"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:10" "Sys-Idle"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:11" "Sys-LoginWindow"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:12" "Sys-LoginWindowIdle"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:13" "Sys-LoginWindowPoll"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:14" "Sys-ManualTrigger"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:15" "Sys-NetworkDown"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:16" "Sys-NetworkUp"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:17" "Sys-Poll"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:18" "Sys-WillSleep"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:19" "Sys-WillWake"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:20" "Usr-AtDesktop"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:21" "Usr-ConsoleUserLoggedIn"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:22" "Usr-ConsoleUserSwitch"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:23" "Usr-Idle"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:24" "Usr-Poll"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
exit 0
# ---
sv_PolicyName="Sys-InstallPackageFromFolder"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Idle"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Sys-ManualTrigger"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:0" "/usr/local/Updates"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
exit 0
# ---
sv_PolicyName="Sys-Update"
sv_Tag="Radmind"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-LoginWindow"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Sys-LoginWindowIdle"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:2" "Sys-Idle"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:3" "Sys-ManualTrigger"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:OutOfHoursPowerOn" "true"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:OutOfHoursStartTime" "22:00"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:OutOfHoursEndTime" "05:00"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:UpdateScript:ActiveForDomain:0" "ALL"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:UpdateScript:Exe:0" "file://localhost/usr/local/LabWarden/lib/RadmindUpdate"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:UpdateScript:Exe:1" "192.168.0.3,sha1,0,-I,42000"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoginWindowIdleShutdownSecs" "1200"        # Should we shut workstations down if idle at the LoginWindow    

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
exit 0
# ---
sv_PolicyName="Sys-ShutdownWhenLidShut"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-WillSleep"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ShutdownDelaySecs" "15"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
exit 0
# ---
sv_PolicyName="Sys-CDPInfo"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-NetworkUp"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:CDPsource:0:Device" "en0"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:CDPsource:0:Hardware" "Ethernet"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
exit 0
# ---
sv_PolicyName="Sys-WirelessSetState"
sv_Tag="static"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Boot"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:WirelessState" "on"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminIBSS" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminNetworkChange" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminPowerToggle" "true"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
exit 0
# ---
sv_PolicyName="Sys-MirrorDisplay"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-ConsoleUserLoggedIn"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
#exit 0
# ---
sv_PolicyName="Sys-WiFiRemoveUnknownSSIDs"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Boot"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:KnownSSIDs:0" "YourSSID"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
#exit 0
# ---
# ---
sv_PolicyName="Sys-ADTrustAccountProxyAccess"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Boot"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:0:Protocol" "http"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:0:Address" "PROXYADDRESS"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:0:Port" "PROXYPORT"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:1:Protocol" "htps"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:1:Address" "PROXYADDRESS"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:1:Port" "PROXYPORT"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:0" "/System/Library/CoreServices/AppleIDAuthAgent"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:1" "/System/Library/CoreServices/Software Update.app/Contents/Resources/softwareupdated"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:2" "/System/Library/CoreServices/Spotlight.app/Contents/MacOS/Spotlight"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:3" "/System/Library/CoreServices/mapspushd"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:4" "/System/Library/PrivateFrameworks/ApplePushService.framework/apsd"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:5" "/System/Library/PrivateFrameworks/AuthKit.framework/Versions/A/Support/akd"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:6" "/System/Library/PrivateFrameworks/CommerceKit.framework/Versions/A/Resources/storeaccountd"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:7" "/System/Library/PrivateFrameworks/CommerceKit.framework/Versions/A/Resources/storeassetd"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:8" "/System/Library/PrivateFrameworks/GeoServices.framework/Versions/A/XPCServices/com.apple.geod.xpc"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:9" "/System/Library/PrivateFrameworks/HelpData.framework/Versions/A/Resources/helpd"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:10" "/System/Library/PrivateFrameworks/IDS.framework/identityservicesd.app"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:11" "/System/Library/PrivateFrameworks/PassKitCore.framework/passd"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:12" "/System/Library/PrivateFrameworks/SoftwareUpdate.framework/Versions/A/Resources/suhelperd"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:13" "/usr/libexec/captiveagent"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:14" "/usr/libexec/keyboardservicesd"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:15" "/usr/libexec/locationd"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:16" "/usr/libexec/nsurlsessiond"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:17" "/usr/libexec/rtcreportingd"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Process:18" "/usr/sbin/ocspd"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
#exit 0
# ---

# ALTERNATIVE - PROXY, AUTO

sv_PolicyName="Sys-NetworkProxy"
sv_Tag="AutoProxy"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-NetworkUp"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDomain:0" "ALL"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ProxyAutoDiscoveryEnable" "true"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ProxyAutoConfigEnable" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ProxyAutoConfigURLString" ""

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HTTPEnable" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HTTPProxy" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HTTPPort" "8080"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HTTPSEnable" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HTTPSProxy" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HTTPSPort" "8080"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RTSPEnable" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RTSPProxy" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RTSPPort" "8080"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:FTPEnable" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:FTPProxy" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:FTPPort" "8080"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SOCKSEnable" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SOCKSProxy" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SOCKSPort" "8080"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:GopherEnable" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:GopherProxy" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:GopherPort" "8080"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionsList:0" "*.local"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionsList:1" "169.254/16"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionsList:2" "127.0.0.1"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionsList:3" "localhost"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---

# OFFICE HOURS

sv_PolicyName="Gen-OfficeHours"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Boot"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Sys-NetworkUp"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:2" "Sys-Poll"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:3" "Usr-AtDesktop"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:4" "Usr-Poll"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:Start:Day" "25"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:Start:Month" "11"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:Start:Year" "2016"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:End:Day" "03"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:End:Month" "09"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:End:Year" "2017"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Audit:Active" "true"                          # Whether we should audit usage, true or false
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Audit:HideUntilAgeSecs" "604800"              # Dont show audit at LoginWindow until its at least 1 day old

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ForceLogout:ActiveForDomain:0" "ALL"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ForceLogout:InactiveForGroup:0" "All-Staff"   # list of groups that are exempt from force logout
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ForceLogout:InactiveOnClosedDays" "true"      # Should we allow unrestricted access on days that are defined as closed
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ForceLogout:EarlyLogoutSecs" "600"            # logout user 10 mins before closing
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ForceLogout:EarlyLoginSecs" "3600"            # allow user login 60 mins before opening
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ForceLogout:EarlyWarningSecs" "600"           # Warn user 10 mins before force logout
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ForceLogout:IdleUserSecs" "1800"              # How long before we force logout idle users (0 = never)  

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:CoreOpeningTime" "9:30"    # Mon
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:CoreClosingTime" "16:30"    # Mon

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day1:OpenTime" "8:30"    # Mon
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day1:CloseTime" "21:00"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day2:OpenTime" "8:30"    # Tue
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day2:CloseTime" "21:00"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day3:OpenTime" "8:30"    # Wed
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day3:CloseTime" "21:00"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day4:OpenTime" "8:30"    # Thu
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day4:CloseTime" "21:00"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day5:OpenTime" "8:30"    # Fri
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day5:CloseTime" "17:00"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day6:OpenTime" ""   # Sat
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day6:CloseTime" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day7:OpenTime" ""        # Sun
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day7:CloseTime" ""

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:Start:Day" "22"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:Start:Month" "12"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:Start:Year" "2017"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:End:Day" "7"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:End:Month" "1"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:End:Year" "2018"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:Start:Day" "24"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:Start:Month" "3"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:Start:Year" "2018"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:End:Day" "8"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:End:Month" "4"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:End:Year" "2018"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:Start:Day" "28"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:Start:Month" "10"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:Start:Year" "2017"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:End:Day" "5"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:End:Month" "11"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:End:Year" "2017"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:Start:Day" "10"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:Start:Month" "2"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:Start:Year" "2018"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:End:Day" "18"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:End:Month" "2"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:End:Year" "2018"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day1:OpenTime" "8:30"    # Mon
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day1:CloseTime" "16:00"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day2:OpenTime" "8:30"    # Tue
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day2:CloseTime" "16:00"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day3:OpenTime" "8:30"    # Wed
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day3:CloseTime" "16:00"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day4:OpenTime" "8:30"    # Thu
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day4:CloseTime" "16:00"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day5:OpenTime" "8:30"    # Fri
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day5:CloseTime" "16:00"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day6:OpenTime" ""   # Sat
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day6:CloseTime" ""
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day7:OpenTime" ""        # Sun
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day7:CloseTime" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
#exit 0
# ---

sv_PolicyName="Sys-Defaults"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Boot"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LogIsActive" "${GLB_bv_LogIsActiveDefault}"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:MaxLogSizeBytes" "${GLB_iv_MaxLogSizeBytesDefault}"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LogLevelTrap" "${GLB_iv_LogLevelTrapDefault}"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NotifyLevelTrap" "${GLB_iv_NotifyLevelTrapDefault}"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:GPforceAgeMinutes" "${GLB_iv_GPforceAgeMinutesDefault}"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:GPquickAgeMinutes" "${GLB_iv_GPquickAgeMinutesDefault}"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:GPdefaultAgeMinutes" "${GLB_iv_GPdefaultAgeMinutesDefault}"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:UseLoginhook" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoadConfigsFromADnotes" "true"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---

sv_PolicyName="Sys-Defaults"
sv_Tag="Debug"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Boot"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LogIsActive" "${GLB_bv_LogIsActiveDefault}"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:MaxLogSizeBytes" "${GLB_iv_MaxLogSizeBytesDefault}"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LogLevelTrap" "${GLB_iv_MsgLevelDebug}"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:NotifyLevelTrap" "${GLB_iv_MsgLevelDebug}"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:GPforceAgeMinutes" "${GLB_iv_GPforceAgeMinutesDefault}"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:GPquickAgeMinutes" "${GLB_iv_GPquickAgeMinutesDefault}"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:GPdefaultAgeMinutes" "${GLB_iv_GPdefaultAgeMinutesDefault}"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:UseLoginhook" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LoadConfigsFromADnotes" "true"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
#exit 0
# ---
sv_PolicyName="Sys-ADCompCert8021XWiFi"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-NetworkUp"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RenewCertBeforeDays" "28"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RevokeCertBeforeEpoch" "0"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:CertTemplate" "Mac-Computer"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:CertAuthURL" "https://yourcaserver.yourdomain/certsrv"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SSIDSTR" "YourSSID"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:TLSTrustedServerNames:0" "yourtrustedserver.yourdomain"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ProxyType" "Auto"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
#exit 0
# ---

sv_PolicyName="Usr-KeychainFix"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Usr-AtDesktop"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

#---
#exit 0
# ---

# Policy that deploys the mounthome.sh script from https://github.com/amsysuk/public_scripts
# Script should be renamed to "mounthome" and placed in "/usr/local/LabWarden/Custom-Policies"
# The mounthome script has no configurable options so can be used as-is
sv_PolicyName="mounthome"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Usr-ConsoleUserLoggedIn"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---

sv_PolicyName="Sys-WorkstationInfo"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Boot"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Sys-ActiveDirectoryUp"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ShowHostnameAtLoginwindow" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ShowADpathAtLoginwindow" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ShowADpathInRemoteDesktopInfo" "true"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Usr-HomeMakePathRedirections"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Usr-ConsoleUserLoggedIn"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Usr-AtDesktop"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:MakePathRedirections" "true"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:0" "/Desktop/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:1" "/Documents/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:2" "/Downloads/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:3" "/Movies/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:4" "/Music/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:5" "/Pictures/"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:0" "/Library/Application Support/audacity/.audacity.sock"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:1" "/Library/Application Support/CrashReporter/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:2" "/Library/Caches/com.apple.helpd/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:3" "/Library/Calendars/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:4" "/Library/com.apple.nsurlsessiond/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:5" "/Library/Containers/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:6" "/Library/IdentityServices/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:7" "/Library/Keychains/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:8" "/Library/Logs/DiagnosticReports/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:9" "/Library/Messages/"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Usr-CreateFolder"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Usr-ConsoleUserLoggedIn"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Usr-AtDesktop"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:0" "/Desktop/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:1" "/Documents/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:2" "/Downloads/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:3" "/Library/Preferences/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:4" "/Movies/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:5" "/Music/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:6" "/Pictures/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:7" "/NETWORKHOME/"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Gen-UnloadAgentsAndDaemons"
sv_Tag="proxypopups"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Boot"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Usr-ConsoleUserLoggedIn"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Unload:0" "com.apple.UserNotificationCenter"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Sys-SleepSettings"
sv_Tag="10mins"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-LoginWindow"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Sys-ConsoleUserLoggedIn"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Battery:DiskSleep" 3
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Battery:DisplaySleep" 2
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Battery:SystemSleep" 10
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Power:DiskSleep" 15
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Power:DisplaySleep" 10
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Power:SystemSleep" 0

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Battery:DiskSleep" 3
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Battery:DisplaySleep" 2
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Battery:SystemSleep" 0
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Power:DiskSleep" 15
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Power:DisplaySleep" 10
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Power:SystemSleep" 0

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Sys-SleepSettings"
sv_Tag="never"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-LoginWindow"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Sys-ConsoleUserLoggedIn"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Battery:DiskSleep" 3
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Battery:DisplaySleep" 0
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Battery:SystemSleep" 10
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Power:DiskSleep" 15
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Power:DisplaySleep" 10
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Power:SystemSleep" 0

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Battery:DiskSleep" 3
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Battery:DisplaySleep" 0
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Battery:SystemSleep" 0
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Power:DiskSleep" 15
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Power:DisplaySleep" 0
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Power:SystemSleep" 0

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="App-ExamplePolicy"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "App-WillLaunch"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "App-DidLaunch"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:2" "App-DidTerminate"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleBool" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleNum" "42"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleString" "Example"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:0" "First"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:1" "Second"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:2" "Third"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Usr-ExamplePolicy"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Usr-ConsoleUserLoggedIn"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Usr-ConsoleUserSwitch"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:2" "Usr-AtDesktop"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:3" "Usr-Poll"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:4" "Usr-Idle"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleBool" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleNum" "42"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleString" "Example"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:0" "First"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:1" "Second"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:2" "Third"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Sys-ExamplePolicy"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Boot"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "Sys-ConsoleUserLoggedIn"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:2" "Sys-ConsoleUserLoggedOut"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:3" "Sys-ConsoleUserSwitch"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:4" "Sys-Poll"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:5" "Sys-Idle"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:6" "Sys-LoginWindow"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:7" "Sys-LoginWindowPoll"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:8" "Sys-LoginWindowIdle"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:9" "Sys-NetworkUp"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:10" "Sys-NetworkDown"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:11" "Sys-ActiveDirectoryUp"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleBool" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleNum" "42"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleString" "Example"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:0" "First"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:1" "Second"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:2" "Third"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Gen-ExamplePolicy"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "App-WillLaunch"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "App-DidLaunch"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:2" "App-DidTerminate"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:3" "Usr-ConsoleUserLoggedIn"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:4" "Usr-ConsoleUserSwitch"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:5" "Usr-AtDesktop"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:6" "Usr-Poll"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:7" "Usr-Idle"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:8" "Sys-Boot"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:9" "Sys-ConsoleUserLoggedIn"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:10" "Sys-ConsoleUserLoggedOut"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:11" "Sys-ConsoleUserSwitch"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:12" "Sys-Poll"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:13" "Sys-Idle"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:14" "Sys-LoginWindow"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:15" "Sys-LoginWindowPoll"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:16" "Sys-LoginWindowIdle"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:17" "Sys-NetworkUp"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:18" "Sys-NetworkDown"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:19" "Sys-ActiveDirectoryUp"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleBool" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleNum" "42"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleString" "Example"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:0" "First"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:1" "Second"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:2" "Third"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
#exit 0
# ---

sv_PolicyName="Sys-ADUserExperience"
sv_Tag="HomeForceLocal"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-ActiveDirectoryUp"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDomain:0" "ADDOMAIN"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:mobile" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:mobileconfirm" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:localhome" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:sharepoint" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:useuncpath" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:protocol" "smb"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:alldomains" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:preferredserver" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Sys-ADUserExperience"
sv_Tag="Mobile"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-ActiveDirectoryUp"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDomain:0" "ADDOMAIN"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:mobile" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:mobileconfirm" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:localhome" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:sharepoint" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:useuncpath" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:protocol" "smb"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:alldomains" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:preferredserver" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Sys-ADUserExperience"
sv_Tag="HomeOnNetwork"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-ActiveDirectoryUp"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDomain:0" "ADDOMAIN"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:mobile" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:mobileconfirm" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:localhome" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:sharepoint" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:useuncpath" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:protocol" "smb"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:alldomains" "true"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:preferredserver" ""

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
#exit 0
# ---
sv_PolicyName="Sys-RemoteManagement"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Poll"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Groups:0:Name" "dirgroup1"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Groups:0:Access" "admin"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Groups:1:Name" "dirgroup2"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Groups:1:Access" "interact"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:0:Name" "diruser1"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:0:Access" "admin"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:1:Name" "diruser2"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:1:Access" "interact"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:2:Name" "diruser3"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:2:Access" "manage"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:3:Name" "diruser4"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Users:3:Access" "reports"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:0:Name" "localuser1"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:0:Privs:0" "all"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Name" "localuser2"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:0" "DeleteFiles"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:1" "ControlObserve"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:2" "TextMessages"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:3" "ShowObserve"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:4" "OpenQuitApps"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:5" "GenerateReports"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:6" "RestartShutDown"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:7" "SendFiles"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:8" "ChangeSettings"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:9" "ObserveOnly"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
#exit 0
# ---
#exit 0
# ---
#exit 0
# ---
sv_PolicyName="Sys-PolicyBanner"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Boot"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Title" "$(printf "By clicking 'Accept',\nyou are agreeing to abide by the\nAcceptable Use Policy.")"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Text" "$(printf "Anyone whose behaviour\nis not in accordance with this Code of Practice\nmay be subject to withdrawal of network access\nand subject to the disciplinary procedure.\n\nThis is in keeping with the\nDisciplinary regulations.")"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"
#exit 0
# ---
sv_PolicyName="Usr-SpotlightSettingOnNetHome"
sv_Tag="on"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SpotlightEnabled" "true"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Usr-AtDesktop"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Usr-SpotlightSettingOnNetHome"
sv_Tag="off"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SpotlightEnabled" "false"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Usr-AtDesktop"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---

# ---
sv_PolicyName="Sys-DeleteFiles"
sv_Tag="FlashPlayer"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Boot"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:0" "/Applications/Utilities/Adobe Flash Player Install Manager.app/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:1" "/Library/Application Support/Adobe/Flash Player Install Manager/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:2" "/Library/Internet Plug-Ins/Flash Player.plugin/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:3" "/Library/Internet Plug-Ins/PepperFlashPlayer/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:4" "/Library/LaunchDaemons/com.adobe.fpsaud.plist"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Path:5" "/Library/PreferencePanes/Flash Player.prefPane/"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Sys-TimeServer"
sv_Tag="Apple"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-NetworkUp"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDomain:0" ""

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:TimeServer" "time.euro.apple.com"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:TimeZone" "Europe/London"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Sys-WirelessSetState"
sv_Tag="off"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Boot"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:WirelessState" "off"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminIBSS" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminNetworkChange" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminPowerToggle" "true"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Sys-WirelessSetState"
sv_Tag="on"

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Boot"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:WirelessState" "on"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminIBSS" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminNetworkChange" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminPowerToggle" "true"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---

sv_PolicyName="Sys-AddPrinter"
sv_PrinterName="Marketing-Laser2020"
sv_Tag=$(echo "${sv_PrinterName}" | tr -d "-")

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Poll"


GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:DisplayName" "${sv_PrinterName}"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:PPDURI" "file://localhost/Library/Printers/PPDs/Contents/Resources/HP Color LaserJet CP2020 Series.gz"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:DeviceURI" "smb://PRINTSRV.example.com/Marketing-Laser2020"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Options" "-o printer-is-shared=false -o printer-error-policy=abort-job -o PageSize=A4 -o HPBookletPageSize=A4"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Location" "Marketing"


/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Sys-AddPrinter"
sv_PrinterName="Marketing-Laser2020-direct"
sv_Tag=$(echo "${sv_PrinterName}" | tr -d "-")

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Poll"


GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:DisplayName" "${sv_PrinterName}"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:PPDURI" "file://localhost/Library/Printers/PPDs/Contents/Resources/HP Color LaserJet CP2020 Series.gz"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:DeviceURI" "lpd://192.168.0.5/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Options" "-o printer-is-shared=false -o printer-error-policy=abort-job -o PageSize=A4 -o HPBookletPageSize=A4"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Location" "Marketing"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
#exit 0
# ---
# ---

sv_PolicyName="Sys-RestartIfNetMount"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-LoginWindow"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"


# ---

# ---
sv_PolicyName="App-DeleteDataOnQuit"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "App-DidTerminate"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:0:ApplicationBundleIdentifier" "com.adobe.AdobePremierePro"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:0:Path:0" "/Library/Application Support/Adobe/Common/Media Cache Files/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:0:Path:1" "/Library/Application Support/Adobe/Common/Media Cache/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:1:ApplicationBundleIdentifier" "org.chromium.Chromium"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:1:Path:0" "/Library/Application Support/Chromium/Default/Pepper Data/"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:2:ApplicationBundleIdentifier" "com.google.Chrome"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppData:2:Path:0" "/Library/Application Support/Google/Chrome/Default/Pepper Data/"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="App-FirefoxFirstSetup"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "App-WillLaunch"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="App-FirefoxFixForNetworkHomes"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "App-WillLaunch"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:1" "App-DidTerminate"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---

sv_PolicyName="App-Restrict"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "App-WillLaunch"

  # Any Application in the ExceptionList is exempt from Whitelist/BlackList checking
  # This allows you to have Apps that will run from any location without having to implement a whitelist
  # The format is ApplicationName1/ApplicationBundleIdentifier1,ApplicationName2/ApplicationBundleIdentifier2,etc
  # If an application has no ApplicationBundleIdentifier then specify ApplicationName/(null) i.e TextWrangler/(null)
  # Regular expressions can be used.

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:0:ApplicationName" "PrinterProxy"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:0:ApplicationBundleIdentifier" 'com\.apple\.print\.PrinterProxy'
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:1:ApplicationName" ".*"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:1:ApplicationBundleIdentifier" "com\.google\.Chrome\.app\..*"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:2:ApplicationName" "Citrix Online Launcher"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:2:ApplicationBundleIdentifier" "com\.citrixonline\.mac\.WebDeploymentApp"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:3:ApplicationName" "GoToMeeting.*"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:3:ApplicationBundleIdentifier" "com\.citrixonline\.GoToMeeting"

  
  # If the WhiteList is not null, then these Applications (and only these) are allowed.
  # When the WhiteList is not null, then it should at least contain "Finder/com.apple.Finder" or maybe even ".*/com.apple\..*"
  # Regular expressions can be used.
  
  # Any Application in the comma-separated BlackList is always disallowed for non-admins
  # Regular expressions can be used.

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:BlackList:0:ApplicationName" "Terminal"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:BlackList:0:ApplicationBundleIdentifier" "com\.apple\.Terminal"
  
  # If the comma-separated path WhiteList is not null, then Applications at the specified paths (and only these paths) are allowed.
  # When the path WhiteList is not null, it should at least contain "/Applications/.*,/System/Library/CoreServices/.*"
  # ~/ is expanded to the current user home before comparison.
  # Regular expressions should be used.
  

  # Any application located at a path in this comma-separated path BlackList is always disallowed for non-admins
  # ~/ is expanded to the current user home before comparison.
  # Regular expressions should be used.
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:PathBlackList:0" "~/.*"
  
  # Should we disallow applications running on mounts
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:OnlyAllowLocalApps" "true"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="App-ShowHints"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "App-DidLaunch"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:ApplicationBundleIdentifier" "com.apple.logic10"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:IsAdmin" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:IsLocalAccount" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:IsLocalHome" "false"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:MessageContent" "APPNAME works better off network"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:1:ApplicationBundleIdentifier" "com.adobe.AdobePremierePro"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:1:MessageContent" "Setup your Media Cache File location (Premiere>Preferences>Media)"

#GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:2:ApplicationBundleIdentifier" "com.apple.FinalCutPro"
#GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:2:MessageContent" "Final Cut Pro>System Settings...>Scratch Disks"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---

# ---

sv_PolicyName="Sys-AddEntriesToHostsFile"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Boot"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:IP4" "127.0.0.1"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:Host:0" "prod-w.nexus.live.com.akadns.net"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:Host:1" "odc.officeapps.live.com"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:Host:2" "omextemplates.content.office.net"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:Host:3" "officeclient.microsoft.com"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:Host:4" "store.office.com"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:Host:5" "nexusrules.officeapps.live.com"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:Host:6" "nexus.officeapps.live.com"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Sys-WirelessForgetSSID"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Sys-Boot"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SSID:0" "College"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:SSID:1" "virginmedia1234567"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Usr-CheckQuotaOnNetHome"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Usr-Poll"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
sv_PolicyName="Usr-DefaultHandlers"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Usr-AtDesktop"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:0:BundleID" "com.apple.Safari"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:0:UTI" "public.html"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:0:Role" "all"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:1:BundleID" "com.apple.Safari"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:1:UTI" "public.xhtml"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:1:Role" "all"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:2:BundleID" "com.apple.Safari"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:2:UTI" "http"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:3:BundleID" "com.apple.Safari"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:3:UTI" "https"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:4:BundleID" "cx.c3.theunarchiver"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:4:UTI" "zip"
GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:Handler:4:Role" "all"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
# ALTERNATIVE - DESKTOP WALLPAPER
sv_PolicyName="Usr-DesktopWallpaperURI"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${sv_PolicyName}" "${sv_Tag}" "${sv_ConfigType}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"
# GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Type" "Policy"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:TriggeredBy:0" "Usr-AtDesktop"

GLB_nf_SetPlistProperty "${sv_ConfigFilePath}" "${sv_PropertyBase}:Config:DesktopWallpaperURI" "smb://YOURSERVER/YOURSHARE/YOURFOLDER/desktop.bmp"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---

# Remove temporary files
rm -fPR "${GLB_sv_ThisScriptTempDirPath}"

