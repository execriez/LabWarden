#!/bin/bash
#
# Short:    Usr Policy Footer - Included at the end of every (bash) gen policy
# Author:   Mark J Swift
# Version:  3.2.5
# Modified: 30-Dec-2020
#
# Should be included at the bottom of any policy script as follows:
#   . "${GLB_SV_PROJECTDIRPATH}"/inc-sh/PolicyFooter.sh
#
# Note: All the usual globals have been set up before this script is run
#
    
# ---

# We dont want to quit until all sub tasks are finished
while [ -n "$(jobs -r)" ]
do
  # We don't want to hog the CPU - so lets sleep a while
  GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "Waiting for $(jobs -r | wc -l) sub tasks of '${GLB_SV_POLICYNAME}' to finish"
  sleep 1
done

# ---

# Take a note that the Policy is complete
GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Policy done."

# Remove temporary files
cd "${GLB_SV_PROJECTDIRPATH}"
rm -fR "${GLB_SV_THISSCRIPTTEMPDIRPATH}"

# ---
