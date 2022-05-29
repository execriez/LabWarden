#!/bin/bash
#
# Short:    Constants (shell)
# Author:   Mark J Swift
# Version:  3.3.0
# Modified: 22-May-2022
#
# Should be included into scripts as follows:
#   . /usr/local/LabWarden/inc-sh/CoreConst.sh
#

# Only INCLUDE the code if it isn't already included
if [ -z "${GLB_BC_CORECONST_INCLUDED}" ]
then

  # Defines the following LabWarden global constants:
  #
  #  GLB_IC_USRPOLLTRIGGERSECS              - The point at which we trigger a Usr-Poll event
  #  GLB_IC_SYSPOLLTRIGGERSECS              - The point at which we trigger a Sys-Poll event
  #  GLB_IC_SYSLOGINWINDOWPOLLTRIGGERSECS   - The point at which we trigger a Sys-LoginWindowPoll event
  #                                         - These also determine UserIdle, SystemIdle and Sys-LoginWindowIdle events
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
  
  # These constants are fixed and must match the values in the corresponding LaunchAgent and LaunchDaemon plists
  
  GLB_IC_MAXWAITSECS=127 # 2 minutes, maximum wait time before giving up on something
  GLB_IC_USRPOLLTRIGGERSECS=181 # 3 minutes, the point at which we trigger a Usr-Poll event
  GLB_IC_SYSPOLLTRIGGERSECS=241 # 4 minutes, the point at which we trigger a Sys-Poll event
  GLB_IC_SYSLOGINWINDOWPOLLTRIGGERSECS=307 # 5 minutes, the point at which we trigger a Sys-LoginWindowPoll

  # If we are not getting any idle events after some time - something is amiss - maybe the mouse is sitting on the keyboard
  
  GLB_IC_FORCEIDLETRIGGERSECS=3600 # 1 hour, the point at which we force trigger an idle event 
  
  # ---
  
  GLB_BC_CORECONST_INCLUDED=${GLB_BC_TRUE}
  
  # --- 
fi
