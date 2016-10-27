#!/bin/bash
#
# Short:    Utility script - Build LabWarden installation package
# Author:   Mark J Swift
# Version:  1.0.100
# Modified: 27-Oct-2016
#
# Called as follows:    
#   MakePackage.command
#
# Note, the contents of any directory called "custom" is not included in the package

# ---

if_GetPlistArraySize()   # plistfile property - given an array property name, returns the size of the array 
{
  local sv_PlistFilePath
  local sv_PropertyName

  sv_PlistFilePath="${1}"
  sv_PropertyName="${2}"

  /usr/libexec/PlistBuddy 2>/dev/null -c "Print ':${sv_PropertyName}'" "${sv_PlistFilePath}" | grep -E "^ " | grep -E "$(/usr/libexec/PlistBuddy 2>/dev/null -c "Print ':${sv_PropertyName}'" "${sv_PlistFilePath}" | grep -E "^ " | head -n1 | sed "s|\(^[ ]*\)\([^ ]*.*\)|\^\1\\[\^ }\]|")" | wc -l | sed "s|^[ ]*||"
}

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
  echo >&2 "ERROR: You must be an admin to run this script."
  exit 0
fi

# ---

# Path to payload
sv_PayloadDirPath="$(dirname "${sv_ThisScriptDirPath}")"

# ---

if [ "${sv_ThisUserName}" != "root" ]
then
  echo ""
  echo "If asked, enter the password for user '"${sv_ThisUserName}"'"
  echo ""
  sudo "${sv_ThisScriptFilePath}"

else

# Create a temporary directory private to this script
sv_ThisScriptTempDirPath="$(mktemp -dq /tmp/${sv_ThisScriptFileName}-XXXXXXXX)"

# ---

sv_PkgScriptDirPath="${sv_ThisScriptTempDirPath}"/PKG-Scripts
mkdir -p "${sv_PkgScriptDirPath}"

sv_PkgResourceDirPath="${sv_ThisScriptTempDirPath}"/PKG-Resources
mkdir -p "${sv_PkgResourceDirPath}"

sv_PkgRootDirPath="${sv_ThisScriptTempDirPath}"/PKG-Root
mkdir -p "${sv_PkgRootDirPath}"

# ---

# populate the package resource directory
cp -p "${sv_PayloadDirPath}/images/background.jpg" "${sv_PkgResourceDirPath}/"

# ---

# Create the uninstall package

sv_PkgTitle="LabWarden Uninstaller"
sv_PkgID="${LW_sv_LabWardenSignature}.uninstall"
sv_PkgName="LabWarden-Uninstaller"

# -- Copy the uninstaller
cp -p "${sv_PayloadDirPath}/util/Uninstall.command" "${sv_PkgScriptDirPath}/"

# -- build the preinstall script
cat << 'EOF' > "${sv_PkgScriptDirPath}"/preinstall
#!/bin/bash
"$(dirname "${0}")"/Uninstall.command "${2}"
EOF
chmod o+x,g+x,u+x "${sv_PkgScriptDirPath}"/preinstall

# -- create the Welcome text
cat << EOF > "${sv_PkgResourceDirPath}"/Welcome.txt
This package uninstalls LabWarden and any related LabWarden resources.

You will be guided through the steps necessary to uninstall this software.
EOF

# -- create the ReadMe text
cat << EOF > "${sv_PkgResourceDirPath}"/ReadMe.txt
This package deletes the following files an directories (if they exist):

* /Library/LaunchAgents/${LW_sv_LabWardenSignature}.appwarden.plist
* /Library/LaunchAgents/${LW_sv_LabWardenSignature}.LoginWindow.plist
* /Library/LaunchAgents/${LW_sv_LabWardenSignature}.LoginWindowPoll.plist
* /Library/LaunchAgents/${LW_sv_LabWardenSignature}.UserAtDesktop.plist
* /Library/LaunchAgents/${LW_sv_LabWardenSignature}.UserPoll.plist
* /Library/LaunchDaemons/${LW_sv_LabWardenSignature}.Boot.plist
* /Library/LaunchDaemons/${LW_sv_LabWardenSignature}.SystemPoll.plist
* /usr/LabWarden/

Also, the Login and Logout hooks will be cleared if LabWarden has set them.

A restart is required to complete the un-installation.

EOF

# -- build an empty package
pkgbuild --identifier "${sv_PkgID}" --version "${LW_sv_LabWardenVersion}" --nopayload "${sv_ThisScriptTempDirPath}"/${sv_PkgName}.pkg --scripts ${sv_PkgScriptDirPath}
      
# -- Synthesise a temporary distribution.plist file --
productbuild --synthesize --package "${sv_ThisScriptTempDirPath}"/${sv_PkgName}.pkg "${sv_ThisScriptTempDirPath}"/synthdist.plist

# -- add options for title, background, licence & readme --
awk '/<\/installer-gui-script>/ && c == 0 {c = 1; print "<title>'"${sv_PkgTitle}"'</title>\n<background file=\"background.jpg\" mime-type=\"image/jpg\" />\n<welcome file=\"Welcome.txt\"/>\n<readme file=\"ReadMe.txt\"/>"}; {print}' "${sv_ThisScriptTempDirPath}"/synthdist.plist > "${sv_ThisScriptTempDirPath}"/distribution.plist

# -- build the final package --
cd "${sv_ThisScriptTempDirPath}"
productbuild --identifier "${sv_PkgID}" --version "${LW_sv_LabWardenVersion}" --distribution "${sv_ThisScriptTempDirPath}"/distribution.plist --resources "${sv_PkgResourceDirPath}" ~/Desktop/${sv_PkgName}.pkg

# ---

# Create the install package

sv_PkgTitle="LabWarden"
sv_PkgID="${LW_sv_LabWardenSignature}"
sv_PkgName="LabWarden"

# -- Create the main payload
mkdir -p "${sv_PkgRootDirPath}"/Library/LaunchAgents
mkdir -p "${sv_PkgRootDirPath}"/Library/LaunchDaemons

"${sv_ThisScriptDirPath}/install.command" "${sv_PkgRootDirPath}"

# -- Copy the License text

# populate the package resource directory
cp -p "${sv_PayloadDirPath}/LICENSE" "${sv_PkgResourceDirPath}"/License.txt

# -- create the Welcome text
cat << EOF > "${sv_PkgResourceDirPath}"/Welcome.txt
LabWarden ${LW_sv_LabWardenVersion}

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

* /Library/LaunchAgents/${LW_sv_LabWardenSignature}.appwarden.plist
* /Library/LaunchAgents/${LW_sv_LabWardenSignature}.LoginWindow.plist
* /Library/LaunchAgents/${LW_sv_LabWardenSignature}.LoginWindowPoll.plist
* /Library/LaunchAgents/${LW_sv_LabWardenSignature}.UserAtDesktop.plist
* /Library/LaunchAgents/${LW_sv_LabWardenSignature}.UserPoll.plist
* /Library/LaunchDaemons/${LW_sv_LabWardenSignature}.Boot.plist
* /Library/LaunchDaemons/${LW_sv_LabWardenSignature}.SystemPoll.plist
* /usr/LabWarden/

You should note that the software overwrites any existing Login and Logout hooks.

A restart is required to complete the installation.

EOF
# -- build a component plist
pkgbuild --analyze --root ${sv_PkgRootDirPath} "${sv_ThisScriptTempDirPath}"/component.plist

# -- set BundleIsRelocatable to 'false' in the component plist bundles. (We want the install to be put where we say)
iv_BundleCount=$(if_GetPlistArraySize "${sv_ThisScriptTempDirPath}"/component.plist ":")
for (( iv_LoopCount=0; iv_LoopCount<${iv_BundleCount}; iv_LoopCount++ ))
do
  /usr/libexec/PlistBuddy -c "Set ':${iv_LoopCount}:BundleIsRelocatable' 'false'" "${sv_ThisScriptTempDirPath}"/component.plist
done

# -- build a deployment package
pkgbuild --component-plist "${sv_ThisScriptTempDirPath}"/component.plist --root ${sv_PkgRootDirPath} --identifier "${sv_PkgID}" --version "${LW_sv_LabWardenVersion}" --ownership preserve --install-location / "${sv_ThisScriptTempDirPath}"/${sv_PkgName}.pkg --scripts ${sv_PkgScriptDirPath}

# -- Synthesise a temporary distribution.plist file --
productbuild --synthesize --package "${sv_ThisScriptTempDirPath}"/${sv_PkgName}.pkg "${sv_ThisScriptTempDirPath}"/synthdist.plist

# -- add options for title, background, licence & readme --
awk '/<\/installer-gui-script>/ && c == 0 {c = 1; print "<title>'"${sv_PkgTitle}"'</title>\n<background file=\"background.jpg\" mime-type=\"image/jpg\" />\n<welcome file=\"Welcome.txt\"/>\n<license file=\"License.txt\"/>\n<readme file=\"ReadMe.txt\"/>"}; {print}' "${sv_ThisScriptTempDirPath}"/synthdist.plist > "${sv_ThisScriptTempDirPath}"/distribution.plist

# -- build the final package --
cd "${sv_ThisScriptTempDirPath}"
productbuild --identifier "${sv_PkgID}" --version "${LW_sv_LabWardenVersion}" --distribution "${sv_ThisScriptTempDirPath}"/distribution.plist --resources "${sv_PkgResourceDirPath}" ~/Desktop/${sv_PkgName}.pkg

# ---

cd "${sv_ThisScriptDirPath}"

rm -fR "${sv_ThisScriptTempDirPath}"

fi