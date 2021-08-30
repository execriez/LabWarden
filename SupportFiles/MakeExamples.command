#!/bin/bash
#
# Short:    Initialise the LabWarden configs
# Author:   Mark J Swift
# Version:  3.2.5
# Modified: 30-Dec-2020
#
# Note to self - exclude personalised settings before publishing
# ---
# Handy URL smb://act-fas-02.lits.blackpool.ac.uk/software$/MacOS
# Assume that all code is run from a subdirectory of the main project directory
GLB_SV_PROJECTDIRPATH="$(dirname $(dirname ${0}))"

# ---

GLB_SV_UTILITYCODEVERSION="3.2.5"

# ---

# Change working directory to the location of this script
cd "$(dirname "${0}")"

# ---

# Include the Core Defs library (if it is not already loaded)
if [ -z "${GLB_BC_CORE_ISINCLUDED}" ]
then
  . "${GLB_SV_PROJECTDIRPATH}"/inc-sh/CoreDefs.sh

  # Exit if something went wrong unexpectedly
  if [ -z "${GLB_BC_CORE_ISINCLUDED}" ]
  then
    echo >&2 "Something unexpected happened"
    exit 90
  fi
fi

# By the time we get here, quite a few global variables have been set up.
# Look at 'inc/Common.sh' for a complete list.

# ---

sv_YourFolderName="Examples"

sv_ConfigLabDirPath=~/Desktop/${GLB_SC_PROJECTNAME}-Profiles/${sv_YourFolderName}/V${GLB_SC_PROJECTMAJORVERSION}
mkdir -p "${sv_ConfigLabDirPath}"

# ---

# Create a config and return ConfigFilePath and PropertyBase
sf_MakeConfigFile()   # PolicyName Tag - returns string "<ConfigFilePath>,<PropertyBase>"
{
  local GLB_SV_POLICYNAME
  local sv_Tag
  local sv_ConfigFileName
  local sv_PayloadUUID
  local sv_ThisConfigFilePath
  local sv_PropertyBase
  local sv_PayloadIdentifier

  GLB_SV_POLICYNAME="${1}"
  sv_Tag="${2}"
  
  if test -z "${sv_Tag}"
  then
    sv_ConfigFileName="${GLB_SV_POLICYNAME}"
  else
    sv_ConfigFileName=$(echo "${GLB_SV_POLICYNAME}-(${sv_Tag})" | tr -d " ")
  fi

  sv_PayloadUUID=$(uuidgen)

  sv_ThisConfigFilePath="${sv_ConfigDirPath}/LW-${sv_ConfigFileName}.mobileconfig"
  rm -f "${sv_ThisConfigFilePath}"
  sv_PayloadIdentifier=$(uuidgen)
  GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadContent:0:PayloadUUID" "${sv_PayloadUUID}"
  GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadContent:0:PayloadIdentifier" "${sv_PayloadUUID}"
  GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadContent:0:PayloadType" "${GLB_SC_PROJECTSIGNATURE}"
  GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadContent:0:PayloadVersion" "1"
  GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadContent:0:${sv_PayloadUUID}" "DICT"
  GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadContent:0:PayloadEnabled" ${GLB_BC_TRUE}
  GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadUUID" "${sv_PayloadIdentifier}"
  GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadIdentifier" "${sv_PayloadIdentifier}"
  GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadType" "Configuration"
  GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadVersion" "1"
  GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadDescription" ""
  if test -z "${sv_Tag}"
  then
    GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadDisplayName" "${GLB_SC_PROJECTINITIALS} ${GLB_SV_POLICYNAME}"
  else
    GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadDisplayName" "${GLB_SC_PROJECTINITIALS} ${GLB_SV_POLICYNAME} (${sv_Tag})"
  fi
  GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadOrganization" ""
  GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadRemovalDisallowed" ${GLB_BC_TRUE}
  GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" ":PayloadScope" "System"

  sv_PropertyBase=":PayloadContent:0:${sv_PayloadUUID}"
  echo "${sv_ThisConfigFilePath},${sv_PropertyBase}"
  
}

# ---

sv_ConfigDirPath="${sv_ConfigLabDirPath}"

# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="LabWarden-netlogon"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Interval" "3600"  # How long to wait between triggered events (1 hour)
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "0"   # How long to wait before updating workstations when idle at the LoginWindow    

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "smb://%SV_ADFLATDOMAINNAME%/NETLOGON/MacOS/Packages/LabWarden.pkg"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "LabWarden.pkg"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Package"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Package:VersionString" "${GLB_SC_PROJECTVERSION}"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Package:ID" "${GLB_SC_PROJECTSIGNATURE}"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-PowerOnError"
sv_Tag="Daily-0850"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Error"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Alert"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name" "Sys-Critical"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "8"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Minute" "50"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
exit 0
# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="Radmind"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

# 10.[1-9][0-9]($|.[0-9]) match 10.10 - 10.99.99

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_OS%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "10.1[0-5]($|.[0-9])"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Value" "%IV_HOUR%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Pattern" "[0-5]|2[2-3]"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Interval" "25200"  # How long to wait between triggered events (7 hours)
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "0"   # How long to wait before updating workstations when idle at the LoginWindow    

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file://localhost/usr/local/LabWarden/bin"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "RadmindUpdate"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Executable:Args" "172.18.1.24,sha1,0,-I,9999999 http://172.18.1.24/LabWarden/RadmindNotify.php"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Always"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="10v13"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

# 10.[1-9][0-9]($|.[0-9]) match 10.10 - 10.99.99

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_MODEL%:%SV_OS%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac1[0-8]|Mac(Book(([6-9]|10)|Air[3-7]|Pro([6-9]|1[0-4]))|mini[4-7]|Pro[5-6])),.*:10.1([0-2]($|.[0-9])|3($|.[0-5]))"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Value" "%IV_HOUR%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Pattern" "[0-5]|2[2-3]"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Interval" "25200"  # How long to wait between triggered events (7 hours)

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "0"   # How long to wait before updating workstations when idle at the LoginWindow    

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "smb://GUEST:@172.18.1.24/installs/10v13.dmg"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Always"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---

GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="10v15"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

# 10.[1-9][0-9]($|.[0-9]) match 10.10 - 10.99.99

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_MODEL%:%SV_OS%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac(1[3-9]|Pro1)|Mac(Book(([8-9]|10)|Air[5-8]|Pro(9|1[0-5]))|mini[6-8]|Pro6)),.*:10.1([0-4]($|.[0-9])|5($|.[0-3]))"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Value" "%IV_HOUR%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Pattern" "[0-5]|2[2-3]"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Interval" "25200"  # How long to wait between triggered events (7 hours)

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "0"   # How long to wait before updating workstations when idle at the LoginWindow    

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "smb://GUEST:@172.18.1.24/installs/10v15.dmg"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Always"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi
# ---
exit 0
# ---
# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="Radmind"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

# 10.[1-9][0-9]($|.[0-9]) match 10.10 - 10.99.99

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_OS%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "10.1[0-5]($|.[0-9])"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Value" "%IV_HOUR%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Pattern" "[0-5]|2[2-3]"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Interval" "25200"  # How long to wait between triggered events (7 hours)
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file://localhost/usr/local/LabWarden/bin"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "RadmindUpdate"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Executable:Args" "172.18.1.24,sha1,0,-I,9999999 http://172.18.1.24/LabWarden/RadmindNotify.php"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Always"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
exit 0
# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="MacOS10v13v6"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

# 10.[1-9][0-9]($|.[0-9]) match 10.10 - 10.99.99

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_MODEL%:%SV_OS%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac1[0-8]|Mac(Book(([6-9]|10)|Air[3-7]|Pro([6-9]|1[0-4]))|mini[4-7]|Pro[5-6])),.*:10.1([0-2]($|.[0-9])|3($|.[0-5]))"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Value" "%IV_HOUR%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Pattern" "[0-5]|2[2-3]"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Interval" "25200"  # How long to wait between triggered events (7 hours)

#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "smb://GUEST:@172.18.1.24/installs/MacOS-HighSierra-10v13v6.dmg"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Always"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---

GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="MacOS10v15v4"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

# 10.[1-9][0-9]($|.[0-9]) match 10.10 - 10.99.99

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_MODEL%:%SV_OS%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac(1[3-9]|Pro1)|Mac(Book(([8-9]|10)|Air[5-8]|Pro(9|1[0-5]))|mini[6-8]|Pro6)),.*:10.1([0-4]($|.[0-9])|5($|.[0-3]))"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Value" "%IV_HOUR%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Pattern" "[0-5]|2[2-3]"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Interval" "25200"  # How long to wait between triggered events (7 hours)

#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "smb://GUEST:@172.18.1.24/installs/MacOS-Catalina-10v15v4.dmg"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Always"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
exit 0
# ---

GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="web-MuseScore3"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "https://ftp.osuosl.org/pub/musescore-nightlies/macos/3x/stable/MuseScore-3.5.2.312126096.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Auto"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "MuseScore 3.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleLongVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleLongVersionString" "3.5.2"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
#exit 0
# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="LabWarden"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "https://raw.githubusercontent.com/execriez/LabWarden/master/SupportFiles/LabWarden.pkg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.7"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "LabWarden.pkg"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Package"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Package:VersionString" "${GLB_SC_PROJECTVERSION}"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Package:ID" "${GLB_SC_PROJECTSIGNATURE}"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeGamingSDK"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Value" "%IV_HOUR%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Pattern" "[0-5]|2[2-3]"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Interval" "25200"  # How long to wait between triggered events (7 hours)

#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-GamingSDK-1v4-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "VersionInfo.txt"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "File"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Gaming SDK 1.4"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:File:md5checksum" "34ef3b5ada1541c9f997835ead3127a5"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="GoogleChrome"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-Google-GoogleChrome-76v0v3809v132.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Google Chrome.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "76.0.3809.132"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi
# ---
# exit 0
# ---

GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobePhotoshopCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Value" "%IV_HOUR%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Pattern" "[0-5]|2[2-3]"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Interval" "25200"  # How long to wait between triggered events (7 hours)

#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-PhotoShopCC2018-19v1v19-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Photoshop CC 2018.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Photoshop CC 2018"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "19.1.9"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi
# ---
# exit 0
# ---

GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="MacOS10v15v4"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

# 10.[1-9][0-9]($|.[0-9]) match 10.10 - 10.99.99

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_MODEL%:%SV_OS%"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac1[3-9]|iMacPro1|MacBook([8-9]|10)|MacBookAir[5-8]|MacBookPro(9|1[0-5])|Macmini[6-8]|MacPro6),.*"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac(1[3-9]|Pro1)|Mac(Book(([8-9]|10)|Air[5-8]|Pro(9|1[0-5]))|mini[6-8]|Pro6)),.*:10.1([0-4]($|.[0-9])|5($|.[0-3]))"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Value" "%IV_HOUR%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Pattern" "[0-5]|2[2-3]"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Interval" "25200"  # How long to wait between triggered events (7 hours)

#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-app-Apple-Catalina-10v15v4-10v9.dmg"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Always"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi
# ---
 exit 0
# ---

GLB_SV_POLICYNAME="Sys-BootVolumeFilePurge"
sv_Tag="FlashPlayer"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:0" "/Applications/Utilities/Adobe Flash Player Install Manager.app/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:1" "/Library/Application Support/Adobe/Flash Player Install Manager/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:2" "/Library/Internet Plug-Ins/Flash Player.plugin/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:3" "/Library/Internet Plug-Ins/PepperFlashPlayer/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:4" "/Library/LaunchDaemons/com.adobe.fpsaud.plist"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:5" "/Library/PreferencePanes/Flash Player.prefPane/"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-CDPInfo"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-NetworkUp"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:CDPsource:0:Device" "en0"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:CDPsource:0:Hardware" "Ethernet"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-Defaults"
sv_Tag="Debug"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LogIsActive" "${GLB_BC_TRUE}"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MaxLogSizeBytes" "${GLB_IV_DFLTLOGSIZEMAXBYTES}"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LogLevelTrap" "${GLB_IC_MSGLEVELDEBUG}"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NotifyLevelTrap" "${GLB_IC_MSGLEVELDEBUG}"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-Defaults"
sv_Tag="Info"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LogIsActive" "${GLB_BC_TRUE}"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MaxLogSizeBytes" "${GLB_IV_DFLTLOGSIZEMAXBYTES}"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LogLevelTrap" "${GLB_IC_MSGLEVELINFO}"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NotifyLevelTrap" "${GLB_IC_MSGLEVELINFO}"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-dot1xWiFi"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-NetworkUp"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RenewCertBeforeDays" "28"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RevokeCertBeforeEpoch" "0"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:CertTemplate" "Mac-Computer"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:CertServer" "yourcaserver.yourdomain"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:TLSTrustedServerNames:0" "yourtrustedserver.yourdomain"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:SSID_STR" "YourSSID"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ProxyType" "Auto"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-HostsFile"
sv_Tag="CaptivePortal"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:IP4" "127.0.0.1"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Entry:0:Host:0" "captive.apple.com"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
# PROXY, NONE

GLB_SV_POLICYNAME="Sys-InternetProxy"
sv_Tag="None"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-NetworkUp"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# PROXY, NONE (Full example)

GLB_SV_POLICYNAME="Sys-InternetProxy"
sv_Tag="None-FullExample"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-NetworkUp"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ProxyAutoDiscoveryEnable" ${GLB_BC_FALSE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ProxyAutoConfigEnable" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ProxyAutoConfigURLString" ""

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HTTPEnable" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HTTPProxy" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HTTPPort" "8080"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HTTPSEnable" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HTTPSProxy" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HTTPSPort" "8080"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RTSPEnable" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RTSPProxy" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RTSPPort" "8080"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:FTPEnable" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:FTPProxy" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:FTPPort" "8080"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:SOCKSEnable" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:SOCKSProxy" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:SOCKSPort" "8080"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:GopherEnable" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:GopherProxy" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:GopherPort" "8080"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionsList:0" "*.local"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionsList:1" "169.254/16"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionsList:2" "127.0.0.1"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionsList:3" "localhost"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# PROXY, OffSite NONE

GLB_SV_POLICYNAME="Sys-InternetProxy"
sv_Tag="OffSite-None"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_DHCPOPTION15%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "yourdomain1|yourdomain2"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_FALSE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-NetworkUp"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# PROXY, OnSite AUTO

GLB_SV_POLICYNAME="Sys-InternetProxy"
sv_Tag="OnSite-AutoProxy"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_DHCPOPTION15%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "yourdomain1|yourdomain2"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-NetworkUp"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ProxyAutoDiscoveryEnable" ${GLB_BC_TRUE}

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-LocalProfileRetention"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Poll"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:DeleteMobileAccounts" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinDiskSpaceMegs" 2048
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LoginMinAgeDays" 8
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LoginMaxAgeDays" 62
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:UserCacheEarliestEpoch" 1462365175

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-LoginwindowInfo"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-ActiveDirectoryUp"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ShowHostname" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ShowADpath" ${GLB_BC_TRUE}

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-NetworkTime"
sv_Tag="Apple"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-NetworkUp"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:UseNetworkTime" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:TimeServer" "time.euro.apple.com"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:TimeZone" "Europe/London"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-NetworkTime"
sv_Tag="OffSite"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_DHCPOPTION15%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "yourdomain1|yourdomain2"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_FALSE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-NetworkUp"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:UseNetworkTime" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:TimeServer" "time.euro.apple.com"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:TimeZone" "Europe/London"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-NetworkTime"
sv_Tag="OnSite"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_DHCPOPTION15%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "yourdomain1|yourdomain2"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-NetworkUp"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:UseNetworkTime" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:TimeServer" "yourtimeserver.yourdomain"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:TimeZone" "Europe/London"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-PolicyBanner"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Title" "$(printf "By clicking 'Accept',\nyou are agreeing to abide by the\nAcceptable Use Policy.")"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Text" "$(printf "Anyone whose behaviour\nis not in accordance with this Code of Practice\nmay be subject to withdrawal of network access\nand subject to the disciplinary procedure.\n\nThis is in keeping with the\nDisciplinary regulations.")"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-PrinterManifest"
sv_PrinterName="Marketing-EpsonSPro4880-queue"
sv_Tag=$(echo "${sv_PrinterName}" | tr -d "-")

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Poll"

#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DisplayName" "${sv_PrinterName}"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:PPDURI" "http://Marketing-Mac:631/printers/SCA11_SPro4880_direct.ppd"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DeviceURI" "mdns://Marketing-EpsonSPro4880-direct%20%40%20Marketing-Mac._ipp._tcp.local."
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Options" "-o printer-is-shared=false -o printer-error-policy=abort-job -o EPIJ_Bi_D=1"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Location" "Wired to the Marketing-Mac"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-PrinterManifest"
sv_PrinterName="Marketing-EpsonSPro4880-direct"
sv_Tag=$(echo "${sv_PrinterName}" | tr -d "-")

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Poll"

#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DisplayName" "${sv_PrinterName}"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:PPDURI" "file://localhost/Library/Printers/PPDs/Contents/Resources/EPSON Stylus Pro 4880.gz"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DeviceURI" "usb://EPSON/Stylus%20Pro%204880?serial=0KW57082043056815-"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Options" "-o printer-is-shared=true -o printer-error-policy=abort-job -o EPIJ_Bi_D=1"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Location" "Local USB printer"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-PrinterManifest"
sv_PrinterName="Marketing-Laser2020-queue"
sv_Tag=$(echo "${sv_PrinterName}" | tr -d "-")

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Poll"

#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DisplayName" "${sv_PrinterName}"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:PPDURI" "file://localhost/Library/Printers/PPDs/Contents/Resources/HP Color LaserJet CP2020 Series.gz"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DeviceURI" "smb://PRINTSRV.example.com/Marketing-Laser2020"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Options" "-o printer-is-shared=false -o printer-error-policy=abort-job -o PageSize=A4 -o HPBookletPageSize=A4"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Location" "Marketing print queue"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-PrinterManifest"
sv_PrinterName="Marketing-Laser2020-direct"
sv_Tag=$(echo "${sv_PrinterName}" | tr -d "-")

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Poll"

#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DisplayName" "${sv_PrinterName}"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:PPDURI" "file://localhost/Library/Printers/PPDs/Contents/Resources/HP Color LaserJet CP2020 Series.gz"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DeviceURI" "lpd://192.168.0.5/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Options" "-o printer-is-shared=false -o printer-error-policy=abort-job -o PageSize=A4 -o HPBookletPageSize=A4"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Location" "Marketing network printer"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-RemoteManagement"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Poll"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Groups:0:Name" "dirgroup1"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Groups:0:Access" "admin"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Groups:1:Name" "dirgroup2"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Groups:1:Access" "interact"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Users:0:Name" "diruser1"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Users:0:Access" "admin"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Users:1:Name" "diruser2"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Users:1:Access" "interact"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Users:2:Name" "diruser3"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Users:2:Access" "manage"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Users:3:Name" "diruser4"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Users:3:Access" "reports"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:0:Name" "localuser1"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:0:Privs:0" "all"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Name" "localuser2"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:0" "DeleteFiles"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:1" "ControlObserve"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:2" "TextMessages"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:3" "ShowObserve"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:4" "OpenQuitApps"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:5" "GenerateReports"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:6" "RestartShutDown"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:7" "SendFiles"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:8" "ChangeSettings"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LocalUsers:1:Privs:9" "ObserveOnly"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-RestartAfterLongSleep"
sv_Tag="3hr"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-WillSleep"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-WillWake"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LongSleepMins" "180"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-SchedulePowerOn"
sv_Tag="Daily-8-9"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Poll"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-LoginWindowIdle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "8"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "9"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ShutdownOnIdleSecs" "1200"        # Should we shut workstations down if idle at the LoginWindow    

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-SchedulePowerOn"
sv_Tag="Daily-22-05"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Poll"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-LoginWindowIdle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ShutdownOnIdleSecs" "1200"        # Should we shut workstations down if idle at the LoginWindow    

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-SchedulePowerOn"
sv_Tag="Christmas2020"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Poll"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-LoginWindowIdle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Day" "25"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Month" "12"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Year" "2020"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Minute" "0"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Day" "26"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Month" "12"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Year" "2020"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Minute" "0"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ShutdownOnIdleSecs" "1200"        # Should we shut workstations down if idle at the LoginWindow    

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-ShutdownWhenLidShut"
sv_Tag="15secs"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-WillSleep"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ShutdownDelaySecs" "15"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-SleepSettings"
sv_Tag="10mins"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-LoginWindow"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-ConsoleUserLoggedIn"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Battery:DiskSleep" 3
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Battery:DisplaySleep" 2
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Battery:SystemSleep" 10
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Power:DiskSleep" 15
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Power:DisplaySleep" 10
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Power:SystemSleep" 0

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Battery:DiskSleep" 3
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Battery:DisplaySleep" 2
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Battery:SystemSleep" 0
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Power:DiskSleep" 15
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Power:DisplaySleep" 10
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Power:SystemSleep" 0

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-SleepSettings"
sv_Tag="never"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-LoginWindow"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-ConsoleUserLoggedIn"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Battery:DiskSleep" 3
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Battery:DisplaySleep" 0
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Battery:SystemSleep" 10
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Power:DiskSleep" 15
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Power:DisplaySleep" 10
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-ConsoleUserLoggedIn:Power:SystemSleep" 0

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Battery:DiskSleep" 3
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Battery:DisplaySleep" 0
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Battery:SystemSleep" 0
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Power:DiskSleep" 15
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Power:DisplaySleep" 0
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Sys-LoginWindow:Power:SystemSleep" 0

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-UserExperience"
sv_Tag="localhome"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ActiveDirectoryUp"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:mobile" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:mobileconfirm" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:localhome" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:sharepoint" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:useuncpath" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:protocol" "smb"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:alldomains" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:preferredserver" ""

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-UserExperience"
sv_Tag="localhome-cachedcreds"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ActiveDirectoryUp"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:mobile" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:mobileconfirm" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:localhome" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:sharepoint" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:useuncpath" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:protocol" "smb"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:alldomains" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:preferredserver" ""

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-UserExperience"
sv_Tag="localhome-mount"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ActiveDirectoryUp"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:mobile" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:mobileconfirm" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:localhome" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:sharepoint" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:useuncpath" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:protocol" "smb"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:alldomains" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:preferredserver" ""

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-UserExperience"
sv_Tag="localhome-mount-cachedcreds"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ActiveDirectoryUp"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:mobile" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:mobileconfirm" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:localhome" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:sharepoint" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:useuncpath" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:protocol" "smb"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:alldomains" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:preferredserver" ""

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-UserExperience"
sv_Tag="networkhome"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ActiveDirectoryUp"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:mobile" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:mobileconfirm" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:localhome" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:sharepoint" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:useuncpath" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:protocol" "smb"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:alldomains" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:preferredserver" ""

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-UserExperience"
sv_Tag="networkhome-cachedcreds"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ActiveDirectoryUp"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:mobile" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:mobileconfirm" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:localhome" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:sharepoint" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:useuncpath" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:protocol" "smb"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:alldomains" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:preferredserver" ""

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-WiFiControl"
sv_Tag="ManageSSIDs"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:WirelessState" "on"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RememberRecentNetworks" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminIBSS" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminNetworkChange" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminPowerToggle" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:SSIDAllowList:0" "YourGoodSSID1"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:SSIDAllowList:1" "YourGoodSSID2"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:SSIDRemoveList:0" "YourBadSSID1"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:SSIDRemoveList:1" "YourBadSSID1"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-WiFiControl"
sv_Tag="LockedOn"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:WirelessState" "on"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RememberRecentNetworks" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminIBSS" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminNetworkChange" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminPowerToggle" ${GLB_BC_TRUE}

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-WiFiControl"
sv_Tag="Off"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:WirelessState" "off"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RememberRecentNetworks" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminIBSS" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminNetworkChange" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminPowerToggle" ${GLB_BC_TRUE}

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-WiFiControl"
sv_Tag="On"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:WirelessState" "on"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RememberRecentNetworks" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminIBSS" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminNetworkChange" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminPowerToggle" ${GLB_BC_TRUE}

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-AppDataDeleteOnQuit"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-AppDidTerminate"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppData:0:ApplicationBundleIdentifier" "com.adobe.AdobePremierePro"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppData:0:Path:0" "/Library/Application Support/Adobe/Common/Media Cache Files/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppData:0:Path:1" "/Library/Application Support/Adobe/Common/Media Cache/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppData:1:ApplicationBundleIdentifier" "org.chromium.Chromium"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppData:1:Path:0" "/Library/Application Support/Chromium/Default/Pepper Data/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppData:2:ApplicationBundleIdentifier" "com.google.Chrome"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppData:2:Path:0" "/Library/Application Support/Google/Chrome/Default/Pepper Data/"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-AppFirefoxFirstSetup"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-AppWillLaunch"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-AppFirefoxFixForNetworkHomes"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-AppWillLaunch"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Usr-AppDidTerminate"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-AppPrefsPrimer"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-AppWillLaunch"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-AppRestrict"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-AppWillLaunch"

  # Any Application in the ExceptionList is exempt from Whitelist/BlackList checking
  # This allows you to have Apps that will run from any location without having to implement a whitelist
  # The format is ApplicationName1/ApplicationBundleIdentifier1,ApplicationName2/ApplicationBundleIdentifier2,etc
  # If an application has no ApplicationBundleIdentifier then specify ApplicationName/(null) i.e TextWrangler/(null)
  # Regular expressions can be used.

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:0:ApplicationName" "PrinterProxy"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:0:ApplicationBundleIdentifier" 'com\.apple\.print\.PrinterProxy'
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:1:ApplicationName" ".*"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:1:ApplicationBundleIdentifier" "com\.google\.Chrome\.app\..*"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:2:ApplicationName" "Citrix Online Launcher"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:2:ApplicationBundleIdentifier" "com\.citrixonline\.mac\.WebDeploymentApp"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:3:ApplicationName" "GoToMeeting.*"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:3:ApplicationBundleIdentifier" "com\.citrixonline\.GoToMeeting"

  
  # If the WhiteList is not null, then these Applications (and only these) are allowed.
  # When the WhiteList is not null, then it should at least contain "Finder/com.apple.Finder" or maybe even ".*/com.apple\..*"
  # Regular expressions can be used.
  
  # Any Application in the comma-separated BlackList is always disallowed for non-admins
  # Regular expressions can be used.

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:BlackList:0:ApplicationName" "Terminal"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:BlackList:0:ApplicationBundleIdentifier" "com\.apple\.Terminal"
  
  # If the comma-separated path WhiteList is not null, then Applications at the specified paths (and only these paths) are allowed.
  # When the path WhiteList is not null, it should at least contain "/Applications/.*,/System/Library/CoreServices/.*"
  # ~/ is expanded to the current user home before comparison.
  # Regular expressions should be used.
  

  # Any application located at a path in this comma-separated path BlackList is always disallowed for non-admins
  # ~/ is expanded to the current user home before comparison.
  # Regular expressions should be used.
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:PathBlackList:0" "~/.*"
  
  # Should we disallow applications running on mounts
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:OnlyAllowLocalApps" ${GLB_BC_TRUE}

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-AppShowHints"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-AppDidLaunch"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ApplicationBundleIdentifier" "com.adobe.PremierePro.CC12"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppHints:0" "Set Media Cache location via Premiere>Preferences>Media Cache"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppHints:1" "Hide clips in your project panel to remove clutter"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-CheckQuotaOnNetHome"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-Poll"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-CreateFolder"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-ConsoleUserLoggedIn"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Usr-AtDesktop"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:0" "/Desktop/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:1" "/Documents/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:2" "/Downloads/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:3" "/Library/Preferences/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:4" "/Movies/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:5" "/Music/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:6" "/Pictures/"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-CreateHomeFolderAliases"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-AtDesktop"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:0" "/Desktop/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:1" "/Documents/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:2" "/Downloads/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:3" "/Movies/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:4" "/Music/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:5" "/Pictures/"

# GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Legacy:Path:0" "/Library/Application Support/audacity/.audacity.sock"
# GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Legacy:Path:1" "/Library/Application Support/CrashReporter/"
# GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Legacy:Path:2" "/Library/Caches/com.apple.helpd/"
# GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Legacy:Path:3" "/Library/Calendars/"
# GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Legacy:Path:4" "/Library/com.apple.nsurlsessiond/"
# GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Legacy:Path:5" "/Library/Containers/"
# GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Legacy:Path:6" "/Library/IdentityServices/"
# GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Legacy:Path:7" "/Library/Keychains/"
# GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Legacy:Path:8" "/Library/Logs/DiagnosticReports/"
# GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Legacy:Path:9" "/Library/Messages/"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-CreateHomeFolderRedirections"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-AtDesktop"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:0" "/Desktop/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:1" "/Documents/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:2" "/Downloads/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:3" "/Movies/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:4" "/Music/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:5" "/Pictures/"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-DeleteFiles"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:SafeFlag" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Delete:0:Path" "/Library/LaunchAgents/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Delete:0:Exclude:0" "org.virtualbox.vboxwebsrv.plist"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-DesktopWallpaperURI"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-AtDesktop"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:DesktopWallpaperURI" "smb://YOURSERVER/YOURSHARE/YOURFOLDER/desktop.bmp"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-KeychainFix"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-AtDesktop"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-SetDefaultHandlers"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-AtDesktop"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Handler:0:Method" "ContentType"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Handler:0:ContentType" "zip"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Handler:0:Role" "all"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Handler:0:BundleID" "cx.c3.theunarchiver"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Handler:1:Method" "ContentType"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Handler:1:ContentType" "public.xhtml"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Handler:1:Role" "all"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Handler:1:BundleID" "com.google.Chrome"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Handler:2:Method" "URLScheme"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Handler:2:URLScheme" "http"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Handler:2:BundleID" "com.google.Chrome"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Handler:3:Method" "URLScheme"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Handler:3:URLScheme" "https"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Handler:3:BundleID" "com.google.Chrome"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-SetupDock"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Usr-AtDesktop"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Replace" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:0:URI" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:0:Label" "Mail"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:1:URI" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:1:Label" "Contacts"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:2:URI" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:2:Label" "Calendar"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:3:URI" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:3:Label" "Notes"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:4:URI" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:4:Label" "Reminders"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:5:URI" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:5:Label" "Messages"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:6:URI" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:6:Label" "FaceTime"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:7:URI" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:7:Label" "App Store"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:0:URI" "file://%SV_CONSOLEUSERHOMEDIRPATH%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:0:Label" ""
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:1:URI" "file://%SV_CONSOLEUSERHOMEDIRPATH%/Downloads"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:1:Label" ""

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-SetupSidebar"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Usr-AtDesktop"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Replace" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:0:URI" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:0:Label" "All My Files"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:1:URI" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:1:Label" "iCloud"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:2:URI" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:2:Label" "AirDrop"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:3:URI" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Remove:3:Label" "domain-AirDrop"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:0:URI" "file://%SV_CONSOLEUSERHOMEDIRPATH%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:0:Label" ""
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:1:URI" "file://%SV_CONSOLEUSERHOMEDIRPATH%/Desktop"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:1:Label" ""
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:2:URI" "file://%SV_CONSOLEUSERHOMEDIRPATH%/Documents"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:2:Label" ""
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:3:URI" "file://%SV_CONSOLEUSERHOMEDIRPATH%/Downloads"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:3:Label" ""
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:4:URI" "file://%SV_CONSOLEUSERHOMEDIRPATH%/Movies"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:4:Label" ""
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:5:URI" "file://%SV_CONSOLEUSERHOMEDIRPATH%/Music"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:5:Label" ""
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:6:URI" "file://%SV_CONSOLEUSERHOMEDIRPATH%/Pictures"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Add:6:Label" ""

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-SpotlightSettingOnNetHome"
sv_Tag="off"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:SpotlightEnabled" ${GLB_BC_FALSE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-AtDesktop"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Usr-SpotlightSettingOnNetHome"
sv_Tag="on"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:SpotlightEnabled" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-AtDesktop"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Usr-SyncPrefsToNetwork"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-VolDidMount"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Usr-Poll"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:SafeFlag" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:0" "/Library/Fonts/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:1" "/Library/Application Support/Chromium/Default/Bookmarks"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:2" "/Library/Application Support/Chromium/Default/Current Tabs"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:3" "/Library/Application Support/Chromium/Default/History"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:4" "/Library/Application Support/Chromium/Default/Preferences"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:5" "/Library/Application Support/Chromium/First Run"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:6" "/Library/Application Support/Google/Chrome/Default/Bookmarks"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:7" "/Library/Application Support/Google/Chrome/Default/Current Tabs"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:8" "/Library/Application Support/Google/Chrome/Default/History"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:9" "/Library/Application Support/Google/Chrome/Default/Preferences"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:10" "/Library/Application Support/Google/Chrome/First Run"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:11" "/Library/Application Support/Firefox/profiles.ini"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:12" "/Library/Application Support/Firefox/Profiles/mozilla.default/bookmarkbackups/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:13" "/Library/Application Support/Firefox/Profiles/mozilla.default/places.sqlite"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:14" "/Library/Application Support/Firefox/Profiles/mozilla.default/prefs.js"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:15" "/Library/Safari/Bookmarks.plist"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:16" "/Library/Safari/History.db"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:17" "/Library/Safari/TopSites.plist"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
exit 0
# ---
# ---
# exit 0
# ---
# ---
# exit 0
# ---
# ---
# exit 0
# ---
# ---
# exit 0
# ---
# ---
# exit 0
# ---
# ---
# exit 0
# ---
# ---
# exit 0
# ---
# ---
# exit 0
# ---
# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="MacOS10v15v4"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

# 10.[1-9][0-9]($|.[0-9]) match 10.10 - 10.99.99

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_MODEL%:%SV_OS%"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac1[3-9]|iMacPro1|MacBook([8-9]|10)|MacBookAir[5-8]|MacBookPro(9|1[0-5])|Macmini[6-8]|MacPro6),.*"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac(1[3-9]|Pro1)|Mac(Book(([8-9]|10)|Air[5-8]|Pro(9|1[0-5]))|mini[6-8]|Pro6)),.*:10.1([0-4]($|.[0-9])|5($|.[0-3]))"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Value" "%IV_HOUR%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Pattern" "[0-5]|2[2-3]"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Interval" "25200"  # How long to wait between triggered events (7 hours)

#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-app-Apple-Catalina-10v15v4-10v9.dmg"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Always"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi

# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeAcrobatDC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

# 10.[1-9][0-9]($|.[0-9]) match 10.10 - 10.99.99

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_OS%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "10.[1-9][0-9]($|.[0-9])"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Value" "%IV_HOUR%"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Match:Pattern" "[0-5]|2[2-3]"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Interval" "25200"  # How long to wait between triggered events (7 hours)

#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-AcrobatDC-19v0-10v12.dmg"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Acrobat.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Acrobat DC"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "19.0"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
# exit 0
# ---
# exit 0
# ---
# My original idea was to introduce 'Trigger' - I might have changed my mind in favour of 'Match'
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeAcrobatDC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"


GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:EventName" "Sys-ManualTrigger"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:EventName" "Sys-Idle"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:MinIntervalSecs" "25200"  # How long to wait between triggered events (7 hours)
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:End:Hour" "5"

#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-AcrobatDC-19v0-10v12.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Acrobat.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Acrobat DC"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "19.0"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi




# ---
# exit 0
# ---


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeAcrobatDC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-AcrobatDC-19v0-10v12.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Acrobat.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Acrobat DC"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "19.0"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeAnimateCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-AnimateCC2018-18v0v2-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Animate CC 2018.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Animate CC 2018"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "18.0.2"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeAfterEffectsCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-AfterEffectsCC2018-15v1v2-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe After Effects CC 2018.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe After Effects CC 2018"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "15.1.2"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeAuditionCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-AuditionCC2018-11v1v0-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Audition CC 2018.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Audition CC 2018"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "11.1.0"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeBridgeCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-BridgeCC2018-8v1v0-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Bridge CC 2018.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Bridge CC 2018"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "8.1.0"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeCharacterAnimatorCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-CharacterAnimatorCC2018-1v5v0-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Character Animator CC 2018.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Character Animator CC 2018"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "1.5.0"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeDreamweaverCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-DreamweaverCC2018-18v2v1-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Dreamweaver CC 2018.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Dreamweaver CC 2018"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "18.2.1"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeExtensionManagerCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-ExtensionManagerCC2018-7v3v2-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Extension Manager CC.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Extension Manager CC"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "7.3.2"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeExtensionToolkitCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-ExtensionToolkitCC2018-4v0-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "ExtendScript Toolkit.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe ExtendScript Toolkit CC"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleVersion"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleVersion" "4.0"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeFireworksCS6"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-FireworksCS6-12v0v0-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Fireworks CS6.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Fireworks CS6"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleVersion"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleVersion" "12.0.0"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeFlashBuilder"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-FlashBuilder-4v7-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Flash Builder 4.7.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Flash Builder 4.7"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "4.7"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeFuseBetaCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-FuseBetaCC2018-2017v1v0-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.8"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Fuse.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Fuse CC (Beta)"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "2017.1.0"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeGamingSDK"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-GamingSDK-1v4-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "VersionInfo.txt"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "File"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Gaming SDK 1.4"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:File:md5checksum" "34ef3b5ada1541c9f997835ead3127a5"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeIllustratorCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-IllustratorCC2018-22v1v0-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.4.6"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Illustrator.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Illustrator CC 2018"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "22.1.0"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeInCopyCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-InCopyCC2018-13v1v1-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.11.0"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe InCopy CC 2018.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe InCopy CC 2018"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "13.1.1"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeInDesignCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-InDesignCC2018-13v1v1-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.11.0"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe InDesign CC 2018.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe InDesign CC 2018"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "13.1.1"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeLightroomClassicCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-LightroomClassicCC2018-7v5-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.11.0"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Lightroom Classic CC.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Lightroom Classic CC"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleVersion"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleVersion" "7.5"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeMediaEncoderCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-MediaEncoderCC2018-12v1v2-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.11.0"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Media Encoder CC 2018.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Media Encoder CC 2018"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "12.1.2"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobePhotoshopCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-PhotoShopCC2018-19v1v19-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Photoshop CC 2018.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Photoshop CC 2018"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "19.1.9"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobePreludeCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-PreludeCC2018-7v1v1-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Prelude CC 2018.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Prelude CC 2018"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "7.1.1"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobePremiereProCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-PremiereProCC2018-12v1v2-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Premiere Pro CC 2018.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Premiere Pro CC 2018"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "12.1.2"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeScoutCC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-apl-Adobe-ScoutCC2018-1v1v3-10v10.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Scout CC.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "1.1.3"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="MacOS10v13v6"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_MODELIDENTIFIER%"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac1[0-8]|MacBook([6-9]|10)|MacBookAir[3-7]|MacBookPro([6-9]|1[0-4])|Macmini[4-7]|MacPro[5-6]),.*"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac1[0-8]|Mac(Book(([6-9]|10)|Air[3-7]|Pro([6-9]|1[0-4]))|mini[4-7]|Pro[5-6])),.*"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-app-Apple-HighSierra-10v13v6-10v9.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MaxOS" "10.13.5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Always"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="MacOS10v15v4"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_MODELIDENTIFIER%"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac1[3-9]|iMacPro1|MacBook([8-9]|10)|MacBookAir[5-8]|MacBookPro(9|1[0-5])|Macmini[6-8]|MacPro6),.*"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac(1[3-9]|Pro1)|Mac(Book(([8-9]|10)|Air[5-8]|Pro(9|1[0-5]))|mini[6-8]|Pro6)),.*"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-app-Apple-Catalina-10v15v4-10v9.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MaxOS" "10.15.3"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Always"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="Daytime10v15v4"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_MODELIDENTIFIER%"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac1[3-9]|iMacPro1|MacBook([8-9]|10)|MacBookAir[5-8]|MacBookPro(9|1[0-5])|Macmini[6-8]|MacPro6),.*"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac(1[3-9]|Pro1)|Mac(Book(([8-9]|10)|Air[5-8]|Pro(9|1[0-5]))|mini[6-8]|Pro6)),.*"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "5"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "22"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-Apple-Catalina-10v15v4-10v9.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MaxOS" "10.15.3"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Always"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
# exit 0
# ---

# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="MuseScore3"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-GNU-MuseScore-3v2v3.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.12"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "MuseScore 3.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleLongVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleLongVersionString" "3.2.5"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
# exit 0
# ---
# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="Handbrake"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-GNU-HandBrake-1v2v2.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Handbrake.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "1.2.2"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="MacOS10v15v4"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Value" "%SV_MODELIDENTIFIER%"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac1[3-9]|iMacPro1|MacBook([8-9]|10)|MacBookAir[5-8]|MacBookPro(9|1[0-5])|Macmini[6-8]|MacPro6),.*"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Pattern" "(iMac(1[3-9]|Pro1)|Mac(Book(([8-9]|10)|Air[5-8]|Pro(9|1[0-5]))|mini[6-8]|Pro6)),.*"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Match:Condition" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-Apple-Catalina-10v15v4.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MaxOS" "10.15.3"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "LabOSinstall.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Always"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="The Unarchiver"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-DagAgren-TheUnarchiver-4v1v0.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.7"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "The Unarchiver.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "4.1.0"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="Audacity"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-GNU-Audacity-2v3v2.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.7"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Audacity.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleVersion"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleVersion" "2.1.3.0"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="Handbrake"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-GNU-HandBrake-1v2v2.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Handbrake.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "1.2.2"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="LibreOffice"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-GNU-LibreOffice-6v3v0.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "LibreOffice.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "6.3.4"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="MuseScore3"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-GNU-MuseScore-3v2v3.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.12"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "MuseScore 3.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleLongVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleLongVersionString" "3.2.5"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="VLC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-GNU-VLC-3v0v7v1.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.7.5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "VLC.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "3.0.7.1"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="GoogleChrome"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-Google-GoogleChrome-76v0v3809v132.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Google Chrome.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "76.0.3809.132"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="MicrosoftExcel"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-Microsoft-Excel-16v16v17.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Microsoft Excel.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "16.16.17"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="MicrosoftOutlook"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-Microsoft-Outlook-16v16v17.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Microsoft Outlook.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "16.16.17"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="MicrosoftPowerPoint"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-Microsoft-PowerPoint-16v16v17.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Microsoft PowerPoint.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "16.16.17"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="MicrosoftWord"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Volumes/REPO/MacOS-Microsoft-Word-16v16v17.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Microsoft Word.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "16.16.17"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="AdobeAcrobatDC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "10"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "smb://GUEST:@192.168.0.12/offline's%20Public%20Folder/MacOS-Adobe-AcrobatDC-19v0.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Install.command"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Fix"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:FileName" "Adobe Acrobat.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:TryMethod" "Never"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:SrcDir" "/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:DstDir" "/Applications/Adobe Acrobat DC"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:1:Application:CFBundleShortVersionString" "19.0"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
# exit 0


# ---
GLB_SV_POLICYNAME="Sys-SchedulePowerOn"
sv_Tag="Summer2019"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Poll"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-NetworkUp"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name" "Sys-LoginWindowIdle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Day" "20"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Month" "7"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Year" "2019"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Minute" "0"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Day" "2"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Month" "9"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Minute" "0"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ShutdownOnIdleSecs" "1200"        # Should we shut workstations down if idle at the LoginWindow    

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi




# ---
# exit 0
# ---

# BUILD LEGACY POLICY REPLACEMENT PROFILES

# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="Radmind"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file://localhost/usr/local/LabWarden/bin"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.7"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "RadmindUpdate"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Executable:Args" "192.168.0.3,sha1,0,-I,80000 http://192.168.0.3/LabWarden/RadmindNotify.php"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="LabWarden"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "https://raw.githubusercontent.com/execriez/LabWarden/master/SupportFiles/LabWarden.pkg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.7"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "LabWarden.pkg"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Package"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Package:VersionString" "${GLB_SC_PROJECTVERSION}"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Package:ID" "${GLB_SC_PROJECTSIGNATURE}"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="LabWarden-netlogon"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "smb://%SV_ADFLATDOMAINNAME%/NETLOGON/MacOS/Packages/LabWarden.pkg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.7"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "LabWarden.pkg"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Package"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Package:VersionString" "${GLB_SC_PROJECTVERSION}"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Package:ID" "${GLB_SC_PROJECTSIGNATURE}"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
# exit 0
# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="Audacity"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "https://www.fosshub.com/Audacity.html?dwl=audacity-macos-2.3.2.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.7"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Audacity.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleVersion"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleVersion" "2.1.3.0"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="Cyberduck"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "https://a48823c7ec3cf4539564-60c534a1284a12ce74ef84032e9b4e46.ssl.cf1.rackcdn.com/Cyberduck-7.0.1.30930.zip"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.7.3"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Cyberduck.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "7.0.1"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="Cyberduck - Repo"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Users/local/Desktop/SoftwareRepository/Cyberduck-7.0.1.30930.zip"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.7.3"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Cyberduck.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "7.0.1"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="Google Chrome"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Google Chrome.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "76.0.3809.132"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="Google Chrome - Repo"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file:///Users/local/Desktop/SoftwareRepository/googlechrome.tgz"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Google Chrome.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "76.0.3809.100"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="Handbrake"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "https://download.handbrake.fr/releases/1.2.2/HandBrake-1.2.2.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Handbrake.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "1.2.2"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="LibreOffice"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "https://mirrors.ukfast.co.uk/sites/documentfoundation.org/tdf/libreoffice/stable/6.3.0/mac/x86_64/LibreOffice_6.3.0_MacOS_x86-64.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.10"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "LibreOffice.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "6.3.4"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="MuseScore2"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "https://ftp.osuosl.org/pub/musescore/releases/MuseScore-2.3.2/MuseScore-2.3.2.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.7"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MaxOS" "10.11.6"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "MuseScore 2.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleLongVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleLongVersionString" "2.3.2"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="MuseScore3"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "https://github.com/musescore/MuseScore/releases/download/v3.2.5/MuseScore-3.2.5.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.12"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "MuseScore 3.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleLongVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleLongVersionString" "3.2.5"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="VLC"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "https://videolan.mirrors.nublue.co.uk/vlc/3.0.7.1/macosx/vlc-3.0.7.1.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.7.5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "VLC.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "3.0.7.1"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="The Unarchiver"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "https://dl.devmate.com/com.macpaw.site.theunarchiver/TheUnarchiver.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.7"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "The Unarchiver.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "4.1.0"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="Adobe Brackets"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "https://github.com/adobe/brackets/releases/download/release-1.14/Brackets.Release.1.14.dmg"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.11"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Brackets.app"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:SrcDir" "/"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleVersion"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleVersion" "1.14"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-SoftwareManifest"
sv_Tag="Munki"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-Idle"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Start:Hour" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:End:Hour" "5"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:IdleDelaySecs" "900"   # How long to wait before updating workstations when idle at the LoginWindow    
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ManifestURI" "file://localhost/usr/local/munki"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MinOS" "10.7"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Action" "Install"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "managedsoftwareupdate"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Executable"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:TryMethod" "Once"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Executable:Args" "--auto"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
# exit 0
























# BUILD POLICY PROFILE PAYLOADS

# ---
# exit 0
# ---

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe Photoshop CC 2018.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:TryMethod" "CheckOnly"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "19.1.19"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe Animate CC 2018.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:DstDir" "/Applications/Adobe Animate CC 2018"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "18.0.1"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe Audition CC 2018.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "11.1.0"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe Bridge CC 2018.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "8.0.1.282"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe Character Animator CC 2018.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "1.5"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe Dreamweaver CC 2018.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "18.2.0.10165"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe Fireworks CS6.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleVersion"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleVersion" "12.0.1"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe Flash Builder 4.7.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "4.7"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Fuse.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "2017.1.0"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe Illustrator CC 2018.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "22.1.0"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe InCopy CC 2018.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "13.1.0.76"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe InDesign CC 2018.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "13.1.0.76"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe Lightroom Classic CC.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleVersion"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleVersion" "7.4"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe Media Encoder CC 2018.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "12.1.1.12"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe Photoshop CC 2018.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "19.1.5"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe Prelude CC 2018.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "7.1"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe Premiere Pro CC 2018.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "12.1.1"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:FileName" "Adobe Premiere Pro CC 2018.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Type" "Application"
#GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:VersionKey" "CFBundleShortVersionString"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Item:0:Application:CFBundleShortVersionString" "12.1.1"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi





# ---
GLB_SV_POLICYNAME="Sys-ExamplePolicy"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-LoginWindow"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name" "Sys-LoginWindowPoll"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:3:Name" "Sys-LoginWindowIdle"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:4:Name" "Sys-InterfaceUp"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:5:Name" "Sys-InterfaceDown"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:6:Name" "Sys-NetworkUp"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:7:Name" "Sys-NetworkDown"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:8:Name" "Sys-ActiveDirectoryUp"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:9:Name" "Sys-ActiveDirectoryDown"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:10:Name" "Sys-ConsoleUserLoggedIn"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:11:Name" "Sys-ConsoleUserLoggedOut"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:12:Name" "Sys-ConsoleUserSwitch"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:13:Name" "Sys-Poll"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:14:Name" "Sys-Idle"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:15:Name" "Sys-VolDidMount"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:16:Name" "Sys-VolWillUnmount"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:17:Name" "Sys-VolDidUnmount"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:18:Name" "Sys-IdleSleep"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:19:Name" "Sys-WillSleep"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:20:Name" "Sys-WillWake"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:21:Name" "Sys-HasWoken"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExampleBool" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExampleNum" "42"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExampleString" "Example"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:0" "First"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:1" "Second"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:2" "Third"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Usr-ExamplePolicy"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-ConsoleUserLoggedIn"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Usr-ConsoleUserLoggedOut"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name" "Usr-ConsoleUserSwitch"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:3:Name" "Usr-AtDesktop"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:4:Name" "Usr-AppWillLaunch"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:5:Name" "Usr-AppDidLaunch"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:6:Name" "Usr-AppDidTerminate"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:7:Name" "Usr-Poll"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:8:Name" "Usr-Idle"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:9:Name" "Usr-VolDidMount"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name0" "Usr-VolWillUnmount"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name1" "Usr-VolDidUnmount"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExampleBool" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExampleNum" "42"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExampleString" "Example"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:0" "First"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:1" "Second"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExampleArray:2" "Third"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi



# ---
GLB_SV_POLICYNAME="Sys-ADTrustAccountProxyAccess"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:0:Protocol" "http"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:0:Address" "PROXYADDRESS"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:0:Port" "PROXYPORT"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:1:Protocol" "htps"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:1:Address" "PROXYADDRESS"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Proxy:1:Port" "PROXYPORT"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:0" "/System/Library/CoreServices/AppleIDAuthAgent"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:1" "/System/Library/CoreServices/Software Update.app/Contents/Resources/softwareupdated"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:2" "/System/Library/CoreServices/Spotlight.app/Contents/MacOS/Spotlight"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:3" "/System/Library/CoreServices/mapspushd"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:4" "/System/Library/PrivateFrameworks/ApplePushService.framework/apsd"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:5" "/System/Library/PrivateFrameworks/AuthKit.framework/Versions/A/Support/akd"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:6" "/System/Library/PrivateFrameworks/CommerceKit.framework/Versions/A/Resources/storeaccountd"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:7" "/System/Library/PrivateFrameworks/CommerceKit.framework/Versions/A/Resources/storeassetd"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:8" "/System/Library/PrivateFrameworks/GeoServices.framework/Versions/A/XPCServices/com.apple.geod.xpc"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:9" "/System/Library/PrivateFrameworks/HelpData.framework/Versions/A/Resources/helpd"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:10" "/System/Library/PrivateFrameworks/IDS.framework/identityservicesd.app"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:11" "/System/Library/PrivateFrameworks/PassKitCore.framework/passd"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:12" "/System/Library/PrivateFrameworks/SoftwareUpdate.framework/Versions/A/Resources/suhelperd"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:13" "/usr/libexec/captiveagent"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:14" "/usr/libexec/keyboardservicesd"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:15" "/usr/libexec/locationd"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:16" "/usr/libexec/nsurlsessiond"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:17" "/usr/libexec/rtcreportingd"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Process:18" "/usr/sbin/ocspd"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-Debug"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-ConsoleUserLoggedIn"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Usr-ConsoleUserSwitch"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name" "Usr-AtDesktop"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:3:Name" "Usr-AppWillLaunch"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:4:Name" "Usr-AppDidLaunch"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:5:Name" "Usr-AppDidTerminate"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:6:Name" "Usr-Poll"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:7:Name" "Usr-Idle"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:8:Name" "Usr-VolDidMount"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:9:Name" "Usr-VolWillUnmount"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name0" "Usr-VolDidUnmount"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name1" "Sys-ManualTrigger"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name2" "Sys-Boot"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name3" "Sys-LoginWindow"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name4" "Sys-LoginWindowIdle"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name5" "Sys-LoginWindowPoll"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name6" "Sys-InterfaceUp"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name7" "Sys-InterfaceDown"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name8" "Sys-NetworkUp"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name9" "Sys-NetworkDown"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name0" "Sys-ActiveDirectoryUp"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name1" "Sys-ActiveDirectoryDown"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name2" "Sys-ConsoleUserLoggedIn"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name3" "Sys-ConsoleUserLoggedOut"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name4" "Sys-ConsoleUserSwitch"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name5" "Sys-Poll"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name6" "Sys-Idle"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name7" "Sys-VolDidMount"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name8" "Sys-VolWillUnmount"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name9" "Sys-VolDidUnmount"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:3:Name0" "Sys-IdleSleep"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:3:Name1" "Sys-WillSleep"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:3:Name2" "Sys-WillWake"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:3:Name3" "Sys-HasWoken"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-RestartIfNetMount"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-LoginWindow"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi



# ---
GLB_SV_POLICYNAME="Sys-WiFiRemoveUnknownSSIDs"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:KnownSSIDs:0" "YourSSID"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-WirelessForgetSSID"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:SSID:0" "College"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:SSID:1" "virginmedia1234567"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi









# ---

# Remove temporary files
cd "${GLB_SV_PROJECTDIRPATH}"
rm -fR "${GLB_SV_THISSCRIPTTEMPDIRPATH}"

# ---
# exit 0
# ---
# exit 0
# ---
# exit 0
# ---

# BUILD LEGACY PAYLOADS

# ---
GLB_SV_POLICYNAME="App-DeleteDataOnQuit"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "App-DidTerminate"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppData:0:ApplicationBundleIdentifier" "com.adobe.AdobePremierePro"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppData:0:Path:0" "/Library/Application Support/Adobe/Common/Media Cache Files/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppData:0:Path:1" "/Library/Application Support/Adobe/Common/Media Cache/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppData:1:ApplicationBundleIdentifier" "org.chromium.Chromium"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppData:1:Path:0" "/Library/Application Support/Chromium/Default/Pepper Data/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppData:2:ApplicationBundleIdentifier" "com.google.Chrome"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppData:2:Path:0" "/Library/Application Support/Google/Chrome/Default/Pepper Data/"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
GLB_SV_POLICYNAME="App-FirefoxFirstSetup"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "App-WillLaunch"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
GLB_SV_POLICYNAME="App-FirefoxFixForNetworkHomes"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "App-WillLaunch"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "App-DidTerminate"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
GLB_SV_POLICYNAME="App-PrefsPrimer"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "App-WillLaunch"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
GLB_SV_POLICYNAME="App-Restrict"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "App-WillLaunch"

  # Any Application in the ExceptionList is exempt from Whitelist/BlackList checking
  # This allows you to have Apps that will run from any location without having to implement a whitelist
  # The format is ApplicationName1/ApplicationBundleIdentifier1,ApplicationName2/ApplicationBundleIdentifier2,etc
  # If an application has no ApplicationBundleIdentifier then specify ApplicationName/(null) i.e TextWrangler/(null)
  # Regular expressions can be used.

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:0:ApplicationName" "PrinterProxy"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:0:ApplicationBundleIdentifier" 'com\.apple\.print\.PrinterProxy'
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:1:ApplicationName" ".*"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:1:ApplicationBundleIdentifier" "com\.google\.Chrome\.app\..*"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:2:ApplicationName" "Citrix Online Launcher"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:2:ApplicationBundleIdentifier" "com\.citrixonline\.mac\.WebDeploymentApp"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:3:ApplicationName" "GoToMeeting.*"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ExceptionList:3:ApplicationBundleIdentifier" "com\.citrixonline\.GoToMeeting"

  
  # If the WhiteList is not null, then these Applications (and only these) are allowed.
  # When the WhiteList is not null, then it should at least contain "Finder/com.apple.Finder" or maybe even ".*/com.apple\..*"
  # Regular expressions can be used.
  
  # Any Application in the comma-separated BlackList is always disallowed for non-admins
  # Regular expressions can be used.

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:BlackList:0:ApplicationName" "Terminal"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:BlackList:0:ApplicationBundleIdentifier" "com\.apple\.Terminal"
  
  # If the comma-separated path WhiteList is not null, then Applications at the specified paths (and only these paths) are allowed.
  # When the path WhiteList is not null, it should at least contain "/Applications/.*,/System/Library/CoreServices/.*"
  # ~/ is expanded to the current user home before comparison.
  # Regular expressions should be used.
  

  # Any application located at a path in this comma-separated path BlackList is always disallowed for non-admins
  # ~/ is expanded to the current user home before comparison.
  # Regular expressions should be used.
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:PathBlackList:0" "~/.*"
  
  # Should we disallow applications running on mounts
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:OnlyAllowLocalApps" "true"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
GLB_SV_POLICYNAME="App-ShowHints"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "App-DidLaunch"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:ApplicationBundleIdentifier" "com.apple.logic10"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:IsAdmin" "false"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:IsLocalAccount" "false"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:IsLocalHome" "false"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:0:MessageContent" "APPNAME works better off network"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:1:ApplicationBundleIdentifier" "com.adobe.AdobePremierePro"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:AppHint:1:MessageContent" "Setup your Media Cache File location (Premiere>Preferences>Media)"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
GLB_SV_POLICYNAME="Gen-OfficeHours"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-NetworkUp"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name" "Sys-Poll"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:3:Name" "Usr-AtDesktop"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:4:Name" "Usr-Poll"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:Start:Day" "25"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:Start:Month" "11"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:Start:Year" "2016"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:End:Day" "03"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:End:Month" "09"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ActiveForDates:End:Year" "2017"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Audit:Active" ${GLB_BC_TRUE}                          # Whether we should audit usage, true or false
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Audit:HideUntilAgeSecs" "604800"              # Dont show audit at LoginWindow until its at least 1 day old

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ForceLogout:ActiveForDomain:0" "ALL"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ForceLogout:InactiveForGroup:0" "All-Staff"   # list of groups that are exempt from force logout
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ForceLogout:InactiveOnClosedDays" ${GLB_BC_TRUE}      # Should we allow unrestricted access on days that are defined as closed
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ForceLogout:EarlyLogoutSecs" "600"            # logout user 10 mins before closing
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ForceLogout:EarlyLoginSecs" "3600"            # allow user login 60 mins before opening
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ForceLogout:EarlyWarningSecs" "600"           # Warn user 10 mins before force logout
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ForceLogout:IdleUserSecs" "1800"              # How long before we force logout idle users (0 = never)  

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:CoreOpeningTime" "9:30"    # Mon
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:CoreClosingTime" "16:30"    # Mon

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day1:OpenTime" "8:30"    # Mon
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day1:CloseTime" "21:00"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day2:OpenTime" "8:30"    # Tue
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day2:CloseTime" "21:00"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day3:OpenTime" "8:30"    # Wed
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day3:CloseTime" "21:00"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day4:OpenTime" "8:30"    # Thu
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day4:CloseTime" "21:00"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day5:OpenTime" "8:30"    # Fri
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day5:CloseTime" "17:00"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day6:OpenTime" ""   # Sat
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day6:CloseTime" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day7:OpenTime" ""        # Sun
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:NormalHours:Day7:CloseTime" ""

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:Start:Day" "22"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:Start:Month" "12"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:Start:Year" "2017"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:End:Day" "7"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:End:Month" "1"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:0:End:Year" "2018"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:Start:Day" "24"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:Start:Month" "3"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:Start:Year" "2018"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:End:Day" "8"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:End:Month" "4"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ClosedDays:1:End:Year" "2018"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:Start:Day" "28"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:Start:Month" "10"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:Start:Year" "2017"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:End:Day" "5"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:End:Month" "11"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:0:End:Year" "2017"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:Start:Day" "10"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:Start:Month" "2"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:Start:Year" "2018"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:End:Day" "18"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:End:Month" "2"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:DateRange:1:End:Year" "2018"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day1:OpenTime" "8:30"    # Mon
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day1:CloseTime" "16:00"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day2:OpenTime" "8:30"    # Tue
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day2:CloseTime" "16:00"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day3:OpenTime" "8:30"    # Wed
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day3:CloseTime" "16:00"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day4:OpenTime" "8:30"    # Thu
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day4:CloseTime" "16:00"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day5:OpenTime" "8:30"    # Fri
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day5:CloseTime" "16:00"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day6:OpenTime" ""   # Sat
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day6:CloseTime" ""
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day7:OpenTime" ""        # Sun
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HolidayHours:0:Day7:CloseTime" ""

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Gen-UnloadAgentsAndDaemons"
sv_Tag="proxypopups"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Usr-ConsoleUserLoggedIn"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Unload:0" "com.apple.UserNotificationCenter"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-Update"
sv_Tag="Radmind"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-LoginWindow"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-LoginWindowIdle"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:2:Name" "Sys-Poll"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:3:Name" "Sys-ManualTrigger"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:OutOfHoursPowerOn" ${GLB_BC_TRUE}

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:OutOfHoursStartTime" "22:00"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:OutOfHoursEndTime" "05:00"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:UpdateScript:ActiveForDomain:0" "ALL"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:UpdateScript:Exe:0" "file://localhost/usr/local/LabWarden/bin/RadmindUpdate"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:UpdateScript:Exe:1" "192.168.0.3,sha1,0,-I,42000"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:LoginWindowIdleShutdownSecs" "1200"        # Should we shut workstations down if idle at the LoginWindow    

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Usr-HomeMakePathRedirections"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${sv_PolicyName}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Usr-ConsoleUserLoggedIn"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Usr-AtDesktop"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:MakePathRedirections" "true"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:0" "/Desktop/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:1" "/Documents/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:2" "/Downloads/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:3" "/Movies/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:4" "/Music/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsLocal:Path:5" "/Pictures/"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:0" "/Library/Application Support/audacity/.audacity.sock"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:1" "/Library/Application Support/CrashReporter/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:2" "/Library/Caches/com.apple.helpd/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:3" "/Library/Calendars/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:4" "/Library/com.apple.nsurlsessiond/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:5" "/Library/Containers/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:6" "/Library/IdentityServices/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:7" "/Library/Keychains/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:8" "/Library/Logs/DiagnosticReports/"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:HomeIsOnNetwork:Path:9" "/Library/Messages/"

/usr/local/LabWarden/util/PackForDeployment "${sv_ConfigFilePath}"

# ---
GLB_SV_POLICYNAME="Sys-InstallPackageFromFolder"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Idle"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-ManualTrigger"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Path:0" "/usr/local/Updates"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-UpdatePackage"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Idle"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-ManualTrigger"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Package:0:ID" "${GLB_SC_PROJECTSIGNATURE}"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Package:0:VersionString" "${GLB_SC_PROJECTVERSION}"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Package:0:URI" "https://raw.githubusercontent.com/execriez/LabWarden/master/SupportFiles/LabWarden.pkg"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-UpdatePackage"
sv_Tag="netlogon"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Idle"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-ManualTrigger"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Package:0:ID" "${GLB_SC_PROJECTSIGNATURE}"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Package:0:VersionString" "3.0.2"
GLB_NF_RAWSETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:Package:0:URI" "smb://%SV_ADFLATDOMAINNAME%/NETLOGON/MacOS/Packages/LabWarden.pkg"

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-WirelessSetState"
sv_Tag="fixed"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:WirelessState" "on"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminIBSS" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminNetworkChange" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminPowerToggle" ${GLB_BC_TRUE}

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-WirelessSetState"
sv_Tag="off"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:WirelessState" "off"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminIBSS" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminNetworkChange" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminPowerToggle" ${GLB_BC_TRUE}

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-WirelessSetState"
sv_Tag="on"

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:WirelessState" "on"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminIBSS" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminNetworkChange" ${GLB_BC_FALSE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:RequireAdminPowerToggle" ${GLB_BC_TRUE}

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---
GLB_SV_POLICYNAME="Sys-WorkstationInfo"
sv_Tag=""

sv_Info="$(sf_MakeConfigFile "${GLB_SV_POLICYNAME}" "${sv_Tag}")"
sv_ThisConfigFilePath="$(echo ${sv_Info} | cut -d"," -f1)"
sv_PropertyBase="$(echo ${sv_Info} | cut -d"," -f2)"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Name" "${GLB_SV_POLICYNAME}"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:0:Name" "Sys-Boot"
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Trigger:1:Name" "Sys-ActiveDirectoryUp"

GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ShowHostnameAtLoginwindow" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ShowADpathAtLoginwindow" ${GLB_BC_TRUE}
GLB_NF_SETPLISTPROPERTY "${sv_ThisConfigFilePath}" "${sv_PropertyBase}:Config:ShowADpathInRemoteDesktopInfo" ${GLB_BC_TRUE}

if [ -e "/usr/local/LabNotes/bin/PackForDeployment" ]
then
  "/usr/local/LabNotes/bin/PackForDeployment" "${sv_ThisConfigFilePath}"
fi


# ---

# Remove temporary files
cd "${GLB_SV_PROJECTDIRPATH}"
rm -fR "${GLB_SV_THISSCRIPTTEMPDIRPATH}"

