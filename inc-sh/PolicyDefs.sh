#!/bin/bash
#
# Short:    Policy specific routines (shell)
# Author:   Mark J Swift
# Version:  3.2.5
# Modified: 30-Dec-2020
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

if [ -z "${GLB_BC_PLCY_ISINCLUDED}" ]
then

  # ---
  
  # Include the Common library (if it is not already loaded)
  if [ -z "${GLB_BC_COMM_ISINCLUDED}" ]
  then
    . "${GLB_SV_PROJECTDIRPATH}"/inc-sh/Common.sh

    # Exit if something went wrong unexpectedly
    if [ -z "${GLB_BC_COMM_ISINCLUDED}" ]
    then
      echo >&2 "Something unexpected happened"
      exit 90
    fi
  fi

  # By the time we get here, quite a few global variables have been set up.
  # Look at 'inc/Common.sh' for a complete list.

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
  
      http|https|ftp)
        curl --max-time 120 --connect-timeout 10 -s -S "${sv_FileURI}" > "$sv_DstFilePath"
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

  # -- End Function Definition --
  
  # ---
  
  GLB_BC_PLCY_ISINCLUDED=${GLB_BC_TRUE}

fi
