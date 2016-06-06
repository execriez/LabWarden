#!/bin/bash
#
# Short:    Install LabWarden
# Author:   Mark J Swift
# Version:  1.0.84
# Modified: 01-Jun-2016
#
#
#

# ---

# Path to this script
GLB_MyDir="$(dirname "${0}")"

# Change working directory
cd "${GLB_MyDir}"

# Filename of this script
GLB_MyFilename="$(basename "${0}")"

# Filename without extension
GLB_MyName="$(echo ${GLB_MyFilename} | sed 's|\.[^.]*$||')"

# Full souce of this script
GLB_MySource="${0}"

# ---
GLB_ADDomainNameDNS=$(echo "show com.apple.opendirectoryd.ActiveDirectory" | scutil | grep "DomainNameDns" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")

# Initial warning
if test -z "${GLB_ADDomainNameDNS}"
then
  echo >&2 "WARNING: This workstation doesn't appear to be bound to an AD domain"
fi

# ---

# Get user name
GLB_UserName="$(whoami)"

# ---

# Check if user is an admin (returns "true" or "false")
if [ "$(dseditgroup -o checkmember -m "${GLB_UserName}" -n . admin | cut -d" " -f1)" = "yes" ]
then
  GLB_IsAdmin="true"
else
  GLB_IsAdmin="false"
fi

# ---

if [ "${GLB_IsAdmin}" = "false" ]
then
  echo "Sorry, you must be an admin to install this script."
  echo ""

else
  sudo su root <<'HEREDOC'

  # Set the signature for the LabWarden installation
  GLB_LabWardenSignature="com.github.execriez.LabWarden"

  # Path to this script
  GLB_MyDir="$(pwd -P)"
  
  # Get user name
  GLB_UserName="$(whoami)"

  # Path to payload
  GLB_PayloadDir="$(dirname "${GLB_MyDir}")"
  if [ "${GLB_PayloadDir}" = "/usr/local/LabWarden" ]
  then
    echo >&2 "Sorry, cannot install from this folder, copy the folder somewhere else and try again."
    exit 0
  fi

  # Remove old install

  "${GLB_MyDir}/Uninstall.command"

  echo ""
  echo "Installing LabWarden."
  echo "If asked, enter the password for user '"${GLB_UserName}"'"
  echo ""
  
  # Delete any unwanted files from the install
  find "${GLB_PayloadDir}" -iname .DS_Store -exec rm -f {} \;

  # Lets begin
  mkdir -p /usr/local/LabWarden
  chown root:wheel /usr/local/LabWarden
  chmod 755 /usr/local/LabWarden
  
  mkdir -p /Library/Preferences/SystemConfiguration/${GLB_LabWardenSignature}
  chown root:wheel /Library/Preferences/SystemConfiguration/${GLB_LabWardenSignature}
  chmod 755 /Library/Preferences/SystemConfiguration/${GLB_LabWardenSignature}

  if test -f "${GLB_PayloadDir}/LICENSE"
  then
    cp "${GLB_PayloadDir}/LICENSE" /usr/local/LabWarden/
    chown root:wheel "/usr/local/LabWarden/LICENSE"
    chmod 755 "/usr/local/LabWarden/LICENSE"
  fi
  
  if test -f "${GLB_PayloadDir}/README.md"
  then
    cp "${GLB_PayloadDir}/README.md" /usr/local/LabWarden/
    chown root:wheel "/usr/local/LabWarden/README.md"
    chmod 755 "/usr/local/LabWarden/README.md"
  fi
  
  if test -d "${GLB_PayloadDir}/images"
  then
    mkdir -p /usr/local/LabWarden/images
    chown root:wheel /usr/local/LabWarden/images
    chmod 755 /usr/local/LabWarden/images

    cp -pR "${GLB_PayloadDir}/images/" "/usr/local/LabWarden/images/"
    chown -R root:wheel "/usr/local/LabWarden/images"
    chmod -R 755 "/usr/local/LabWarden/images"
  fi

  if test -d "${GLB_PayloadDir}/bin"
  then
    mkdir -p /usr/local/LabWarden/bin
    chown root:wheel /usr/local/LabWarden/bin
    chmod 755 /usr/local/LabWarden/bin

    cp -pR "${GLB_PayloadDir}/bin/" "/usr/local/LabWarden/bin/"
    chown -R root:wheel "/usr/local/LabWarden/bin"
    chmod -R 755 "/usr/local/LabWarden/bin"

    if test -f "${GLB_PayloadDir}/bin/appwarden"
    then
      cat << EOF > /Library/LaunchAgents/${GLB_LabWardenSignature}.appwarden.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${GLB_LabWardenSignature}.appwarden</string>
	<key>Program</key>
	<string>/usr/local/LabWarden/bin/appwarden</string>
	<key>RunAtLoad</key>
	<true/>
	<key>KeepAlive</key>
	<false/>
</dict>
</plist>
EOF
      chown root:wheel /Library/LaunchAgents/${GLB_LabWardenSignature}.appwarden.plist
      chmod 644 /Library/LaunchAgents/${GLB_LabWardenSignature}.appwarden.plist

    fi

    if test -f "${GLB_PayloadDir}/bin/NetworkStateWarden"
    then
      cat << EOF > /Library/LaunchDaemons/${GLB_LabWardenSignature}.NetworkStateWarden.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${GLB_LabWardenSignature}.NetworkStateWarden</string>
	<key>Program</key>
	<string>/usr/local/LabWarden/bin/NetworkStateWarden</string>
	<key>RunAtLoad</key>
	<true/>
	<key>KeepAlive</key>
	<false/>
</dict>
</plist>
EOF
      chown root:wheel /Library/LaunchDaemons/${GLB_LabWardenSignature}.NetworkStateWarden.plist
      chmod 644 /Library/LaunchDaemons/${GLB_LabWardenSignature}.NetworkStateWarden.plist

    fi


  fi
    
  if test -d "${GLB_PayloadDir}/util"
  then
    mkdir -p /usr/local/LabWarden/util
    chown root:wheel /usr/local/LabWarden/util
    chmod 755 /usr/local/LabWarden/util

    cp -pR "${GLB_PayloadDir}/util/" "/usr/local/LabWarden/util/"
    chown -R root:wheel "/usr/local/LabWarden/util"
    chmod -R 755 "/usr/local/LabWarden/util"
  fi
    
  if test -d "${GLB_PayloadDir}/lib"
  then
    mkdir -p /usr/local/LabWarden/lib
    chown root:wheel /usr/local/LabWarden/lib
    chmod 755 /usr/local/LabWarden/lib

    cp -pR "${GLB_PayloadDir}/lib/" "/usr/local/LabWarden/lib/"
    chown -R root:wheel "/usr/local/LabWarden/lib"
    chmod -R 755 "/usr/local/LabWarden/lib"
  fi
    
  if test -d "${GLB_PayloadDir}/PayloadHandlers"
  then
    mkdir -p /usr/local/LabWarden/PayloadHandlers
    chown root:wheel /usr/local/LabWarden/PayloadHandlers
    chmod 755 /usr/local/LabWarden/PayloadHandlers

    cp -pR "${GLB_PayloadDir}/PayloadHandlers/" "/usr/local/LabWarden/PayloadHandlers/"
    chown -R root:wheel "/usr/local/LabWarden/PayloadHandlers"
    chmod -R 755 "/usr/local/LabWarden/PayloadHandlers"
  fi
    
  if test -d "${GLB_PayloadDir}/Policies"
  then
    mkdir -p /usr/local/LabWarden/Policies
    chown root:wheel /usr/local/LabWarden/Policies
    chmod 755 /usr/local/LabWarden/Policies

    cp -pR "${GLB_PayloadDir}/Policies/" "/usr/local/LabWarden/Policies/"
    chown -R root:wheel "/usr/local/LabWarden/Policies"
    chmod -R 755 "/usr/local/LabWarden/Policies"

    if test -f "${GLB_PayloadDir}/lib/Trigger"
    then
      cat << EOF > /tmp/${GLB_LabWardenSignature}.Boot.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${GLB_LabWardenSignature}.Boot</string>
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
      cp /tmp/${GLB_LabWardenSignature}.Boot.plist /library/LaunchDaemons/
      chown root:wheel /library/LaunchDaemons/${GLB_LabWardenSignature}.Boot.plist
      chmod 644 /library/LaunchDaemons/${GLB_LabWardenSignature}.Boot.plist


      cat << EOF > /tmp/${GLB_LabWardenSignature}.LoginWindow.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${GLB_LabWardenSignature}.LoginWindow</string>
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
      cp /tmp/${GLB_LabWardenSignature}.LoginWindow.plist /library/LaunchAgents/
      chown root:wheel /library/LaunchAgents/${GLB_LabWardenSignature}.LoginWindow.plist
      chmod 644 /library/LaunchAgents/${GLB_LabWardenSignature}.LoginWindow.plist
      
      
      # Make sure the login hooks are set up - these are responsible for calling the Login & Logout TriggerScripts
      defaults write /private/var/root/Library/Preferences/com.apple.loginwindow LoginHook "/usr/local/LabWarden/lib/LoginHook"
      defaults write /private/var/root/Library/Preferences/com.apple.loginwindow LogoutHook "/usr/local/LabWarden/lib/LogoutHook"

      # Note, the Trigger handler re-installs the Login and Logout Hooks 


      cat << EOF > /tmp/${GLB_LabWardenSignature}.LoginWindowIdle.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${GLB_LabWardenSignature}.LoginWindowIdle</string>
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
      cp /tmp/${GLB_LabWardenSignature}.LoginWindowIdle.plist /library/LaunchAgents/
      chown root:wheel /library/LaunchAgents/${GLB_LabWardenSignature}.LoginWindowIdle.plist
      chmod 644 /library/LaunchAgents/${GLB_LabWardenSignature}.LoginWindowIdle.plist


      cat << EOF > /tmp/${GLB_LabWardenSignature}.UserAtDesktop.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${GLB_LabWardenSignature}.UserAtDesktop</string>
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
      cp /tmp/${GLB_LabWardenSignature}.UserAtDesktop.plist /library/LaunchAgents/
      chown root:wheel /library/LaunchAgents/${GLB_LabWardenSignature}.UserAtDesktop.plist
      chmod 644 /library/LaunchAgents/${GLB_LabWardenSignature}.UserAtDesktop.plist


      cat << EOF > /tmp/${GLB_LabWardenSignature}.UserPoll.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${GLB_LabWardenSignature}.UserPoll</string>
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
      cp /tmp/${GLB_LabWardenSignature}.UserPoll.plist /library/LaunchAgents/
      chown root:wheel /library/LaunchAgents/${GLB_LabWardenSignature}.UserPoll.plist
      chmod 644 /library/LaunchAgents/${GLB_LabWardenSignature}.UserPoll.plist



      mkdir -p "/usr/local/LabWarden/Escalated"
      chmod 777 "/usr/local/LabWarden/Escalated"
      
      cat << EOF > /tmp/${GLB_LabWardenSignature}.Escalated.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${GLB_LabWardenSignature}.Escalated</string>
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
      cp /tmp/${GLB_LabWardenSignature}.Escalated.plist /library/LaunchDaemons/
      chown root:wheel /library/LaunchDaemons/${GLB_LabWardenSignature}.Escalated.plist
      chmod 644 /library/LaunchDaemons/${GLB_LabWardenSignature}.Escalated.plist


    fi

  fi
    
  echo "PLEASE REBOOT."
  echo ""

HEREDOC

fi
