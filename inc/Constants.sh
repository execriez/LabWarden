#!/bin/bash
#
# Short:    Constants (shell)
# Author:   Mark J Swift
# Version:  2.0.17
# Modified: 28-Sep-2017
#
# Should be included into scripts as follows:
#   . /usr/local/LabWarden/inc/Constants.sh
#

# Only run the code if it hasn't already been run
if test -z "${GLB_sv_ProjectName}"
then

  # Sets the following LabWarden globals:
  #
  #  GLB_sv_ProjectName                     - Project name (LabWarden)
  #  GLB_sv_ProjectInitials                 - Project initials (LW)
  #  GLB_sv_ProjectDeveloper                - Project developer (com.github.execriez)
  #  GLB_sv_ProjectVersion                  - Project version (i.e. 2.0.6)
  #
  #  GLB_sv_ProjectSignature                - Project signature (e.g. com.github.execriez.labwarden)
  #  GLB_sv_ProjectMajorVersion             - Project major version (i.e. 2)
  #
  #  GLB_bv_UseLoginhookDefault             - Whether we should use the com.apple.loginwindow LoginHook & LogoutHook (true/false)
  #
  #  GLB_bv_LoadConfigsFromADnotesDefault   - Whether we should load policy configs from the AD notes field by default (true/false)
  #
  #  GLB_bv_LogIsActiveDefault              - Whether we should log by default (true/false) 
  #  GLB_iv_MaxLogSizeBytesDefault          - Maximum length of LabWarden log(s)
  #
  #  GLB_iv_LogLevelTrapDefault             - Sets the default logging level (see GLB_iv_MsgLevel...)
  #  GLB_iv_NotifyLevelTrapDefault          - Set the default user notify dialog level
  #
  #  GLB_iv_GPforceAgeMinutesDefault        - How old the policies need to be for gpupdate -force to do updates
  #  GLB_iv_GPquickAgeMinutesDefault        - How old the policies need to be for gpupdate -quick to do updates
  #  GLB_iv_GPdefaultAgeMinutesDefault      - How old the policies need to be for gpupdate to do updates
  #
  #  GLB_iv_UsrPollTriggerSecs              - The point at which we trigger a Usr-Poll event
  #  GLB_iv_SysPollTriggerSecs              - The point at which we trigger a Sys-Poll event
  #  GLB_iv_SysLoginWindowPollTriggerSecs   - The point at which we trigger a Sys-LoginWindowPoll event
  #                                         - These also determine UserIdle, SystemIdle and Sys-LoginWindowIdle events
  #
  #  GLB_iv_MsgLevelEmerg                   - (0) Emergency, system is unusable
  #  GLB_iv_MsgLevelAlert                   - (1) Alert, should be corrected immediately
  #  GLB_iv_MsgLevelCrit                    - (2) Critical, critical conditions (some kind of failure in the systems primary function)
  #  GLB_iv_MsgLevelErr                     - (3) Error, error conditions
  #  GLB_iv_MsgLevelWarn                    - (4) Warning, may indicate that an error will occur if no action is taken
  #  GLB_iv_MsgLevel                        - (5) Notice, events that are unusual, but not error conditions
  #  GLB_iv_MsgLevelInfo                    - (6) Informational, normal operational messages that require no action
  #  GLB_iv_MsgLevelDebug                   - (7) Debug, information useful for developing and debugging
  #
  #  Key:
  #    GLB_ - LabWarden global variable
  #
  #    bv_ - string variable with the values "true" or "false"
  #    iv_ - integer variable
  #    sv_ - string variable
  #
  #    nf_ - null function    (doesn't return a value)
  #    bf_ - boolean function (returns string values "true" or "false"
  #    if_ - integer function (returns an integer value)
  #    sf_ - string function  (returns a string value)

  # ---
  
  GLB_sv_ProjectName="LabWarden"
  GLB_sv_ProjectInitials="LW"
  GLB_sv_ProjectDeveloper="com.github.execriez"
  GLB_sv_ProjectVersion="2.0.17"

  # ---

  # These need to match the values in the corresponding LaunchAgent and LaunchDaemon plists
  
  # The point at which we trigger a Usr-Poll event; 3 minutes (/LaunchAgents/com.github.execriez.labwarden.Usr-Poll.plist)
  GLB_iv_UsrPollTriggerSecs=181

  # The point at which we trigger a Sys-Poll event; 4 minutes (/LaunchDaemons/com.github.execriez.labwarden.Sys-Poll.plist)
  GLB_iv_SysPollTriggerSecs=241

  # The point at which we trigger a Sys-LoginWindowPoll event; 5 minutes (/LaunchAgents/com.github.execriez.labwarden.Sys-LoginWindowPoll.plist)
  GLB_iv_SysLoginWindowPollTriggerSecs=307

  # --- 
  
  # The following constants never change
  
  GLB_iv_MsgLevelEmerg=0
  GLB_iv_MsgLevelAlert=1
  GLB_iv_MsgLevelCrit=2
  GLB_iv_MsgLevelErr=3
  GLB_iv_MsgLevelWarn=4
  GLB_iv_MsgLevelNotice=5
  GLB_iv_MsgLevelInfo=6
  GLB_iv_MsgLevelDebug=7

  # -- Initial default values

  # Set whether we should load policy configs from the AD notes field by default (you may want to use an MDM instead)
  GLB_bv_LoadConfigsFromADnotesDefault="true"

  # Set whether we should use the com.apple.loginwindow LoginHook & LogoutHook by default
  GLB_bv_UseLoginhookDefault="false"

  # Set whether the log is on by default
  GLB_bv_LogIsActiveDefault="true"

  # Set the maximum log size
  GLB_iv_MaxLogSizeBytesDefault=655360
  
  # gpupdate -force updates when policies are older than 1 minute
  GLB_iv_GPforceAgeMinutesDefault=1

  # gpupdate -quick updates when policies are older than 180 days
  GLB_iv_GPquickAgeMinutesDefault=259200

  # gpupdate defaults to update policies when they are older than 6 hours old
  GLB_iv_GPdefaultAgeMinutesDefault=360
  
  # -- Set some values based on the above constamts
  
  GLB_sv_ProjectSignature="$(echo ${GLB_sv_ProjectDeveloper}.${GLB_sv_ProjectName} | tr [A-Z] [a-z])"
  GLB_sv_ProjectMajorVersion="$(echo "${GLB_sv_ProjectVersion}" | cut -d"." -f1)"
  
  # Set the logging level
  GLB_iv_LogLevelTrapDefault=${GLB_iv_MsgLevelInfo}
  
  # Set the user notify dialog level
  GLB_iv_NotifyLevelTrapDefault=${GLB_iv_MsgLevelInfo}
  
  # --- 
fi