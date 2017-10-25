#!/bin/bash
#
# Short:    Utility script - Build installation package
# Author:   Mark J Swift
# Version:  2.0.19
# Modified: 22-Oct-2017
#
# Called as follows:    
#   MakePackage.command
#

# ---

sv_CodeVersion="2.0.19"

# ---

# assume that all scripts are in a subdirectory off the main project directory
GLB_sv_ProjectDirPath="$(dirname $(dirname ${0}))"

# Include the CommonLib
. "${GLB_sv_ProjectDirPath}/inc/Common.sh"

# Exit if something went wrong unexpectedly
if test -z "${GLB_sv_ProjectName}"
then
  exit 90
fi

# ---

if [ "${GLB_bv_ThisUserIsAdmin}" = "false" ]
then
  GLB_nf_logmessage ${GLB_iv_MsgLevelErr} "Unable to run; you must be an admin to run this software"
  exit 91
fi

# ---

# Where we should install
sv_RootDirPath="${1}"

# ---

if [ "${GLB_sv_ThisUserName}" != "root" ]
then
  echo ""
  echo "If asked, enter the password for user '"${GLB_sv_ThisUserName}"'"
  echo ""
  sudo "${GLB_sv_ThisScriptFilePath}" "${sv_RootDirPath}"

else

  # Create a temporary directory private to this script
  #GLB_sv_ThisScriptTempDirPath="$(mktemp -dq /tmp/${sv_ThisScriptFileName}-XXXXXXXX)"

  # ---

  sv_PkgScriptDirPath="${GLB_sv_ThisScriptTempDirPath}"/PKG-Scripts
  mkdir -p "${sv_PkgScriptDirPath}"

  sv_PkgResourceDirPath="${GLB_sv_ThisScriptTempDirPath}"/PKG-Resources
  mkdir -p "${sv_PkgResourceDirPath}"

  sv_PkgRootDirPath="${GLB_sv_ThisScriptTempDirPath}"/PKG-Root
  mkdir -p "${sv_PkgRootDirPath}"

  # ---

  # populate the package resource directory
  cp -p "${GLB_sv_ProjectDirPath}/images/background.jpg" "${sv_PkgResourceDirPath}/"

  # ---

  # Create the uninstall package

  sv_PkgTitle="${GLB_sv_ProjectName} Uninstaller"
  sv_PkgID="${GLB_sv_ProjectSignature}.uninstall"
  sv_PkgName="${GLB_sv_ProjectName}-Uninstaller"

  # -- Copy the uninstaller
  mkdir -p "${sv_PkgScriptDirPath}/inc"
  mkdir -p "${sv_PkgScriptDirPath}/lib"
  mkdir -p "${sv_PkgScriptDirPath}/util"

  cp -p "${GLB_sv_ProjectDirPath}/inc/Common.sh" "${sv_PkgScriptDirPath}/inc/"
  cp -p "${GLB_sv_ProjectDirPath}/inc/Constants.sh" "${sv_PkgScriptDirPath}/inc/"
  cp -p "${GLB_sv_ProjectDirPath}/util/Uninstall" "${sv_PkgScriptDirPath}/util/"

  # -- build the preinstall script
  cat << 'EOF' > "${sv_PkgScriptDirPath}"/preinstall
#!/bin/bash
"$(dirname "${0}")"/util/Uninstall "${2}"
EOF
  chmod o+x,g+x,u+x "${sv_PkgScriptDirPath}"/preinstall

  # -- create the Welcome text
  cat << EOF > "${sv_PkgResourceDirPath}"/Welcome.txt
This package uninstalls ${GLB_sv_ProjectName} and its related resources.

You will be guided through the steps necessary to uninstall this software.
EOF

  # -- create the ReadMe text
  cp -p "${GLB_sv_ProjectDirPath}/readme/Uninstall.txt" "${sv_PkgResourceDirPath}"/ReadMe.txt

  # -- build an empty package
  pkgbuild --identifier "${sv_PkgID}" --version "${GLB_sv_ProjectVersion}" --nopayload "${GLB_sv_ThisScriptTempDirPath}"/${sv_PkgName}.pkg --scripts ${sv_PkgScriptDirPath}
      
  # -- Synthesise a temporary distribution.plist file --
  productbuild --synthesize --package "${GLB_sv_ThisScriptTempDirPath}"/${sv_PkgName}.pkg "${GLB_sv_ThisScriptTempDirPath}"/synthdist.plist

  # -- add options for title, background, licence & readme --
  awk '/<\/installer-gui-script>/ && c == 0 {c = 1; print "<title>'"${sv_PkgTitle}"'</title>\n<background file=\"background.jpg\" mime-type=\"image/jpg\" />\n<welcome file=\"Welcome.txt\"/>\n<readme file=\"ReadMe.txt\"/>"}; {print}' "${GLB_sv_ThisScriptTempDirPath}"/synthdist.plist > "${GLB_sv_ThisScriptTempDirPath}"/distribution.plist

  # -- build the final package --
  cd "${GLB_sv_ThisScriptTempDirPath}"
  productbuild --identifier "${sv_PkgID}" --version "${GLB_sv_ProjectVersion}" --distribution "${GLB_sv_ThisScriptTempDirPath}"/distribution.plist --resources "${sv_PkgResourceDirPath}" ~/Desktop/${sv_PkgName}.pkg

  # ---

  # Create the install package

  sv_PkgTitle="${GLB_sv_ProjectName}"
  sv_PkgID="${GLB_sv_ProjectSignature}"
  sv_PkgName="${GLB_sv_ProjectName}"

  # -- Create the main payload
  mkdir -p "${sv_PkgRootDirPath}"/Library/LaunchAgents
  mkdir -p "${sv_PkgRootDirPath}"/Library/LaunchDaemons
  mkdir -p "${sv_PkgRootDirPath}"/usr/local

  "${GLB_sv_ProjectDirPath}/util/Install" "${sv_PkgRootDirPath}"

  # -- Copy the License text

  # populate the package resource directory
  cp -p "${GLB_sv_ProjectDirPath}/LICENSE" "${sv_PkgResourceDirPath}"/License.txt

  # -- create the Welcome text
  cat << EOF > "${sv_PkgResourceDirPath}"/Welcome.txt
${GLB_sv_ProjectName} ${GLB_sv_ProjectVersion}

This package installs ${GLB_sv_ProjectName} and its related resources.

You can read the instructions on-line at https://github.com/execriez/${GLB_sv_ProjectName}/README.md or after installation at /usr/local/${GLB_sv_ProjectName}/README.md

You will be guided through the steps necessary to install this software.
EOF

  # -- create the ReadMe text
  cp -p "${GLB_sv_ProjectDirPath}/readme/Install.txt" "${sv_PkgResourceDirPath}"/ReadMe.txt

  # -- Copy required utils
  mkdir -p "${sv_PkgScriptDirPath}/inc"
  mkdir -p "${sv_PkgScriptDirPath}/lib"
  mkdir -p "${sv_PkgScriptDirPath}/util"

  cp -p "${GLB_sv_ProjectDirPath}/inc/Common.sh" "${sv_PkgScriptDirPath}/inc/"
  cp -p "${GLB_sv_ProjectDirPath}/inc/Constants.sh" "${sv_PkgScriptDirPath}/inc/"
  cp -p "${GLB_sv_ProjectDirPath}/lib/PreInstall" "${sv_PkgScriptDirPath}/lib/"
  cp -p "${GLB_sv_ProjectDirPath}/lib/PostInstall" "${sv_PkgScriptDirPath}/lib/"
  cp -p "${GLB_sv_ProjectDirPath}/util/Uninstall" "${sv_PkgScriptDirPath}/util/"

  # -- build the preinstall script
  cat << 'EOF' > "${sv_PkgScriptDirPath}"/preinstall
#!/bin/bash
"$(dirname "${0}")"/lib/PreInstall "${2}"
EOF
  chmod o+x,g+x,u+x "${sv_PkgScriptDirPath}"/preinstall

  # -- build the postinstall script
  cat << 'EOF' > "${sv_PkgScriptDirPath}"/postinstall
#!/bin/bash
"$(dirname "${0}")"/lib/PostInstall "${2}"
EOF
  chmod o+x,g+x,u+x "${sv_PkgScriptDirPath}"/postinstall

  # -- build a component plist
  pkgbuild --analyze --root ${sv_PkgRootDirPath} "${GLB_sv_ThisScriptTempDirPath}"/component.plist

  # -- set BundleIsRelocatable to 'false' in the component plist bundles. (We want the install to be put where we say)
  iv_BundleCount=$(GLB_if_GetPlistArraySize "${GLB_sv_ThisScriptTempDirPath}"/component.plist ":")
  for (( iv_LoopCount=0; iv_LoopCount<${iv_BundleCount}; iv_LoopCount++ ))
  do
    /usr/libexec/PlistBuddy -c "Set ':${iv_LoopCount}:BundleIsRelocatable' 'false'" "${GLB_sv_ThisScriptTempDirPath}"/component.plist
  done

  # -- build a deployment package
  pkgbuild --component-plist "${GLB_sv_ThisScriptTempDirPath}"/component.plist --root ${sv_PkgRootDirPath} --identifier "${sv_PkgID}" --version "${GLB_sv_ProjectVersion}" --ownership preserve --install-location / "${GLB_sv_ThisScriptTempDirPath}"/${sv_PkgName}.pkg --scripts ${sv_PkgScriptDirPath}

  # -- Synthesise a temporary distribution.plist file --
  productbuild --synthesize --package "${GLB_sv_ThisScriptTempDirPath}"/${sv_PkgName}.pkg "${GLB_sv_ThisScriptTempDirPath}"/distribution.plist

  # -- add options for title, background, licence & readme --
  awk '/<\/installer-gui-script>/ && c == 0 {c = 1; print "<title>'"${sv_PkgTitle}"'</title>\n<background file=\"background.jpg\" mime-type=\"image/jpg\" />\n<welcome file=\"Welcome.txt\"/>\n<license file=\"License.txt\"/>\n<readme file=\"ReadMe.txt\"/>"}; {print}' "${GLB_sv_ThisScriptTempDirPath}"/distribution.plist > "${GLB_sv_ThisScriptTempDirPath}"/distribution1.plist
  cp -pf "${GLB_sv_ThisScriptTempDirPath}"/distribution1.plist "${GLB_sv_ThisScriptTempDirPath}"/distribution.plist
  
  # -- add options for Title and Description to the pkginfo
  cat "${GLB_sv_ThisScriptTempDirPath}"/distribution.plist | sed 's|<choice id="'${sv_PkgID}'" visible="false">|<choice id="'${sv_PkgID}'" visible="false" title="'${sv_PkgName}'-'${GLB_sv_ProjectVersion}'" description="'${sv_PkgTitle}'">|' > "${GLB_sv_ThisScriptTempDirPath}"/distribution1.plist
  cp -pf "${GLB_sv_ThisScriptTempDirPath}"/distribution1.plist "${GLB_sv_ThisScriptTempDirPath}"/distribution.plist

  # -- build the final package --
  cd "${GLB_sv_ThisScriptTempDirPath}"
  productbuild --identifier "${sv_PkgID}" --version "${GLB_sv_ProjectVersion}" --distribution "${GLB_sv_ThisScriptTempDirPath}"/distribution.plist --resources "${sv_PkgResourceDirPath}" ~/Desktop/${sv_PkgName}.pkg

  # ---

  cd "${GLB_sv_ThisScriptDirPath}"

fi

rm -fR "${GLB_sv_ThisScriptTempDirPath}"
