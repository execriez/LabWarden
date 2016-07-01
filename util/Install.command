#!/bin/bash
#
# Short:    Install LabWarden
# Author:   Mark J Swift
# Version:  1.0.90
# Modified: 01-Jul-2016
#
#
# Called as follows:    
#   Install.command

# ---

# Path to this script
LW_sv_ThisScriptDirPath="$(dirname "${0}")"

# Change working directory
cd "${LW_sv_ThisScriptDirPath}"

# Filename of this script
LW_sv_ThisScriptFileName="$(basename "${0}")"

# Filename without extension
LW_sv_ThisScriptName="$(echo ${LW_sv_ThisScriptFileName} | sed 's|\.[^.]*$||')"

# Full souce of this script
LW_sv_ThisScriptFilePath="${0}"

# ---
LW_sv_ADDomainNameDNS=$(echo "show com.apple.opendirectoryd.ActiveDirectory" | scutil | grep "DomainNameDns" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")

# Initial warning
if test -z "${LW_sv_ADDomainNameDNS}"
then
  echo >&2 "WARNING: This workstation doesn't appear to be bound to an AD domain"
fi

# ---

# Get user name
LW_sv_ThisUserName="$(whoami)"

# ---

# Check if user is an admin (returns "true" or "false")
if [ "$(dseditgroup -o checkmember -m "${LW_sv_ThisUserName}" -n . admin | cut -d" " -f1)" = "yes" ]
then
  LW_bv_ThisUserIsAdmin="true"
else
  LW_bv_ThisUserIsAdmin="false"
fi

# ---

if [ "${LW_bv_ThisUserIsAdmin}" = "false" ]
then
  echo "Sorry, you must be an admin to install this script."
  echo ""

else
  sudo su root <<'HEREDOC'

  # Set the signature for the LabWarden installation
  LW_sv_LabWardenSignature="com.github.execriez.LabWarden"

  # Path to this script
  LW_sv_ThisScriptDirPath="$(pwd -P)"
  
  # Get user name
  LW_sv_ThisUserName="$(whoami)"

  # Path to payload
  sv_PayloadDirPath="$(dirname "${LW_sv_ThisScriptDirPath}")"
  if [ "${sv_PayloadDirPath}" = "/usr/local/LabWarden" ]
  then
    echo >&2 "Sorry, cannot install from this folder, copy the folder somewhere else and try again."
    exit 0
  fi

  echo ""
  echo "Installing LabWarden."
  echo "If asked, enter the password for user '"${LW_sv_ThisUserName}"'"
  echo ""
  
  # Remove old install
  "${LW_sv_ThisScriptDirPath}/Uninstall.command"

  # Create a temporary directory private to this script
  LW_sv_ThisScriptTempDirPath="$(mktemp -dq /tmp/Install-XXXXXXXX)"

  # -- Copy the main payload
  mkdir -p "${LW_sv_ThisScriptTempDirPath}/LabWarden"
  cp -pR "${sv_PayloadDirPath}/" "${LW_sv_ThisScriptTempDirPath}/LabWarden/"

  # -- Remove any unwanted files
  rm -fR "${LW_sv_ThisScriptTempDirPath}/LabWarden/SupportFiles"
  rm -fR "${LW_sv_ThisScriptTempDirPath}/LabWarden/.git"
  find -d "${LW_sv_ThisScriptTempDirPath}/LabWarden" -ipath "*/custom/*" -exec rm -fd {} \;
  find "${LW_sv_ThisScriptTempDirPath}/LabWarden" -iname .DS_Store -exec rm -f {} \;

  # -- Copy the example custom policies
  find -d "${sv_PayloadDirPath}/Policies/custom/" -iname "*ExamplePolicy" -exec cp "{}" ${LW_sv_ThisScriptTempDirPath}/LabWarden/Policies/custom/ \;

  # Lets begin
  mkdir -p /usr/local/LabWarden
  chown root:wheel /usr/local/LabWarden
  chmod 755 /usr/local/LabWarden
  
  mkdir -p /Library/Preferences/SystemConfiguration/${LW_sv_LabWardenSignature}
  chown root:wheel /Library/Preferences/SystemConfiguration/${LW_sv_LabWardenSignature}
  chmod 755 /Library/Preferences/SystemConfiguration/${LW_sv_LabWardenSignature}

  if test -f "${LW_sv_ThisScriptTempDirPath}/LabWarden/LICENSE"
  then
    cp "${LW_sv_ThisScriptTempDirPath}/LabWarden/LICENSE" /usr/local/LabWarden/
    chown root:wheel "/usr/local/LabWarden/LICENSE"
    chmod 755 "/usr/local/LabWarden/LICENSE"
  fi
  
  if test -f "${LW_sv_ThisScriptTempDirPath}/LabWarden/README.md"
  then
    cp "${LW_sv_ThisScriptTempDirPath}/LabWarden/README.md" /usr/local/LabWarden/
    chown root:wheel "/usr/local/LabWarden/README.md"
    chmod 755 "/usr/local/LabWarden/README.md"
  fi
  
  if test -d "${LW_sv_ThisScriptTempDirPath}/LabWarden/images"
  then
    mkdir -p /usr/local/LabWarden/images
    chown root:wheel /usr/local/LabWarden/images
    chmod 755 /usr/local/LabWarden/images

    cp -pR "${LW_sv_ThisScriptTempDirPath}/LabWarden/images/" "/usr/local/LabWarden/images/"
    chown -R root:wheel "/usr/local/LabWarden/images"
    chmod -R 755 "/usr/local/LabWarden/images"
  fi

  if test -d "${LW_sv_ThisScriptTempDirPath}/LabWarden/bin"
  then
    mkdir -p /usr/local/LabWarden/bin
    chown root:wheel /usr/local/LabWarden/bin
    chmod 755 /usr/local/LabWarden/bin

    cp -pR "${LW_sv_ThisScriptTempDirPath}/LabWarden/bin/" "/usr/local/LabWarden/bin/"
    chown -R root:wheel "/usr/local/LabWarden/bin"
    chmod -R 755 "/usr/local/LabWarden/bin"

    mkdir -p /usr/local/LabWarden/bin/custom
    chown root:wheel /usr/local/LabWarden/bin/custom
    chmod 755 /usr/local/LabWarden/bin/custom

    if test -f "${LW_sv_ThisScriptTempDirPath}/LabWarden/bin/appwarden"
    then
      cat << EOF > /Library/LaunchAgents/${LW_sv_LabWardenSignature}.appwarden.plist
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
      chown root:wheel /Library/LaunchAgents/${LW_sv_LabWardenSignature}.appwarden.plist
      chmod 644 /Library/LaunchAgents/${LW_sv_LabWardenSignature}.appwarden.plist

    fi

    if test -f "${LW_sv_ThisScriptTempDirPath}/LabWarden/bin/NetworkStateWarden"
    then
      cat << EOF > /Library/LaunchDaemons/${LW_sv_LabWardenSignature}.NetworkStateWarden.plist
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
      chown root:wheel /Library/LaunchDaemons/${LW_sv_LabWardenSignature}.NetworkStateWarden.plist
      chmod 644 /Library/LaunchDaemons/${LW_sv_LabWardenSignature}.NetworkStateWarden.plist

    fi


  fi
    
  if test -d "${LW_sv_ThisScriptTempDirPath}/LabWarden/util"
  then
    mkdir -p /usr/local/LabWarden/util
    chown root:wheel /usr/local/LabWarden/util
    chmod 755 /usr/local/LabWarden/util

    cp -pR "${LW_sv_ThisScriptTempDirPath}/LabWarden/util/" "/usr/local/LabWarden/util/"
    chown -R root:wheel "/usr/local/LabWarden/util"
    chmod -R 755 "/usr/local/LabWarden/util"
  fi
    
  if test -d "${LW_sv_ThisScriptTempDirPath}/LabWarden/lib"
  then
    mkdir -p /usr/local/LabWarden/lib
    chown root:wheel /usr/local/LabWarden/lib
    chmod 755 /usr/local/LabWarden/lib

    cp -pR "${LW_sv_ThisScriptTempDirPath}/LabWarden/lib/" "/usr/local/LabWarden/lib/"
    chown -R root:wheel "/usr/local/LabWarden/lib"
    chmod -R 755 "/usr/local/LabWarden/lib"
  fi
    
  if test -d "${LW_sv_ThisScriptTempDirPath}/LabWarden/PayloadHandlers"
  then
    mkdir -p /usr/local/LabWarden/PayloadHandlers
    chown root:wheel /usr/local/LabWarden/PayloadHandlers
    chmod 755 /usr/local/LabWarden/PayloadHandlers

    cp -pR "${LW_sv_ThisScriptTempDirPath}/LabWarden/PayloadHandlers/" "/usr/local/LabWarden/PayloadHandlers/"
    chown -R root:wheel "/usr/local/LabWarden/PayloadHandlers"
    chmod -R 755 "/usr/local/LabWarden/PayloadHandlers"
  fi
    
  if test -d "${LW_sv_ThisScriptTempDirPath}/LabWarden/Policies"
  then
    mkdir -p /usr/local/LabWarden/Policies
    chown root:wheel /usr/local/LabWarden/Policies
    chmod 755 /usr/local/LabWarden/Policies

    cp -pR "${LW_sv_ThisScriptTempDirPath}/LabWarden/Policies/" "/usr/local/LabWarden/Policies/"
    chown -R root:wheel "/usr/local/LabWarden/Policies"
    chmod -R 755 "/usr/local/LabWarden/Policies"

    mkdir -p /usr/local/LabWarden/Policies/custom
    chown root:wheel /usr/local/LabWarden/Policies/custom
    chmod 755 /usr/local/LabWarden/Policies/custom

    if test -f "${LW_sv_ThisScriptTempDirPath}/LabWarden/lib/Trigger"
    then
      cat << EOF > ${LW_sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.Boot.plist
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
      cp ${LW_sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.Boot.plist /library/LaunchDaemons/
      chown root:wheel /library/LaunchDaemons/${LW_sv_LabWardenSignature}.Boot.plist
      chmod 644 /library/LaunchDaemons/${LW_sv_LabWardenSignature}.Boot.plist


      cat << EOF > ${LW_sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.LoginWindow.plist
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
      cp ${LW_sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.LoginWindow.plist /library/LaunchAgents/
      chown root:wheel /library/LaunchAgents/${LW_sv_LabWardenSignature}.LoginWindow.plist
      chmod 644 /library/LaunchAgents/${LW_sv_LabWardenSignature}.LoginWindow.plist
      
      
      # Make sure the login hooks are set up - these are responsible for calling the Login & Logout TriggerScripts
      defaults write /private/var/root/Library/Preferences/com.apple.loginwindow LoginHook "/usr/local/LabWarden/lib/LoginHook"
      defaults write /private/var/root/Library/Preferences/com.apple.loginwindow LogoutHook "/usr/local/LabWarden/lib/LogoutHook"

      # Note, the Trigger handler re-installs the Login and Logout Hooks 


      cat << EOF > ${LW_sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.LoginWindowIdle.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${LW_sv_LabWardenSignature}.LoginWindowIdle</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/LabWarden/lib/Trigger</string>
		<string>LoginWindowIdle</string>
	</array>
	<key>LimitLoadToSessionType</key>
	<string>LoginWindow</string>
	<key>StartInterval</key>
	<integer>307</integer>
</dict>
</plist>
EOF
      cp ${LW_sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.LoginWindowIdle.plist /library/LaunchAgents/
      chown root:wheel /library/LaunchAgents/${LW_sv_LabWardenSignature}.LoginWindowIdle.plist
      chmod 644 /library/LaunchAgents/${LW_sv_LabWardenSignature}.LoginWindowIdle.plist


      cat << EOF > ${LW_sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.UserAtDesktop.plist
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
      cp ${LW_sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.UserAtDesktop.plist /library/LaunchAgents/
      chown root:wheel /library/LaunchAgents/${LW_sv_LabWardenSignature}.UserAtDesktop.plist
      chmod 644 /library/LaunchAgents/${LW_sv_LabWardenSignature}.UserAtDesktop.plist


      cat << EOF > ${LW_sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.UserPoll.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${LW_sv_LabWardenSignature}.UserPoll</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/LabWarden/lib/Trigger</string>
		<string>UserPoll</string>
	</array>
	<key>LimitLoadToSessionType</key>
	<string>Aqua</string>
	<key>StartInterval</key>
	<integer>191</integer>
</dict>
</plist>
EOF
      cp ${LW_sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.UserPoll.plist /library/LaunchAgents/
      chown root:wheel /library/LaunchAgents/${LW_sv_LabWardenSignature}.UserPoll.plist
      chmod 644 /library/LaunchAgents/${LW_sv_LabWardenSignature}.UserPoll.plist



      mkdir -p "/usr/local/LabWarden/Escalated"
      chmod 777 "/usr/local/LabWarden/Escalated"
      
      cat << EOF > ${LW_sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.Escalated.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${LW_sv_LabWardenSignature}.Escalated</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/LabWarden/lib/Escalated</string>
	</array>
	<key>WatchPaths</key>
	<array>
		<string>/usr/local/LabWarden/Escalated</string>
	</array>
</dict>
</plist>
EOF
      cp ${LW_sv_ThisScriptTempDirPath}/${LW_sv_LabWardenSignature}.Escalated.plist /library/LaunchDaemons/
      chown root:wheel /library/LaunchDaemons/${LW_sv_LabWardenSignature}.Escalated.plist
      chmod 644 /library/LaunchDaemons/${LW_sv_LabWardenSignature}.Escalated.plist


    fi

  fi
    
  rm -fR "${LW_sv_ThisScriptTempDirPath}/LabWarden"

  echo "PLEASE REBOOT."
  echo ""

HEREDOC

fi
