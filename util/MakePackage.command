#!/bin/bash
#
# Short:    Utility script - Build LabWarden installation package
# Author:   Mark J Swift
# Version:  1.0.82
# Modified: 27-May-2016
#
# Called as follows:    
#   MakePackage.command

# ---

GLB_LabWardenSignature="com.github.execriez.LabWarden"

GLB_LabWardenVersion="1.0.82"

# ---

# Get filename of this script
GLB_ThisScriptName="$(basename "${0}")"

# Path to this script
GLB_ThisScriptPath="$(dirname "${0}")"

# Path to payload
GLB_PayloadDir="$(dirname "${GLB_ThisScriptPath}")"

# ---

# Create a temporary directory private to this script
GLB_ThisScriptTempDir="$(mktemp -dq /tmp/${GLB_ThisScriptName}-XXXXXXXX)"

# ---

# Copy the main payload
GLB_ScriptDir="${GLB_ThisScriptTempDir}"/PKG-Scripts
mkdir -p "${GLB_ScriptDir}"

cp -pR "${GLB_PayloadDir}/" "${GLB_ScriptDir}/"

rm -fR "${GLB_ScriptDir}"/SupportFiles

# Remove any unwanted files
find "${GLB_ThisScriptTempDir}" -iname .DS_Store -exec rm -f {} \;

# populate the package resource directory
GLB_ResourceDir="${GLB_ThisScriptTempDir}"/PKG-Resources
mkdir -p "${GLB_ResourceDir}"

cp -p "${GLB_PayloadDir}/images/background.jpg" "${GLB_ResourceDir}/"

cp -p "${GLB_PayloadDir}/LICENSE" "${GLB_ResourceDir}"/License.txt

# ---

# Create the install package

GLB_PkgName="LabWarden"
GLB_PKGTITLE="LabWarden"

# -- create the Welcome text
cat << EOF > "${GLB_ResourceDir}"/Welcome.txt
LabWarden ${GLB_LabWardenVersion}

LabWarden applies Mac policies to users and workstations.

These policies are controlled via Active Directory without having to extend the AD schema.

Each policy "setting" is determined by a config that is stored directly within an AD groups notes field. Policy "scope" is determined by AD group membership.

Currently, a policy config can be a .mobileconfig file, a .labwarden.plist file or a PolicyBanner.rtf file.

You can read the instructions on-line at https://github.com/execriez/LabWarden/README.md or after installation at /usr/local/LabWarden/README.md

You will be guided through the steps necessary to install this software.
EOF

# -- create the ReadMe text
cat << EOF > "${GLB_ResourceDir}"/ReadMe.txt
This package installs the following files an directories:

* /Library/LaunchAgents/${GLB_LabWardenSignature}.appwarden.plist
* /Library/LaunchAgents/${GLB_LabWardenSignature}.LoginWindow.plist
* /Library/LaunchAgents/${GLB_LabWardenSignature}.LoginWindowIdle.plist
* /Library/LaunchAgents/${GLB_LabWardenSignature}.PostLogin.plist
* /Library/LaunchAgents/${GLB_LabWardenSignature}.UserPoll.plist
* /Library/LaunchDaemons/${GLB_LabWardenSignature}.Boot.plist
* /Library/LaunchDaemons/${GLB_LabWardenSignature}.Escalated.plist
* /usr/LabWarden/

You should note that the installer overwrites any existing Login and Logout hooks.

A restart is required to complete the installation.

EOF

# -- build the postinstall script
cat << 'EOF' > "${GLB_ScriptDir}"/postinstall
#!/bin/bash
"$(dirname "${0}")"/util/Install.command
EOF
chmod o+x,g+x,u+x "${GLB_ScriptDir}"/postinstall

# -- build an empty package
pkgbuild --identifier "${GLB_LabWardenSignature}" --version "${GLB_LabWardenVersion}" --nopayload "${GLB_ThisScriptTempDir}"/${GLB_PkgName}.pkg --scripts ${GLB_ScriptDir}
      
# -- Synthesise a temporary distribution.plist file --
productbuild --synthesize --package "${GLB_ThisScriptTempDir}"/${GLB_PkgName}.pkg "${GLB_ThisScriptTempDir}"/synthdist.plist

# -- add options for title, background, licence & readme --
awk '/<\/installer-gui-script>/ && c == 0 {c = 1; print "<title>'"${GLB_PKGTITLE}"'</title>\n<background file=\"background.jpg\" mime-type=\"image/jpg\" />\n<welcome file=\"Welcome.txt\"/>\n<license file=\"License.txt\"/>\n<readme file=\"ReadMe.txt\"/>"}; {print}' "${GLB_ThisScriptTempDir}"/synthdist.plist > "${GLB_ThisScriptTempDir}"/distribution.plist

# -- build the final package --
cd "${GLB_ThisScriptTempDir}"
productbuild --distribution "${GLB_ThisScriptTempDir}"/distribution.plist --resources "${GLB_ResourceDir}" ~/Desktop/${GLB_PkgName}.pkg

# ---

# Create the uninstall package

GLB_PkgName="LabWarden-Uninstaller"
GLB_PKGTITLE="Uninstall LabWarden"

# -- create the Welcome text
cat << EOF > "${GLB_ResourceDir}"/Welcome.txt
This package uninstalls LabWarden and any related LabWarden resources.

You will be guided through the steps necessary to uninstall this software.
EOF

# -- create the ReadMe text
cat << EOF > "${GLB_ResourceDir}"/ReadMe.txt
This package deletes the following files an directories (if they exist):

* /Library/LaunchAgents/${GLB_LabWardenSignature}.appwarden.plist
* /Library/LaunchAgents/${GLB_LabWardenSignature}.LoginWindow.plist
* /Library/LaunchAgents/${GLB_LabWardenSignature}.LoginWindowIdle.plist
* /Library/LaunchAgents/${GLB_LabWardenSignature}.PostLogin.plist
* /Library/LaunchAgents/${GLB_LabWardenSignature}.UserPoll.plist
* /Library/LaunchDaemons/${GLB_LabWardenSignature}.Boot.plist
* /Library/LaunchDaemons/${GLB_LabWardenSignature}.Escalated.plist
* /usr/LabWarden/

Also, if LabWarden has control of the Login and Logout hooks - these will be cleared.

A restart is required to complete the installation.

EOF

# -- build the postinstall script
cat << 'EOF' > "${GLB_ScriptDir}"/postinstall
#!/bin/bash
"$(dirname "${0}")"/util/Uninstall.command
EOF
chmod o+x,g+x,u+x "${GLB_ScriptDir}"/postinstall

# -- build an empty package
pkgbuild --identifier "${GLB_LabWardenSignature}" --version "${GLB_LabWardenVersion}" --nopayload "${GLB_ThisScriptTempDir}"/${GLB_PkgName}.pkg --scripts ${GLB_ScriptDir}
      
# -- Synthesise a temporary distribution.plist file --
productbuild --synthesize --package "${GLB_ThisScriptTempDir}"/${GLB_PkgName}.pkg "${GLB_ThisScriptTempDir}"/synthdist.plist

# -- add options for title, background, licence & readme --
awk '/<\/installer-gui-script>/ && c == 0 {c = 1; print "<title>'"${GLB_PKGTITLE}"'</title>\n<background file=\"background.jpg\" mime-type=\"image/jpg\" />\n<welcome file=\"Welcome.txt\"/>\n<license file=\"License.txt\"/>\n<readme file=\"ReadMe.txt\"/>"}; {print}' "${GLB_ThisScriptTempDir}"/synthdist.plist > "${GLB_ThisScriptTempDir}"/distribution.plist

# -- build the final package --
cd "${GLB_ThisScriptTempDir}"
productbuild --distribution "${GLB_ThisScriptTempDir}"/distribution.plist --resources "${GLB_ResourceDir}" ~/Desktop/${GLB_PkgName}.pkg

# ---

cd "${GLB_ThisScriptPath}"

rm -fR "${GLB_ThisScriptTempDir}"
