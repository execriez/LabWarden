#!/bin/bash
#
# Short:    Utility script - Build LabWarden installation package
# Author:   Mark J Swift
# Version:  1.0.90
# Modified: 01-Jul-2016
#
# Called as follows:    
#   MakePackage.command
#
# Note, the contents of any directory called "custom" is not included in the package

# ---

sv_LabWardenSignature="com.github.execriez.LabWarden"

sv_LabWardenVersion="1.0.90"

# -- Get some info about this script

# Full source of this script
sv_ThisScriptFilePath="${0}"

# Get dir of this script
sv_ThisScriptDirPath="$(dirname "${sv_ThisScriptFilePath}")"

# Get filename of this script
sv_ThisScriptFileName="$(basename "${sv_ThisScriptFilePath}")"

# Filename without extension
sv_ThisScriptName="$(echo ${sv_ThisScriptFileName} | sed 's|\.[^.]*$||')"

# ---

# Path to payload
sv_PayloadDirPath="$(dirname "${sv_ThisScriptDirPath}")"

# ---

# Create a temporary directory private to this script
sv_ThisScriptTempDirPath="$(mktemp -dq /tmp/${sv_ThisScriptFileName}-XXXXXXXX)"

# ---

sv_PkgScriptDirPath="${sv_ThisScriptTempDirPath}"/PKG-Scripts
mkdir -p "${sv_PkgScriptDirPath}"

sv_PkgResourceDirPath="${sv_ThisScriptTempDirPath}"/PKG-Resources
mkdir -p "${sv_PkgResourceDirPath}"

# ---

# populate the package resource directory
cp -p "${sv_PayloadDirPath}/images/background.jpg" "${sv_PkgResourceDirPath}/"

# ---

# Create the uninstall package

sv_PkgName="LabWarden-Uninstaller"
sv_PkgTitle="Uninstall LabWarden"

# -- Copy the main payload
mkdir -p "${sv_PkgScriptDirPath}/util"
cp -pR "${sv_PayloadDirPath}/util/Uninstall.command" "${sv_PkgScriptDirPath}/util"

# -- create the Welcome text
cat << EOF > "${sv_PkgResourceDirPath}"/Welcome.txt
This package uninstalls LabWarden and any related LabWarden resources.

You will be guided through the steps necessary to uninstall this software.
EOF

# -- create the ReadMe text
cat << EOF > "${sv_PkgResourceDirPath}"/ReadMe.txt
This package deletes the following files an directories (if they exist):

* /Library/LaunchAgents/${sv_LabWardenSignature}.appwarden.plist
* /Library/LaunchAgents/${sv_LabWardenSignature}.LoginWindow.plist
* /Library/LaunchAgents/${sv_LabWardenSignature}.LoginWindowIdle.plist
* /Library/LaunchAgents/${sv_LabWardenSignature}.PostLogin.plist
* /Library/LaunchAgents/${sv_LabWardenSignature}.UserPoll.plist
* /Library/LaunchDaemons/${sv_LabWardenSignature}.Boot.plist
* /Library/LaunchDaemons/${sv_LabWardenSignature}.Escalated.plist
* /usr/LabWarden/

Also, the Login and Logout hooks will be cleared if LabWarden has set them.

A restart is required to complete the un-installation.

EOF

# -- build the postinstall script
cat << 'EOF' > "${sv_PkgScriptDirPath}"/postinstall
#!/bin/bash
"$(dirname "${0}")"/util/Uninstall.command
EOF
chmod o+x,g+x,u+x "${sv_PkgScriptDirPath}"/postinstall

# -- build an empty package
pkgbuild --identifier "${sv_LabWardenSignature}" --version "${sv_LabWardenVersion}" --nopayload "${sv_ThisScriptTempDirPath}"/${sv_PkgName}.pkg --scripts ${sv_PkgScriptDirPath}
      
# -- Synthesise a temporary distribution.plist file --
productbuild --synthesize --package "${sv_ThisScriptTempDirPath}"/${sv_PkgName}.pkg "${sv_ThisScriptTempDirPath}"/synthdist.plist

# -- add options for title, background, licence & readme --
awk '/<\/installer-gui-script>/ && c == 0 {c = 1; print "<title>'"${sv_PkgTitle}"'</title>\n<background file=\"background.jpg\" mime-type=\"image/jpg\" />\n<welcome file=\"Welcome.txt\"/>\n<readme file=\"ReadMe.txt\"/>"}; {print}' "${sv_ThisScriptTempDirPath}"/synthdist.plist > "${sv_ThisScriptTempDirPath}"/distribution.plist

# -- build the final package --
cd "${sv_ThisScriptTempDirPath}"
productbuild --distribution "${sv_ThisScriptTempDirPath}"/distribution.plist --resources "${sv_PkgResourceDirPath}" ~/Desktop/${sv_PkgName}.pkg

# ---

# Create the install package

sv_PkgName="LabWarden"
sv_PkgTitle="LabWarden"

# -- Copy the main payload
cp -pR "${sv_PayloadDirPath}/" "${sv_PkgScriptDirPath}/"

# -- Remove any unwanted files
rm -fR "${sv_PkgScriptDirPath}"/SupportFiles
rm -fR "${sv_PkgScriptDirPath}"/.git
find -d "${sv_PkgScriptDirPath}" -ipath "*/custom/*" -exec rm -fd {} \;
find "${sv_ThisScriptTempDirPath}" -iname .DS_Store -exec rm -f {} \;

# -- Copy the example custom policies
find -d "${sv_PayloadDirPath}/Policies/custom/" -iname "*ExamplePolicy" -exec cp "{}" ${sv_PkgScriptDirPath}/Policies/custom/ \;

# -- Copy the License text

# populate the package resource directory
cp -p "${sv_PayloadDirPath}/LICENSE" "${sv_PkgResourceDirPath}"/License.txt

# -- create the Welcome text
cat << EOF > "${sv_PkgResourceDirPath}"/Welcome.txt
LabWarden ${sv_LabWardenVersion}

LabWarden applies Mac policies to users and workstations.

These policies are controlled via Active Directory without having to extend the AD schema.

Each policy "setting" is determined by a config that is stored directly within an AD groups notes field. Policy "scope" is determined by AD group membership.

Currently, a policy config can be a .mobileconfig file, a .labwarden.plist file or a PolicyBanner.rtf file.

You can read the instructions on-line at https://github.com/execriez/LabWarden/README.md or after installation at /usr/local/LabWarden/README.md

You will be guided through the steps necessary to install this software.
EOF

# -- create the ReadMe text
cat << EOF > "${sv_PkgResourceDirPath}"/ReadMe.txt
This package installs the following files an directories:

* /Library/LaunchAgents/${sv_LabWardenSignature}.appwarden.plist
* /Library/LaunchAgents/${sv_LabWardenSignature}.LoginWindow.plist
* /Library/LaunchAgents/${sv_LabWardenSignature}.LoginWindowIdle.plist
* /Library/LaunchAgents/${sv_LabWardenSignature}.PostLogin.plist
* /Library/LaunchAgents/${sv_LabWardenSignature}.UserPoll.plist
* /Library/LaunchDaemons/${sv_LabWardenSignature}.Boot.plist
* /Library/LaunchDaemons/${sv_LabWardenSignature}.Escalated.plist
* /usr/LabWarden/

You should note that the installer overwrites any existing Login and Logout hooks.

A restart is required to complete the installation.

EOF

# -- build the postinstall script
cat << 'EOF' > "${sv_PkgScriptDirPath}"/postinstall
#!/bin/bash
"$(dirname "${0}")"/util/Install.command
EOF
chmod o+x,g+x,u+x "${sv_PkgScriptDirPath}"/postinstall

# -- build an empty package
pkgbuild --identifier "${sv_LabWardenSignature}" --version "${sv_LabWardenVersion}" --nopayload "${sv_ThisScriptTempDirPath}"/${sv_PkgName}.pkg --scripts ${sv_PkgScriptDirPath}
      
# -- Synthesise a temporary distribution.plist file --
productbuild --synthesize --package "${sv_ThisScriptTempDirPath}"/${sv_PkgName}.pkg "${sv_ThisScriptTempDirPath}"/synthdist.plist

# -- add options for title, background, licence & readme --
awk '/<\/installer-gui-script>/ && c == 0 {c = 1; print "<title>'"${sv_PkgTitle}"'</title>\n<background file=\"background.jpg\" mime-type=\"image/jpg\" />\n<welcome file=\"Welcome.txt\"/>\n<license file=\"License.txt\"/>\n<readme file=\"ReadMe.txt\"/>"}; {print}' "${sv_ThisScriptTempDirPath}"/synthdist.plist > "${sv_ThisScriptTempDirPath}"/distribution.plist

# -- build the final package --
cd "${sv_ThisScriptTempDirPath}"
productbuild --distribution "${sv_ThisScriptTempDirPath}"/distribution.plist --resources "${sv_PkgResourceDirPath}" ~/Desktop/${sv_PkgName}.pkg

# ---

cd "${sv_ThisScriptDirPath}"

srm -fR "${sv_ThisScriptTempDirPath}"
