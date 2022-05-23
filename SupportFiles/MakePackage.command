#!/bin/bash
#
# Short:    Utility script - Build installation package
# Author:   Mark J Swift
# Version:  3.3.0
# Modified: 22-May-2022
#
# Called as follows:    
#   MakePackage.command
#
# Requires
#  GLB_BC_FALSE
#  GLB_BV_RUNUSERISADMIN
#  GLB_IC_MSGLEVELERR
#  GLB_NF_LOGMESSAGE
#  GLB_SC_PROJECTNAME
#  GLB_SC_PROJECTSIGNATURE
#  GLB_SC_PROJECTVERSION
#  GLB_SV_PROJECTDIRPATH
#  GLB_SV_RUNUSERNAME
#  GLB_SV_THISSCRIPTDIRPATH
#  GLB_SV_THISSCRIPTFILEPATH
#  GLB_SV_THISSCRIPTTEMPDIRPATH
#
#  GLB_IF_GETPLISTARRAYSIZE


# ---
  
# Assume that all code is run from a subdirectory of the main project directory
GLB_SV_PROJECTDIRPATH="$(dirname $(dirname ${0}))"

# ---

GLB_SV_UTILITYCODEVERSION="3.3.0"

# ---

# Include the Base Defs library (if it is not already loaded)
if [ -z "${GLB_BC_BASEDEFS_INCLUDED}" ]
then
  . "${GLB_SV_PROJECTDIRPATH}"/inc-sh/BaseDefs.sh

  # Exit if something went wrong unexpectedly
  if [ -z "${GLB_BC_BASEDEFS_INCLUDED}" ]
  then
    echo >&2 "Something unexpected happened - '${0}' BASEDEFS"
    exit 90
  fi
fi

# By the time we get here, quite a few global variables have been set up.

# ---

if [ "${GLB_BV_RUNUSERISADMIN}" = ${GLB_BC_FALSE} ]
then
  GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELERR} "Unable to run; you must be an admin to run this software"
  exit 91
fi

# ---

# Where we should install
sv_RootDirPath="${1}"

# ---

if [ "${GLB_SV_RUNUSERNAME}" != "root" ]
then
  echo ""
  echo "If asked, enter the password for user '"${GLB_SV_RUNUSERNAME}"'"
  echo ""
  sudo "${GLB_SV_THISSCRIPTFILEPATH}" "${sv_RootDirPath}"

else

  # Create a temporary directory private to this script
  #GLB_SV_THISSCRIPTTEMPDIRPATH="$(mktemp -dq /tmp/${sv_ThisScriptFileName}-XXXXXXXX)"

  # ---

  sv_PkgScriptDirPath="${GLB_SV_THISSCRIPTTEMPDIRPATH}"/PKG-Scripts
  mkdir -p "${sv_PkgScriptDirPath}"

  sv_PkgResourceDirPath="${GLB_SV_THISSCRIPTTEMPDIRPATH}"/PKG-Resources
  mkdir -p "${sv_PkgResourceDirPath}"

  sv_PkgRootDirPath="${GLB_SV_THISSCRIPTTEMPDIRPATH}"/PKG-Root
  mkdir -p "${sv_PkgRootDirPath}"

  # ---

  # populate the package resource directory
  cp -p "${GLB_SV_PROJECTDIRPATH}/"images/background.jpg "${sv_PkgResourceDirPath}/"

  # ---

  # Create the uninstall package

  sv_PkgTitle="${GLB_SC_PROJECTNAME} Uninstaller"
  sv_PkgID="${GLB_SC_PROJECTSIGNATURE}.uninstall"
  sv_PkgName="${GLB_SC_PROJECTNAME}-Uninstaller"

  # -- Copy the uninstaller
  mkdir -p "${sv_PkgScriptDirPath}/inc-sh"
  mkdir -p "${sv_PkgScriptDirPath}/bin"

  cp -p "${GLB_SV_PROJECTDIRPATH}"/inc-sh/BaseConst.sh "${sv_PkgScriptDirPath}/inc-sh/"
  cp -p "${GLB_SV_PROJECTDIRPATH}"/inc-sh/BaseDefs.sh "${sv_PkgScriptDirPath}/inc-sh/"
  cp -p "${GLB_SV_PROJECTDIRPATH}"/bin/Uninstall "${sv_PkgScriptDirPath}/bin/"

  # -- build the preinstall script
  cat << 'EOF' > "${sv_PkgScriptDirPath}"/preinstall
#!/bin/bash
"$(dirname "${0}")"/bin/Uninstall "${2}"
EOF
  chmod o+x,g+x,u+x "${sv_PkgScriptDirPath}"/preinstall

  # -- create the Welcome text
  cat << EOF > "${sv_PkgResourceDirPath}"/Welcome.txt
This package uninstalls ${GLB_SC_PROJECTNAME} and its related resources.

You will be guided through the steps necessary to uninstall this software.
EOF

  # -- create the ReadMe text
  cp -p "${GLB_SV_PROJECTDIRPATH}"/readme/Uninstall.txt "${sv_PkgResourceDirPath}"/ReadMe.txt

  # -- build an empty package
  pkgbuild --identifier "${sv_PkgID}" --version "${GLB_SC_PROJECTVERSION}" --nopayload "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/${sv_PkgName}.pkg --scripts ${sv_PkgScriptDirPath}
      
  # -- Synthesise a temporary distribution.plist file --
  productbuild --synthesize --package "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/${sv_PkgName}.pkg "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/synthdist.plist

  # -- add options for title, background, licence & readme --
  awk '/<\/installer-gui-script>/ && c == 0 {c = 1; print "<title>'"${sv_PkgTitle}"'</title>\n<background file=\"background.jpg\" mime-type=\"image/jpg\" />\n<welcome file=\"Welcome.txt\"/>\n<readme file=\"ReadMe.txt\"/>"}; {print}' "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/synthdist.plist > "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/distribution.plist

  # -- build the final package --
  cd "${GLB_SV_THISSCRIPTTEMPDIRPATH}"
  productbuild --identifier "${sv_PkgID}" --version "${GLB_SC_PROJECTVERSION}" --distribution "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/distribution.plist --resources "${sv_PkgResourceDirPath}" ~/Desktop/${sv_PkgName}.pkg

  # ---

  # Create the install package

  sv_PkgTitle="${GLB_SC_PROJECTNAME}"
  sv_PkgID="${GLB_SC_PROJECTSIGNATURE}"
  sv_PkgName="${GLB_SC_PROJECTNAME}"

  # -- Create the main payload
  mkdir -p "${sv_PkgRootDirPath}"/Library/LaunchAgents
  mkdir -p "${sv_PkgRootDirPath}"/Library/LaunchDaemons
  mkdir -p "${sv_PkgRootDirPath}"/usr/local

  "${GLB_SV_PROJECTDIRPATH}"/bin/Install "${sv_PkgRootDirPath}"

  # -- Copy the License text

  # populate the package resource directory
  cp -p "${GLB_SV_PROJECTDIRPATH}"/LICENSE "${sv_PkgResourceDirPath}"/License.txt

  # -- create the Welcome text
  cat << EOF > "${sv_PkgResourceDirPath}"/Welcome.txt
${GLB_SC_PROJECTNAME} ${GLB_SC_PROJECTVERSION}

This package installs ${GLB_SC_PROJECTNAME} and its related resources.

You can read the instructions on-line at https://github.com/execriez/${GLB_SC_PROJECTNAME}/README.md or after installation at /usr/local/${GLB_SC_PROJECTNAME}/README.md

You will be guided through the steps necessary to install this software.
EOF

  # -- create the ReadMe text
  cp -p "${GLB_SV_PROJECTDIRPATH}"/readme/Install.txt "${sv_PkgResourceDirPath}"/ReadMe.txt

  # -- Copy required utils
  mkdir -p "${sv_PkgScriptDirPath}/inc-sh"
  mkdir -p "${sv_PkgScriptDirPath}/bin"

  cp -p "${GLB_SV_PROJECTDIRPATH}"/inc-sh/BaseConst.sh "${sv_PkgScriptDirPath}/inc-sh/"
  cp -p "${GLB_SV_PROJECTDIRPATH}"/inc-sh/BaseDefs.sh "${sv_PkgScriptDirPath}/inc-sh/"
  cp -p "${GLB_SV_PROJECTDIRPATH}"/bin/PreInstall "${sv_PkgScriptDirPath}/bin/"
  cp -p "${GLB_SV_PROJECTDIRPATH}"/bin/PostInstall "${sv_PkgScriptDirPath}/bin/"
  cp -p "${GLB_SV_PROJECTDIRPATH}"/bin/Uninstall "${sv_PkgScriptDirPath}/bin/"

  # -- build the preinstall script
  cat << 'EOF' > "${sv_PkgScriptDirPath}"/preinstall
#!/bin/bash
"$(dirname "${0}")"/bin/PreInstall "${2}"
EOF
  chmod o+x,g+x,u+x "${sv_PkgScriptDirPath}"/preinstall

  # -- build the postinstall script
  cat << 'EOF' > "${sv_PkgScriptDirPath}"/postinstall
#!/bin/bash
"$(dirname "${0}")"/bin/PostInstall "${2}"
EOF
  chmod o+x,g+x,u+x "${sv_PkgScriptDirPath}"/postinstall

  # -- build a component plist
  pkgbuild --analyze --root ${sv_PkgRootDirPath} "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/component.plist

  # -- set BundleIsRelocatable to 'false' in the component plist bundles. (We want the install to be put where we say)
  iv_BundleCount=$(GLB_IF_GETPLISTARRAYSIZE "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/component.plist ":")
  for (( iv_LoopCount=0; iv_LoopCount<${iv_BundleCount}; iv_LoopCount++ ))
  do
    /usr/libexec/PlistBuddy -c "Set ':${iv_LoopCount}:BundleIsRelocatable' 'false'" "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/component.plist
  done

  # -- build a deployment package
  pkgbuild --component-plist "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/component.plist --root ${sv_PkgRootDirPath} --identifier "${sv_PkgID}" --version "${GLB_SC_PROJECTVERSION}" --ownership preserve --install-location / "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/${sv_PkgName}.pkg --scripts ${sv_PkgScriptDirPath}

  # -- Synthesise a temporary distribution.plist file --
  productbuild --synthesize --package "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/${sv_PkgName}.pkg "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/distribution.plist

  # -- add options for title, background, licence & readme --
  awk '/<\/installer-gui-script>/ && c == 0 {c = 1; print "<title>'"${sv_PkgTitle}"'</title>\n<background file=\"background.jpg\" mime-type=\"image/jpg\" />\n<welcome file=\"Welcome.txt\"/>\n<license file=\"License.txt\"/>\n<readme file=\"ReadMe.txt\"/>"}; {print}' "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/distribution.plist > "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/distribution1.plist
  cp -pf "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/distribution1.plist "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/distribution.plist
  
  # -- add options for Title and Description to the pkginfo
  cat "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/distribution.plist | sed 's|<choice id="'${sv_PkgID}'" visible=${GLB_BC_FALSE}>|<choice id="'${sv_PkgID}'" visible=${GLB_BC_FALSE} title="'${sv_PkgName}'-'${GLB_SC_PROJECTVERSION}'" description="'${sv_PkgTitle}'">|' > "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/distribution1.plist
  cp -pf "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/distribution1.plist "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/distribution.plist

  # -- build the final package --
  cd "${GLB_SV_THISSCRIPTTEMPDIRPATH}"
  productbuild --identifier "${sv_PkgID}" --version "${GLB_SC_PROJECTVERSION}" --distribution "${GLB_SV_THISSCRIPTTEMPDIRPATH}"/distribution.plist --resources "${sv_PkgResourceDirPath}" ~/Desktop/${sv_PkgName}.pkg

  # ---

  cd "${GLB_SV_THISSCRIPTDIRPATH}"

fi

cd "${GLB_SV_PROJECTDIRPATH}"
rm -fR "${GLB_SV_THISSCRIPTTEMPDIRPATH}"
