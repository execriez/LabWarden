#!/bin/bash
#
# Short:    Policy specific routines (shell)
# Author:   Mark J Swift
# Version:  3.3.0
# Modified: 22-May-2022
#
# Should be included into scripts as follows:
#   . /usr/local/LabWarden/inc-sh/PolicyDefs.sh
#
# This include defines some global variables and functions that are used in multiple policy scripts.
# These variables and functions are not used in any core routines or utilities.
#
# Defines the following LabWarden functions:
#
#  GLB_BF_POLICYCONFIGISINSTALLED <PolicyList>      - Returns true if a config is installed for any of the policies in the comma delimited list
#  GLB_BF_MOUNTURIATPATH                            - Mounts a URI at a path, then returns true if the URI mounted OK
#  GLB_SF_RESOLVEFILEURITOPATH <fileuri>            - Resolve a file URI to a local path (downloading the file if necessary)
#
#  Key:
#    GLB_ - LabWarden global variable
#
#    bc_ - string constant with the values 'true' or 'false'
#    ic_ - integer constant
#    sc_ - string constant
#
#    bv_ - string variable with the values 'true' or 'false'
#    iv_ - integer variable
#    sv_ - string variable
#
#    nf_ - null function    (doesn't return a value)
#    bf_ - boolean function (returns string values 'true' or 'false'
#    if_ - integer function (returns an integer value)
#    sf_ - string function  (returns a string value)
  
# ---
  
# Assume that all code is run from a subdirectory of the main project directory
GLB_SV_PROJECTDIRPATH="$(dirname $(dirname ${0}))"

# ---

if [ -z "${GLB_BC_PLCYDEFS_INCLUDED}" ]
then

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

  # ---
  
  # Include the constants library (if it is not already loaded)
  if [ -z "${GLB_BC_CORECONST_INCLUDED}" ]
  then
    . "${GLB_SV_PROJECTDIRPATH}"/inc-sh/CoreConst.sh

    # Exit if something went wrong unexpectedly
    if test -z "${GLB_BC_CORECONST_INCLUDED}"
    then
      echo >&2 "Something unexpected happened - '${0}' COREDEFS"
      exit 90
    fi
  fi

  # By the time we get here, quite a few global variables have been set up.

  # -- Begin Function Definition --
  
  GLB_BF_POLICYCONFIGISINSTALLED() # [PolicyList]
  # Returns 'true' or 'false'
  {
    local sv_PolicyList
    local bv_PolicyIsInstalled
    local sv_PolicyName
    
    sv_PolicyList="${1}"
    
    bv_PolicyIsInstalled=${GLB_BC_FALSE}

      while read sv_PolicyName
      do
        if test -n "$("${GLB_SV_PROJECTDIRPATH}"/bin/ManagedPrefs -list | grep ":${sv_PolicyName}:")"
        then
          bv_PolicyIsInstalled=${GLB_BC_TRUE}
          break
        fi
      done < <(echo ${sv_PolicyList}| tr "," "\n")
    
    echo ${bv_PolicyIsInstalled}
  }

  # Mounts a URI at a path, then returns true if the URI mounted OK.
  # If <fileuri> ends in a / it is assumed to be a dir, otherwise it is assumed to be a file
  # If <fileuri> is already mounted, then nothing will be done unless <checkmountpath> is passed as "true"
  # In this case, <fileuri> will be remounted if not already at <mountpath>
  GLB_BF_MOUNTURIATPATH()   # <fileuri> <mountpath> [<checkmountpath>]
  {
  
    local sv_FileURI
    local sv_DstMountDirPath
    local bv_CheckMountPath
    
    local bv_DidMount
    local sv_RemoteConn
    local sv_RemoteDirPath
    local sv_SrcProtocol
    local sv_SrcFStype
    local sv_SrvrConnHost
    local sv_SrvrConnPass
    local sv_SrvrConnString
    local sv_SrvrConnUser
    local sv_ExistingMountDirPath
      
    sv_FileURI=${1}
    sv_DstMountDirPath=${2}
    
    bv_CheckMountPath=${GLB_BC_FALSE}
    if [ -n "${3}" ]
    then
      if [ "${3}" = "${GLB_BC_TRUE}" ]
      then
        bv_CheckMountPath=${GLB_BC_TRUE}
      fi
    fi
    
    bv_DidMount=${GLB_BC_FALSE}
    
    # Only mount if not already mounted
    if [ -n "$(mount | grep -i " on ${sv_DstMountDirPath}")" ]
    then
      bv_DidMount=${GLB_BC_TRUE}
    
    else

      # Only continue if mount destination directory exists
      if [ -d "${sv_DstMountDirPath}" ]
      then

        # Only continue if mount destination is not a link
        if [ ! -L "${sv_DstMountDirPath}" ]
        then

          sv_SrcProtocol=$(echo ${sv_FileURI} | cut -d ":" -f1)    
     
          case "${sv_SrcProtocol}" in
          smb|afp)
      
            sv_SrcFStype="${sv_SrcProtocol}"
            if [ "${sv_SrcFStype}" = "smb" ]
            then
              sv_SrcFStype="smbfs"
            fi
        
            # Get User, Password & Host
            sv_SrvrConnString="$(echo ${sv_FileURI} | cut -d"/" -f3)"
            sv_SrvrConnHost="$(echo ${sv_SrvrConnString} | cut -sd"@" -f2)"
            if test -z "${sv_SrvrConnHost}"
            then
              sv_SrvrConnHost="${sv_SrvrConnString}"
              sv_SrvrConnUser="${GLB_SV_RUNUSERNAME}"
              sv_SrvrConnPass=""
              if [ "${GLB_SV_RUNUSERNAME}" = "root" ]
              then
                if test -n "${GLB_SV_ADTRUSTACCOUNTNAME}"
                then
                  sv_SrvrConnUser="${GLB_SV_ADTRUSTACCOUNTNAME}"
                  sv_SrvrConnPass="${GLB_SV_ADTRUSTACCOUNTPASSWORD}"   
                fi
              fi   
  
            else
              sv_SrvrConnString="$(echo ${sv_SrvrConnString} | cut -d"@" -f1)"
              sv_SrvrConnPass="$(echo ${sv_SrvrConnString} | cut -sd":" -f2)"
              if test -z "${sv_SrvrConnPass}"
              then
                sv_SrvrConnUser="${sv_SrvrConnString}"
                sv_SrvrConnPass=""
              else
                sv_SrvrConnUser="$(echo ${sv_SrvrConnString} | cut -d":" -f1)" 
              fi
            fi
        
            sv_SrvrConnPass=$(GLB_SF_URLENCODE "${sv_SrvrConnPass}")
            sv_RemoteDirPath="$(echo ${sv_FileURI} | cut -d "/" -f4- | sed "s|/$||")"
        
            if [ -z "$(echo ${sv_FileURI} | grep -E ".*/$")" ]
            then
              sv_RemoteDirPath="$(dirname "${sv_RemoteDirPath}")"
            fi    
      
  	        # Build a connection string
            if test -z "${sv_SrvrConnUser}"
            then
              sv_MountString="//${sv_SrvrConnHost}/${sv_RemoteDirPath}"
              sv_RemoteConn="${sv_SrcProtocol}://${sv_SrvrConnHost}/${sv_RemoteDirPath}"
            else
              sv_MountString="//${sv_SrvrConnUser}@${sv_SrvrConnHost}/${sv_RemoteDirPath}"
              if test -z "${sv_SrvrConnPass}"
              then
                sv_RemoteConn="${sv_SrcProtocol}://${sv_SrvrConnUser}@${sv_SrvrConnHost}/${sv_RemoteDirPath}"
              else
                sv_RemoteConn="${sv_SrcProtocol}://${sv_SrvrConnUser}:${sv_SrvrConnPass}@${sv_SrvrConnHost}/${sv_RemoteDirPath}"
              fi
            fi
        
            # Check if already mounted
            sv_ExistingMountDirPath=$(mount | grep -i "^${sv_MountString} on " | sed -E "s|^(.*) on (.*) (\(.*\)$)|\2|")

            if [ -n "${sv_ExistingMountDirPath}" ]
            then
              if [ "${bv_CheckMountPath}" = "${GLB_BC_TRUE}" ]
              then
                if [ "${sv_ExistingMountDirPath}" != "${sv_DstMountDirPath}" ]
                then
                  # unmount if not mounted where expected
                  GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Unmounting: '${sv_MountString}' from '${sv_ExistingMountDirPath}'"
                  umount "${sv_ExistingMountDirPath}"
                  sv_ExistingMountDirPath=""
                  
                fi
              fi
            fi
            
            if [ -n "${sv_ExistingMountDirPath}" ]
            then
              bv_DidMount=${GLB_BC_TRUE}
              
            else
              if mount -t "${sv_SrcFStype}" "${sv_RemoteConn}" "${sv_DstMountDirPath}"
              then
                bv_DidMount=${GLB_BC_TRUE}
                GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Mount succeeded: mount -t '${sv_SrcFStype}' '${sv_RemoteConn}' '${sv_DstMountDirPath}'"

              else
                GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELERR} "Mount failed: mount -t '${sv_SrcFStype}' '${sv_RemoteConn}' '${sv_DstMountDirPath}'"
                
              fi
            fi
        
          ;;
    
        esac
      
        fi
      
      fi
      
    fi
      
    echo "${bv_DidMount}"
  }

  # Takes a uri, and returns a local filename.
  # Remote files (http, ftp, smb), will be downloaded to a local file.
  # The returned filename may or may not exist
  # This has got quite complex - wish it was simpler
  # - if fileuri ends in a / it is assumed to be a dir, otherwise it is assumed to be a file
  # - if repodirpath is null, then the file will be downloaded to a temporary location
  GLB_SF_RESOLVEFILEURITOPATH()   # fileuri repodirpath
  {
  
    local bv_IsDir
    local sv_DstFilePath
    local sv_ExistingMountDirPath
    local sv_FileURI
    local sv_RepoDirPath
    local sv_Host
    local sv_KUser
    local sv_KprincipalAfter
    local sv_KprincipalBefore
    local sv_RemoteConn
    local sv_RemoteDirPath
    local sv_SrcFileName
    local sv_SrcFileExt
    local sv_DstFileName
    local sv_SrcFilePath
    local sv_SrcFileProtocol
    local sv_SrcMountDirPath
    local sv_SrvrConnHost
    local sv_SrvrConnPass
    local sv_SrvrConnString
    local sv_SrvrConnUser
    local sv_TempDirPath
      
    sv_FileURI=${1}
    sv_RepoDirPath=${2}
    
    sv_SrcFileProtocol=$(echo ${sv_FileURI} | cut -d ":" -f1)    
    sv_SrcFileName="$(basename "${sv_FileURI}")"
    sv_SrcFileExt=$(echo "${sv_SrcFileName}"|awk -F . '{if (NF>1) {print "."$NF}}')
     
    if [ -n "${sv_RepoDirPath}" ]
    then
      sv_TempDirPath="${sv_RepoDirPath}"
    else
      sv_TempDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}"
    fi
    sv_TempDirPath="${sv_TempDirPath}/"$(echo ${sv_FileURI} | openssl dgst -sha256)
  
    #sv_TempDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}/Resolved"
    #sv_TempDirPath="$(mktemp -dq ${GLB_SV_RUNUSERTEMPDIRPATH}/XXXXXXXX)"
    mkdir -p "${sv_TempDirPath}"

    #sv_DstFileName=$(echo ${sv_FileURI} | openssl dgst -sha256)${sv_SrcFileExt}
    sv_DstFileName=${sv_SrcFileName}
    sv_DstFilePath="${sv_TempDirPath}/${sv_DstFileName}"
    
    if test -n "$(echo ${sv_FileURI} | grep -E ".*/$")"
    then
      sv_DstFilePath="${sv_DstFilePath}/"
      bv_IsDir=${GLB_BC_TRUE}
    else
      bv_IsDir=${GLB_BC_FALSE}
    fi

#GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "GLB_SF_RESOLVEFILEURITOPATH sv_DstFilePath ${sv_DstFilePath}"

    # Only continue if the file has not already been resolved
    if ! test -e "${sv_DstFilePath}"
    then

      case "${sv_SrcFileProtocol}" in
      file)
        sv_Host=$(echo "${sv_FileURI}" | cut -d "/" -f3 | tr "[A-Z]" "[a-z]" )
        if [ "${sv_Host}" = "localhost" -o "${sv_Host}" = "" ]
        then
          sv_SrcFilePath="/"$(echo ${sv_FileURI} | cut -d "/" -f4-)
          sv_DstFilePath="$(GLB_SF_ORIGINALFILEPATH "${sv_SrcFilePath}")"
          if test -z "${sv_DstFilePath}"
          then
            sv_DstFilePath="${sv_SrcFilePath}"
          fi
        fi
        ;;
  
      http|ftp)
        curl --http1.1 --fail --max-time 120 --connect-timeout 10 -s -S "${sv_FileURI}" > "${sv_DstFilePath}"
        if ! test -s "${sv_DstFilePath}"
        then
          # if the file is empty, delete it
          rm -f "${sv_DstFilePath}"
        fi
        ;;
  
      https)
        # Use basic AUTH passing computer creds if the URL is local and the user is root
        bv_UseAuth=${GLB_BC_FALSE}
        if test -n "$(echo "${sv_FileURI}" | grep -i '^https:\/\/[^\/]*\.'${GLB_SV_ADDNSDOMAINNAME}'\/')"
        then
          if [ "${GLB_SV_RUNUSERNAME}" = "root" ]
          then
            if test -n "${GLB_SV_ADTRUSTACCOUNTNAME}"
            then
              bv_UseAuth=${GLB_BC_TRUE}
            fi
          fi
        fi 
          
        if [ "${bv_UseAuth}" = ${GLB_BC_FALSE} ]
        then
          curl --http1.1 --fail --max-time 120 --connect-timeout 10 -s -S "${sv_FileURI}" > "${sv_DstFilePath}"
        else
          curl --http1.1 --fail --max-time 120 --connect-timeout 10 -s -S --anyauth --user ${GLB_SV_ADTRUSTACCOUNTNAME}:${GLB_SV_ADTRUSTACCOUNTPASSWORD} "${sv_FileURI}" > "${sv_DstFilePath}"
        fi
        if ! test -s "${sv_DstFilePath}"
        then
          # if the file is empty, delete it
          rm -f "${sv_DstFilePath}"
        fi
        ;;
  
      smb)
        # Get Kerberos principal before the mount
        sv_KprincipalBefore="$(klist 2>/dev/null | grep "Principal:" | head -n1 | cut -d":" -f2 | sed "s|^[ ]*||")"
      
        # Get Kerberos user (if any)
        sv_KUser="$(echo "${sv_KprincipalBefore}" | cut -d"@" -f1)"
  
        # Get User, Password & Host
        sv_SrvrConnString="$(echo ${sv_FileURI} | cut -d"/" -f3)"
        sv_SrvrConnHost="$(echo ${sv_SrvrConnString} | cut -sd"@" -f2)"
        if test -z "${sv_SrvrConnHost}"
        then
          sv_SrvrConnHost="${sv_SrvrConnString}"
          sv_SrvrConnPass=""
          if test -n "${sv_KUser}"
          then
            sv_SrvrConnUser="${sv_KUser}"
          else
            sv_SrvrConnUser="Guest"
          
            if [ "${GLB_SV_RUNUSERNAME}" = "root" ]
            then
              if test -n "${GLB_SV_ADTRUSTACCOUNTNAME}"
              then
                sv_SrvrConnUser="${GLB_SV_ADTRUSTACCOUNTNAME}"
                sv_SrvrConnPass="${GLB_SV_ADTRUSTACCOUNTPASSWORD}"   
              fi
            fi   
  
          fi
        
        else
          sv_SrvrConnString="$(echo ${sv_SrvrConnString} | cut -d"@" -f1)"
          sv_SrvrConnPass="$(echo ${sv_SrvrConnString} | cut -sd":" -f2)"
          if test -z "${sv_SrvrConnPass}"
          then
            sv_SrvrConnUser="${sv_SrvrConnString}"
            sv_SrvrConnPass=""
          else
            sv_SrvrConnUser="$(echo ${sv_SrvrConnString} | cut -d":" -f1)" 
          fi
        fi
        sv_SrvrConnPass=$(GLB_SF_URLENCODE "${sv_SrvrConnPass}")
  
      
        sv_RemoteDirPath="$(echo ${sv_FileURI} | cut -d "/" -f4- | sed "s|/$||")"
        if [ "${bv_IsDir}" = ${GLB_BC_FALSE} ]
        then
          sv_RemoteDirPath="$(dirname "${sv_RemoteDirPath}")"
        fi    
      
        sv_ExistingMountDirPath=$(mount | grep " (smbfs," | grep -i "//${sv_SrvrConnUser}@${sv_SrvrConnHost}/${sv_RemoteDirPath}" | sed -E "s|(.*)(\(smbfs,).*|\1|;s|(.*) on (.*)|\2|;s|[ ]*$||")
  
        if test -n "${sv_ExistingMountDirPath}"
        then
  	      sv_SrcMountDirPath="${sv_ExistingMountDirPath}"
  	  
        else
  	
  	      # Decide where we will mount the remote directory
          sv_SrcMountDirPath="$(mktemp -dq ${GLB_SV_RUNUSERTEMPDIRPATH}/${GLB_SV_THISSCRIPTFILENAME}-Mount-XXXXXXXX)"
          mkdir -p "${sv_SrcMountDirPath}"
  
  	      # Build a connection string
          if test -z "${sv_SrvrConnUser}"
          then
            sv_RemoteConn="//${sv_SrvrConnHost}/${sv_RemoteDirPath}"
          else
            if test -z "${sv_SrvrConnPass}"
            then
              sv_RemoteConn="//${sv_SrvrConnUser}@${sv_SrvrConnHost}/${sv_RemoteDirPath}"
            else
              sv_RemoteConn="//${sv_SrvrConnUser}:${sv_SrvrConnPass}@${sv_SrvrConnHost}/${sv_RemoteDirPath}"
            fi
          fi
        
GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "/sbin/mount_smbfs 2>/dev/null -N "'"'"${sv_RemoteConn}"'" "'"${sv_SrcMountDirPath}"'"'
          /sbin/mount_smbfs -N "${sv_RemoteConn}" "${sv_SrcMountDirPath}"
          sv_Err=$?
          if [ ${sv_Err} -ne 0 ]
          then
            # Mount failed
          
            # Make double sure it's not mounted
            if [ "$(stat -f%Sd "${sv_SrcMountDirPath}")" = "$(stat -f%Sd "/")" ]
            then
              # Only delete it if its empty
              rmdir "${sv_SrcMountDirPath}"
              sv_SrcMountDirPath=""
            fi
          fi    
      
        fi
  
        if test -n "${sv_SrcMountDirPath}"
        then
          # Remote directory is mounted

          if [ "${bv_IsDir}" = ${GLB_BC_FALSE} ]
          then
            # copy file
            if test -e "${sv_SrcMountDirPath}/${sv_SrcFileName}"
            then
GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} 'cp -p "'"${sv_SrcMountDirPath}/${sv_SrcFileName}"'" "'"${sv_DstFilePath}"'"'
              cp -p "${sv_SrcMountDirPath}/${sv_SrcFileName}" "${sv_DstFilePath}"
              sv_Err=$?
              if [ ${sv_Err} -ne 0 ]
              then
                rm -fR "${sv_TempDirPath}"
              fi
            fi
          else
            # copy directory
            mkdir -p "${sv_DstFilePath}"
GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} 'cp -pR "'"${sv_SrcMountDirPath}/"'" "'"${sv_DstFilePath}"'"'
            cp -pR "${sv_SrcMountDirPath}/" "${sv_DstFilePath}"
            sv_Err=$?
            if [ ${sv_Err} -ne 0 ]
            then
              rm -fR "${sv_TempDirPath}"
            fi
          fi
  
        fi
      
        if test -z "${sv_ExistingMountDirPath}"
        then
          if test -n "${sv_SrcMountDirPath}"
          then
            # unmount mount, only if it didnt already exist
            # echo DEBUG /sbin/umount "${sv_SrcMountDirPath}"
            /sbin/umount "${sv_SrcMountDirPath}"
          
            # Make double sure it's not mounted
            if [ "$(stat -f%Sd "${sv_SrcMountDirPath}")" = "$(stat -f%Sd "/")" ]
            then
              # Only delete it if its empty
              rmdir "${sv_SrcMountDirPath}"
            fi
  
          fi
        fi
      
        # Get Kerberos principal after all this kerfuffle
        sv_KprincipalAfter="$(klist 2>/dev/null | grep "Principal:" | head -n1 | cut -d":" -f2 | sed "s|^[ ]*||")"
      
        # If there is a new Kerberos principal - destroy it
        if [ "${sv_KprincipalAfter}" != "${sv_KprincipalBefore}" ]
        then
          kdestroy
        fi
  
        ;;
  
      afp)
        # Currently not supported
        ;;
  
      *)
        # assume that we were passed a path rather than a uri
        sv_SrcFilePath="${sv_FileURI}"
        sv_DstFilePath="$(GLB_SF_ORIGINALFILEPATH "${sv_SrcFilePath}")"
        if test -z "${sv_DstFilePath}"
        then
          sv_DstFilePath="${sv_SrcFilePath}"
        fi
        ;;
  
      esac	    
  
      if test -n "${sv_DstFilePath}"
      then
        # check that file exists
        if ! test -e "${sv_DstFilePath}"
        then
          sv_DstFilePath=""
        fi
      fi
    
    fi
      
    echo "${sv_DstFilePath}"
  }

  # set info lines on loginwindow and remote desktop computerinfo
  GLB_NF_SETLOGINWINDOWLINE() #index text
  {
    local iv_InfoIndex
    local sv_InfoText
    local sv_LoginwindowText
    local iv_LoopCount
    local sv_Text
  
    iv_InfoIndex=${1}
    sv_InfoText="${2}"
  
    if [ "$(GLB_BF_NAMEDLOCKGRAB "LoginwindowText" 10 ${GLB_BC_TRUE})" = ${GLB_BC_TRUE} ]
    then
      sv_LoginwindowText=""
  
      for (( iv_LoopCount=1; iv_LoopCount<=4; iv_LoopCount++ ))
      do
        if [ ${iv_LoopCount} -eq ${iv_InfoIndex} ]
        then
          # Update the RemoteDesktop Computer Info Fields
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Setting remote desktop computerinfo ${iv_InfoIndex} to '${sv_InfoText}'"
          /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -computerinfo -set${iv_InfoIndex} -${iv_InfoIndex} "${sv_InfoText}"

          if [ ${iv_LoopCount} -lt 4 ]
          then
            # Limit the maximum line length to something reasonable
            sv_Text=$(echo "${sv_InfoText}" | cut -c1-64)
          else
            sv_Text=""
          fi

        else
          # Get a line of the Loginwindow text which we dont want to overwrite
          sv_Text=$(echo $(/usr/bin/defaults read /Library/Preferences/com.apple.loginwindow LoginwindowText | tr "\n" ";")";;;" | cut -d";" -f ${iv_LoopCount})

        fi

        sv_LoginwindowText="${sv_LoginwindowText}${sv_Text};"
      done
      sv_LoginwindowText=$(echo "${sv_LoginwindowText}" | sed "s/;$//" | tr ";" "\n")
  
      # Update the Loginwindow Text
      GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Setting login window text line #${iv_InfoIndex} to '${sv_InfoText}'"
      /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText -string "${sv_LoginwindowText}"
      
      GLB_NF_NAMEDLOCKRELEASE "LoginwindowText"
      
    fi
  }

  # Get seconds that mac mouse/keyboard has been idle - ref https://github.com/CLCMacTeam/IdleLogout
  GLB_IF_HIDIdleTime()
  {
    echo $(($(ioreg -c IOHIDSystem | sed -e '/HIDIdleTime/ !{ d' -e 't' -e '}' -e 's/.* = //g' -e 'q') / 1000000000))
  }

  # Get seconds since last idle event
  GLB_IF_SYSTEMIDLESECS()
  {
    local iv_LastIdleFlagEpoch
    local iv_LastIdleSecs
    local iv_IdleSecs
    local iv_NowEpoch
    
    iv_NowEpoch=$(date -u "+%s")
    iv_IdleSecs=$(GLB_IF_HIDIdleTime)

    iv_LastIdleFlagEpoch=$(GLB_NF_NAMEDFLAGMEPOCH "LASTIDLEEVENT")
    if [ ${iv_LastIdleFlagEpoch} -eq 0 ]
    then
      iv_LastIdleFlagEpoch=$((${iv_NowEpoch}-${iv_IdleSecs}))
      GLB_NF_NAMEDFLAGCREATE "LASTIDLEEVENT" ${iv_LastIdleFlagEpoch}
    fi
    iv_LastIdleSecs=$((${iv_NowEpoch}-${iv_LastIdleFlagEpoch}))

    if [ ${iv_LastIdleSecs} -gt ${GLB_IC_FORCEIDLETRIGGERSECS} ]
    then
      # If we have had a long period without idle events, something is wrong.
      # (Maybe the mouse has been placed on top of the keyboard)
      iv_IdleSecs=999999
    fi

    # output result in seconds
    echo ${iv_IdleSecs}
  }
  
  # Get the original file path - resolving any links
  GLB_SF_ORIGINALFILEPATH()   # FilePath
  {
    local sv_Path
    local sv_TruePath
    local sv_PathPart
    
    sv_Path="${1}"
    
    sv_TruePath=""
    while read sv_PathPart
    do
      if test -n "${sv_PathPart}"
      then
        sv_TruePath="${sv_TruePath}/${sv_PathPart}"
        if test -L "${sv_TruePath}"
        then
          sv_TruePath="$(stat -f %Y "${sv_TruePath}")"
        fi
        if test -z "${sv_TruePath}"
        then
          break
        fi
      fi
    done < <(echo ${sv_Path}| tr "/" "\n")
    
    echo "${sv_TruePath}"
  }

  # Schedule event for specified EPOCH time. Identify the event with a unique TAG.
  # WAKETYPE can be one of sleep, wake, poweron, shutdown, wakeorpoweron
  GLB_NF_SCHEDULE4EPOCH()   # TAG WAKETYPE EPOCH
  {
    local iv_SchedEpoch
    local sv_SchedLine
    local iv_NowEpoch
  
    sv_Tag=${1}
    sv_WakeType=${2}
    iv_SchedEpoch=${3}
  
    iv_NowEpoch=$(date -u "+%s")
  
    if [ ${iv_NowEpoch} -lt ${iv_SchedEpoch} ]
    then
      if [ ${GLB_IV_SYSTEMVERSIONSTAMPASNUMBER} -ge 168558592 ]
      then
        sv_Tag="pmset"
        GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Setting the 'owner' in a 'pmset sched' command does not appear to work on MacOS 10.12 and later"

      else
        # Cancel any existing named schedules
        GLB_NF_SCHEDULECANCEL "${sv_Tag}" "${sv_WakeType}"

      fi

      sv_SchedLine=$(date -r ${iv_SchedEpoch} "+%m/%d/%y %H:%M:%S")
      pmset schedule ${sv_WakeType} "${sv_SchedLine}" "${sv_Tag}"

      GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Scheduled ${sv_WakeType} $(date -r ${iv_SchedEpoch} "+%Y%m%d-%H:%M.%S")"
    fi
  }

  # Cancel a scheduled event. Identify the event with a unique TAG and WAKETYPE.
  # WAKETYPE can be one of sleep, wake, poweron, shutdown, wakeorpoweron
  GLB_NF_SCHEDULECANCEL()   # TAG WAKETYPE
  {
    local iv_SchedEpoch
    local sv_SchedLine
  
    sv_Tag=${1}
    sv_WakeType=${2}
  
    # Check there isnt a named schedule already - ignored on 10.12 since owner not set correctly
    pmset -g sched | grep -i "${sv_WakeType}" | grep -i "${sv_Tag}" | tr -s " " | cut -d " " -f5-6 | while read sv_SchedLine
    do
      if [ -n "${sv_SchedLine}" ]
      then
        pmset schedule cancel ${sv_WakeType} "${sv_SchedLine}" "${sv_Tag}" 2>/dev/null
      fi
    done
  }

  # List all scheduled events for specified WAKETYPE.
  # WAKETYPE can be one of sleep, wake, poweron, shutdown, wakeorpoweron
  GLB_IF_GETSCHEDULEDEPOCH()   # WAKETYPE
  {
    local iv_SchedEpoch
    local sv_SchedLine
  
    sv_WakeType=${1}
    
    pmset -g sched | grep -i "${sv_WakeType}" | tr -s " " | cut -d " " -f5-6 | while read sv_SchedLine
    do
      if [ -n "${sv_SchedLine}" ]
      then
        iv_SchedEpoch=$(date -jf "%d/%m/%y %H:%M:%S" "${sv_SchedLine}" "+%s")
      fi
    done
  }
  
  # -- End Function Definition --
  
  # -- Get AD workstation name (the name when it was bound)
  
  # Get Computer AD trust account - i.e. yourcomputername$
  GLB_SV_ADTRUSTACCOUNTNAME="$(dsconfigad 2>/dev/null -show | grep "Computer Account" | sed "s|\([^=]*\)=[ ]*\([^ ]*$\)|\2|")"
  
  # AD computer name (without the trailing dollar sign)
  GLB_SV_ADCOMPUTERNAME=$(echo ${GLB_SV_ADTRUSTACCOUNTNAME} | sed "s|\$$||")
  
  # ---
  
  # Get Computer full AD domain - i.e. yourdomain.yourcompany.com
  GLB_SV_ADDNSDOMAINNAME="$(dsconfigad 2>/dev/null -show | grep "Active Directory Domain" | sed "s|\([^=]*\)=[ ]*\([^ ]*$\)|\2|")"
  
  # ---
  
  # If the workstation is bound to AD, make sure the computer name matches the AD object
  if test -n "${GLB_SV_ADCOMPUTERNAME}"
  then
    if [ "${GLB_SV_HOSTNAME}" != "${GLB_SV_ADCOMPUTERNAME}" ]
    then
      GLB_SV_HOSTNAME="${GLB_SV_ADCOMPUTERNAME}"
      /usr/sbin/systemsetup -setcomputername "${GLB_SV_ADCOMPUTERNAME}"
      /usr/sbin/scutil --set ComputerName "${GLB_SV_ADCOMPUTERNAME}"
      /usr/sbin/systemsetup -setlocalsubnetname "${GLB_SV_ADCOMPUTERNAME}"
      /usr/sbin/scutil --set LocalHostName "${GLB_SV_ADCOMPUTERNAME}"
      /usr/sbin/scutil --set HostName "${GLB_SV_ADCOMPUTERNAME}.${GLB_SV_ADDNSDOMAINNAME}"
    
    fi
  fi
  
  # ---
  
  # Get Computer short AD domain - i.e. YOURDOMAIN
  if test -n "${GLB_SV_ADDNSDOMAINNAME}"
  then
    # If we have just started up, we may need to wait a short time while the system populates the scutil vars
    iv_DelayCount=0
    while [ ${iv_DelayCount} -lt 5 ]
    do
      GLB_SV_ADFLATDOMAINNAME=$(echo "show com.apple.opendirectoryd.ActiveDirectory" | scutil | grep "DomainNameFlat" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
      if test -n "${GLB_SV_ADFLATDOMAINNAME}"
      then
        break
      fi
  
      # we don't want to hog the CPU - so lets sleep a while
      GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Waiting around until the scutil ActiveDirectory vars are populated"
      sleep 1
        
      iv_DelayCount=$((${iv_DelayCount}+1))
    done
  fi
  
  # --
  
  # Get Computer AD trust account password
  if test -n "${GLB_SV_ADTRUSTACCOUNTNAME}"
  then
    GLB_SV_ADTRUSTACCOUNTPASSWORD=$(security find-generic-password -w -s "/Active Directory/${GLB_SV_ADFLATDOMAINNAME}" /Library/Keychains/System.keychain)
  fi
  
  # -- Get Network info
  
  GLB_SV_IPV4PRIMARYSERVICEUUID=$(echo "show State:/Network/Global/IPv4" | scutil | grep "PrimaryService" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  if test -n "${GLB_SV_IPV4PRIMARYSERVICEUUID}"
  then
    # Get DHCP option 15 (domain)
    GLB_SV_IPV4PRIMARYSERVICEDHCPOPTION15=$(echo "show State:/Network/Service/${GLB_SV_IPV4PRIMARYSERVICEUUID}/DHCP" | scutil | grep "Option_15" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||" | sed -E "s/^<data> 0x//;s/00$//" | xxd -r -p)
  
    # Get user defined name - e.g. Wi-Fi
    GLB_SV_IPV4PRIMARYSERVICEINTERFACENAME=$(echo "show Setup:/Network/Service/${GLB_SV_IPV4PRIMARYSERVICEUUID}" | scutil | grep "UserDefinedName" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  
    # Get device name - e.g. en1
    GLB_SV_IPV4PRIMARYSERVICEDEVICENAME=$(echo "show Setup:/Network/Service/${GLB_SV_IPV4PRIMARYSERVICEUUID}/Interface" | scutil | grep "DeviceName" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  
    # Get device hardware - e.g. Airport
    GLB_SV_IPV4PRIMARYSERVICEHARDWARENAME=$(echo "show Setup:/Network/Service/${GLB_SV_IPV4PRIMARYSERVICEUUID}/Interface" | scutil | grep "Hardware" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  fi
  
  # Get the the device name for wireless (eg en1)
  GLB_SV_WIFIINTERFACEDEVICE="$(networksetup -listallhardwareports | tr "\n" ":" | sed "s|^[:]*||;s|::|;|g" | tr ";" "\n" | grep "Wi-Fi" | sed "s|\(.*Device:[ ]*\)\([^:]*\)\(.*\)|\2|" | head -n 1)"
  
  # -- Get Date/Time info

  sv_NowDate=$(date "+%s:%M:%H:%w:%a:%d:%m:%b:%Y")
  
  GLB_IV_EPOCH=$(echo ${sv_NowDate} | cut -d":" -f1)
  GLB_IV_MINUTE=$(echo ${sv_NowDate} | cut -d":" -f2 | sed "s|^0||")
  GLB_IV_HOUR=$(echo ${sv_NowDate} | cut -d":" -f3 | sed "s|^0||")
  GLB_IV_WEEKDAY=$(echo ${sv_NowDate} | cut -d":" -f4)
  GLB_SV_WEEKDAY=$(echo ${sv_NowDate} | cut -d":" -f5)
  GLB_IV_DAY=$(echo ${sv_NowDate} | cut -d":" -f6 | sed "s|^0||")
  GLB_IV_MONTH=$(echo ${sv_NowDate} | cut -d":" -f7 | sed "s|^0||")
  GLB_SV_MONTH=$(echo ${sv_NowDate} | cut -d":" -f8)
  GLB_IV_YEAR=$(echo ${sv_NowDate} | cut -d":" -f9)
  
  sv_YesterdayDate=$(date -v-1d "+%w:%a:%d:%m:%b:%Y")
  
  GLB_IV_YWEEKDAY=$(echo ${sv_YesterdayDate} | cut -d":" -f1)
  GLB_SV_YWEEKDAY=$(echo ${sv_YesterdayDate} | cut -d":" -f2)
  GLB_IV_YDAY=$(echo ${sv_YesterdayDate} | cut -d":" -f3 | sed "s|^0||")
  GLB_IV_YMONTH=$(echo ${sv_YesterdayDate} | cut -d":" -f4 | sed "s|^0||")
  GLB_SV_YMONTH=$(echo ${sv_YesterdayDate} | cut -d":" -f5)
  GLB_IV_YYEAR=$(echo ${sv_YesterdayDate} | cut -d":" -f6)
  
  # ---

  # Support some short-form equivalents for easy definitions within match strings
  GLB_SV_DHCPOPTION15=${GLB_SV_IPV4PRIMARYSERVICEDHCPOPTION15}
  GLB_IV_BUILDVERSION=${GLB_IV_BUILDVERSIONSTAMPASNUMBER}
  GLB_SV_BUILDVERSION=${GLB_SV_BUILDVERSIONSTAMPASSTRING}
  GLB_IV_OS=${GLB_IV_SYSTEMVERSIONSTAMPASNUMBER}
  GLB_SV_OS=${GLB_SV_SYSTEMVERSIONSTAMPASSTRING}
  GLB_SV_MODEL=${GLB_SV_MODELIDENTIFIER}
  
  # ---

  # Support pre version 3.0.2 global expansions
  GLB_COMPUTERNAME=${GLB_SV_HOSTNAME}
  GLB_USERNAME=${GLB_SV_CONSOLEUSERNAME}
  GLB_HOMEPATH=${GLB_SV_CONSOLEUSERHOMEDIRPATH}
  GLB_HOMESHARE=${GLB_SV_CONSOLEUSERSHAREDIRPATH}
  GLB_HOMELOCAL=${GLB_SV_CONSOLEUSERLOCALHOMEDIRPATH}
  GLB_DOMAIN=${GLB_SV_ADFLATDOMAINNAME}
  GLB_FQADDOMAIN=${GLB_SV_ADDNSDOMAINNAME}
  
  # ---
  
  GLB_BC_PLCYDEFS_INCLUDED=${GLB_BC_TRUE}

fi
