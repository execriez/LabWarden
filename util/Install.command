#!/bin/bash
#
# Short:    Install LabWarden
# Author:   Mark J Swift
# Version:  1.0.101
# Modified: 09-Dec-2016
#
#
# Called as follows:    
#   Install.command [<root_dirpath>]

# ---

# Full souce of this script
sv_ThisScriptFilePath="${0}"

# Path to this script
sv_ThisScriptDirPath="$(dirname "${sv_ThisScriptFilePath}")"

# Change working directory
cd "${sv_ThisScriptDirPath}"

# Filename of this script
sv_ThisScriptFileName="$(basename "${sv_ThisScriptFilePath}")"

# Filename without extension
sv_ThisScriptName="$(echo ${sv_ThisScriptFileName} | sed 's|\.[^.]*$||')"

# ---

# Load the contants, only if they are not already loaded
if test -z "${LW_sv_LabWardenSignature}"
then
  . "$(dirname "${sv_ThisScriptDirPath}")"/lib/Constants
fi

# ---

# Where we should install
sv_RootDirPath="${1}"

# ---

# Path to payload
sv_PayloadDirPath="$(dirname "${sv_ThisScriptDirPath}")"
if [ "${sv_PayloadDirPath}" = "${sv_RootDirPath}/usr/local/LabWarden" ]
then
  echo >&2 "ERROR: You cannot install to the folder that you are installing from. Copy the folder somewhere else and try again."
  exit 0
fi

# ---

# Get user name
sv_ThisUserName="$(whoami)"

# ---

# Check if user is an admin (returns "true" or "false")
if [ "$(dseditgroup -o checkmember -m "${sv_ThisUserName}" -n . admin | cut -d" " -f1)" = "yes" ]
then
  bv_ThisUserIsAdmin="true"
else
  bv_ThisUserIsAdmin="false"
fi

# ---

if [ "${bv_ThisUserIsAdmin}" = "false" ]
then
  echo >&2 "ERROR: You must be an admin to install this software."
  exit 0
fi

# ---

if [ "${sv_ThisUserName}" != "root" ]
then
  echo ""
  echo "If asked, enter the password for user '"${sv_ThisUserName}"'"
  echo ""
  sudo "${sv_ThisScriptFilePath}" "${sv_RootDirPath}"

else

  # Initial warning
  sv_ADDomainNameDNS=$(echo "show com.apple.opendirectoryd.ActiveDirectory" | scutil | grep "DomainNameDns" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  if test -z "${sv_ADDomainNameDNS}"
  then
    echo >&2 "WARNING: This workstation doesn't appear to be bound to an AD domain"
    echo ""
  fi

  # Remove old install
  "${sv_ThisScriptDirPath}/Uninstall.command" "${sv_RootDirPath}"

  echo "Installing LabWarden."
  echo ""

  # Create a temporary directory private to this script
  sv_ThisScriptTempDirPath="$(mktemp -dq /tmp/Install-XXXXXXXX)"

  # -- Copy the main payload
  mkdir -p "${sv_ThisScriptTempDirPath}/LabWarden"
  cp -pR "${sv_PayloadDirPath}/" "${sv_ThisScriptTempDirPath}/LabWarden/"

  # -- Remove any unwanted files
  rm -fR "${sv_ThisScriptTempDirPath}/LabWarden/SupportFiles"
  rm -fR "${sv_ThisScriptTempDirPath}/LabWarden/.git"
  find -d "${sv_ThisScriptTempDirPath}/LabWarden" -ipath "*/Custom/*" -exec rm -fd {} \;
  find "${sv_ThisScriptTempDirPath}/LabWarden" -iname .DS_Store -exec rm -f {} \;

  # -- Copy the example Custom policies
  mkdir -p "${sv_ThisScriptTempDirPath}/LabWarden/Custom/Policies/"
  mkdir -p "${sv_ThisScriptTempDirPath}/LabWarden/Custom/PayloadHandlers/"
  find -d "${sv_PayloadDirPath}/Custom/Policies/" -iname "*Example*" -exec cp "{}" ${sv_ThisScriptTempDirPath}/LabWarden/Custom/Policies/ \;
  find -d "${sv_PayloadDirPath}/Custom/PayloadHandlers/" -iname "*Example*" -exec cp "{}" ${sv_ThisScriptTempDirPath}/LabWarden/Custom/PayloadHandlers/ \;

  # Lets begin
  # Note, most of the tests on the payload content could be removed (legacy debug stuff)
  
  mkdir -p "${sv_RootDirPath}"/usr/local/LabWarden
  chown root:wheel "${sv_RootDirPath}"/usr/local/LabWarden
  chmod 755 "${sv_RootDirPath}"/usr/local/LabWarden

  if test -z "${sv_RootDirPath}"
  then
    mkdir -p "${sv_RootDirPath}"/Library/Preferences/SystemConfiguration/${LW_sv_LabWardenSignature}
    chown root:wheel "${sv_RootDirPath}"/Library/Preferences/SystemConfiguration/${LW_sv_LabWardenSignature}
    chmod 755 "${sv_RootDirPath}"/Library/Preferences/SystemConfiguration/${LW_sv_LabWardenSignature}
  fi

  if test -f "${sv_ThisScriptTempDirPath}/LabWarden/LICENSE"
  then
    cp "${sv_ThisScriptTempDirPath}/LabWarden/LICENSE" "${sv_RootDirPath}"/usr/local/LabWarden/
    chown root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/LICENSE
    chmod 755 "${sv_RootDirPath}"/usr/local/LabWarden/LICENSE
  fi
  
  if test -f "${sv_ThisScriptTempDirPath}/LabWarden/README.md"
  then
    cp "${sv_ThisScriptTempDirPath}/LabWarden/README.md" "${sv_RootDirPath}"/usr/local/LabWarden/
    chown root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/README.md
    chmod 755 "${sv_RootDirPath}"/usr/local/LabWarden/README.md
  fi
  
  if test -d "${sv_ThisScriptTempDirPath}/LabWarden/images"
  then
    mkdir -p "${sv_RootDirPath}"/usr/local/LabWarden/images
    chown root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/images
    chmod 755 "${sv_RootDirPath}"/usr/local/LabWarden/images

    cp -pR "${sv_ThisScriptTempDirPath}/LabWarden/images/" "${sv_RootDirPath}"/usr/local/LabWarden/images/
    chown -R root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/images
    chmod -R 755 "${sv_RootDirPath}"/usr/local/LabWarden/images
  fi

  if test -d "${sv_ThisScriptTempDirPath}/LabWarden/bin"
  then
    mkdir -p "${sv_RootDirPath}"/usr/local/LabWarden/bin
    chown root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/bin
    chmod 755 "${sv_RootDirPath}"/usr/local/LabWarden/bin

    cp -pR "${sv_ThisScriptTempDirPath}/LabWarden/bin/" "${sv_RootDirPath}"/usr/local/LabWarden/bin/
    chown -R root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/bin
    chmod -R 755 "${sv_RootDirPath}"/usr/local/LabWarden/bin

    mkdir -p "${sv_RootDirPath}"/usr/local/LabWarden/bin/Custom
    chown root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/bin/Custom
    chmod 755 "${sv_RootDirPath}"/usr/local/LabWarden/bin/Custom

    if test -f "${sv_ThisScriptTempDirPath}/LabWarden/bin/appwarden"
    then
      cat << EOF > "${sv_RootDirPath}"/Library/LaunchAgents/${LW_sv_LabWardenSignature}.appwarden.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${LW_sv_LabWardenSignature}.appwarden</string>
	<key>Program</key>
	<string>/usr/local/LabWarden/bin/appwarden</string>
	<key>RunAtLoad</key>
	<true/>
	<key>KeepAlive</key>
	<false/>
</dict>
</plist>
EOF
      chown root:wheel "${sv_RootDirPath}"/Library/LaunchAgents/${LW_sv_LabWardenSignature}.appwarden.plist
      chmod 644 "${sv_RootDirPath}"/Library/LaunchAgents/${LW_sv_LabWardenSignature}.appwarden.plist

    fi

    if test -f "${sv_ThisScriptTempDirPath}/LabWarden/bin/NetworkStateWarden"
    then
      cat << EOF > "${sv_RootDirPath}"/Library/LaunchDaemons/${LW_sv_LabWardenSignature}.NetworkStateWarden.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${LW_sv_LabWardenSignature}.NetworkStateWarden</string>
	<key>Program</key>
	<string>/usr/local/LabWarden/bin/NetworkStateWarden</string>
	<key>RunAtLoad</key>
	<true/>
	<key>KeepAlive</key>
	<false/>
</dict>
</plist>
EOF
      chown root:wheel "${sv_RootDirPath}"/Library/LaunchDaemons/${LW_sv_LabWardenSignature}.NetworkStateWarden.plist
      chmod 644 "${sv_RootDirPath}"/Library/LaunchDaemons/${LW_sv_LabWardenSignature}.NetworkStateWarden.plist

    fi

  fi
    
  if test -d "${sv_ThisScriptTempDirPath}/LabWarden/util"
  then
    mkdir -p "${sv_RootDirPath}"/usr/local/LabWarden/util
    chown root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/util
    chmod 755 "${sv_RootDirPath}"/usr/local/LabWarden/util

    cp -pR "${sv_ThisScriptTempDirPath}/LabWarden/util/" "${sv_RootDirPath}"/usr/local/LabWarden/util/
    chown -R root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/util
    chmod -R 755 "${sv_RootDirPath}"/usr/local/LabWarden/util
  fi
    
  if test -d "${sv_ThisScriptTempDirPath}/LabWarden/lib"
  then
    mkdir -p "${sv_RootDirPath}"/usr/local/LabWarden/lib
    chown root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/lib
    chmod 755 "${sv_RootDirPath}"/usr/local/LabWarden/lib

    cp -pR "${sv_ThisScriptTempDirPath}/LabWarden/lib/" "${sv_RootDirPath}"/usr/local/LabWarden/lib/
    chown -R root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/lib
    chmod -R 755 "${sv_RootDirPath}"/usr/local/LabWarden/lib
  fi
    
  if test -d "${sv_ThisScriptTempDirPath}/LabWarden/PayloadHandlers"
  then
    mkdir -p "${sv_RootDirPath}"/usr/local/LabWarden/PayloadHandlers
    chown root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/PayloadHandlers
    chmod 755 "${sv_RootDirPath}"/usr/local/LabWarden/PayloadHandlers

    cp -pR "${sv_ThisScriptTempDirPath}/LabWarden/PayloadHandlers/" "${sv_RootDirPath}"/usr/local/LabWarden/PayloadHandlers/
    chown -R root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/PayloadHandlers
    chmod -R 755 "${sv_RootDirPath}"/usr/local/LabWarden/PayloadHandlers
  fi
    
  if test -d "${sv_ThisScriptTempDirPath}/LabWarden/Custom"
  then
    mkdir -p "${sv_RootDirPath}"/usr/local/LabWarden/Custom
    chown root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/Custom
    chmod 755 "${sv_RootDirPath}"/usr/local/LabWarden/Custom

    cp -pR "${sv_ThisScriptTempDirPath}/LabWarden/Custom/" "${sv_RootDirPath}"/usr/local/LabWarden/Custom/
    chown -R root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/Custom
    chmod -R 755 "${sv_RootDirPath}"/usr/local/LabWarden/Custom
  fi
    
  if test -d "${sv_ThisScriptTempDirPath}/LabWarden/Legacy"
  then
    mkdir -p "${sv_RootDirPath}"/usr/local/LabWarden/Legacy
    chown root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/Legacy
    chmod 755 "${sv_RootDirPath}"/usr/local/LabWarden/Legacy

    cp -pR "${sv_ThisScriptTempDirPath}/LabWarden/Legacy/" "${sv_RootDirPath}"/usr/local/LabWarden/Legacy/
    chown -R root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/Legacy
    chmod -R 755 "${sv_RootDirPath}"/usr/local/LabWarden/Legacy
  fi
    
  if test -d "${sv_ThisScriptTempDirPath}/LabWarden/Policies"
  then
    mkdir -p "${sv_RootDirPath}"/usr/local/LabWarden/Policies
    chown root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/Policies
    chmod 755 "${sv_RootDirPath}"/usr/local/LabWarden/Policies

    cp -pR "${sv_ThisScriptTempDirPath}/LabWarden/Policies/" "${sv_RootDirPath}"/usr/local/LabWarden/Policies/
    chown -R root:wheel "${sv_RootDirPath}"/usr/local/LabWarden/Policies
    chmod -R 755 "${sv_RootDirPath}"/usr/local/LabWarden/Policies

    if test -f "${sv_ThisScriptTempDirPath}/LabWarden/lib/Trigger"
    then
      cat << EOF > ${sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.Boot.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${LW_sv_LabWardenSignature}.Boot</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/LabWarden/lib/Trigger</string>
		<string>Boot</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
</dict>
</plist>
EOF
      cp ${sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.Boot.plist "${sv_RootDirPath}"/Library/LaunchDaemons/
      chown root:wheel "${sv_RootDirPath}"/Library/LaunchDaemons/${LW_sv_LabWardenSignature}.Boot.plist
      chmod 644 "${sv_RootDirPath}"/Library/LaunchDaemons/${LW_sv_LabWardenSignature}.Boot.plist


      cat << EOF > ${sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.SystemPoll.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${LW_sv_LabWardenSignature}.SystemPoll</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/LabWarden/lib/Poll</string>
		<string>System</string>
	</array>
	<key>StartInterval</key>
	<integer>${LW_iv_SystemPollTriggerSecs}</integer>
</dict>
</plist>
EOF
      cp ${sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.SystemPoll.plist "${sv_RootDirPath}"/Library/LaunchDaemons/
      chown root:wheel "${sv_RootDirPath}"/Library/LaunchDaemons/${LW_sv_LabWardenSignature}.SystemPoll.plist
      chmod 644 "${sv_RootDirPath}"/Library/LaunchDaemons/${LW_sv_LabWardenSignature}.SystemPoll.plist


      cat << EOF > ${sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.LoginWindow.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${LW_sv_LabWardenSignature}.LoginWindow</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/LabWarden/lib/Trigger</string>
		<string>LoginWindow</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>LimitLoadToSessionType</key>
	<string>LoginWindow</string>
</dict>
</plist>
EOF
      cp ${sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.LoginWindow.plist "${sv_RootDirPath}"/Library/LaunchAgents/
      chown root:wheel "${sv_RootDirPath}"/Library/LaunchAgents/${LW_sv_LabWardenSignature}.LoginWindow.plist
      chmod 644 "${sv_RootDirPath}"/Library/LaunchAgents/${LW_sv_LabWardenSignature}.LoginWindow.plist
      
      
      if test -z "${sv_RootDirPath}"
      then
        # Make sure the login hooks are set up - these are responsible for calling the Login & Logout TriggerScripts
        defaults write /private/var/root/Library/Preferences/com.apple.loginwindow LoginHook "/usr/local/LabWarden/lib/LoginHook"
        defaults write /private/var/root/Library/Preferences/com.apple.loginwindow LogoutHook "/usr/local/LabWarden/lib/LogoutHook"
      fi
      # Note, the Trigger handler re-installs the Login and Logout Hooks 

      cat << EOF > ${sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.LoginWindowPoll.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${LW_sv_LabWardenSignature}.LoginWindowPoll</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/LabWarden/lib/Poll</string>
		<string>LoginWindow</string>
	</array>
	<key>LimitLoadToSessionType</key>
	<string>LoginWindow</string>
	<key>StartInterval</key>
	<integer>${LW_iv_LoginWindowPollTriggerSecs}</integer>
</dict>
</plist>
EOF
      cp ${sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.LoginWindowPoll.plist "${sv_RootDirPath}"/Library/LaunchAgents/
      chown root:wheel "${sv_RootDirPath}"/Library/LaunchAgents/${LW_sv_LabWardenSignature}.LoginWindowPoll.plist
      chmod 644 "${sv_RootDirPath}"/Library/LaunchAgents/${LW_sv_LabWardenSignature}.LoginWindowPoll.plist


      cat << EOF > ${sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.UserAtDesktop.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${LW_sv_LabWardenSignature}.UserAtDesktop</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/LabWarden/lib/Trigger</string>
		<string>UserAtDesktop</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>LimitLoadToSessionType</key>
	<string>Aqua</string>
</dict>
</plist>
EOF
      cp ${sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.UserAtDesktop.plist "${sv_RootDirPath}"/Library/LaunchAgents/
      chown root:wheel "${sv_RootDirPath}"/Library/LaunchAgents/${LW_sv_LabWardenSignature}.UserAtDesktop.plist
      chmod 644 "${sv_RootDirPath}"/Library/LaunchAgents/${LW_sv_LabWardenSignature}.UserAtDesktop.plist


      cat << EOF > ${sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.UserPoll.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${LW_sv_LabWardenSignature}.UserPoll</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/LabWarden/lib/Poll</string>
		<string>User</string>
	</array>
	<key>LimitLoadToSessionType</key>
	<string>Aqua</string>
	<key>StartInterval</key>
	<integer>${LW_iv_UserPollTriggerSecs}</integer>
</dict>
</plist>
EOF
      cp ${sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.UserPoll.plist "${sv_RootDirPath}"/Library/LaunchAgents/
      chown root:wheel "${sv_RootDirPath}"/Library/LaunchAgents/${LW_sv_LabWardenSignature}.UserPoll.plist
      chmod 644 "${sv_RootDirPath}"/Library/LaunchAgents/${LW_sv_LabWardenSignature}.UserPoll.plist

    fi

  fi
    
  rm -fR "${sv_ThisScriptTempDirPath}/LabWarden"

  if test -z "${sv_RootDirPath}"
  then
    echo "PLEASE REBOOT."
    echo ""
  fi

fi
