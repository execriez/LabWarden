#!/bin/bash
#
# Download and compile rsync (requires xcode tools)
#
# Modified: 22-May-2022

if [ -z "$(type make)"]
then
  echo "Please install the xcode command line tools"
  exit 0
fi

sv_InstallPath="/tmp/rsync-temp-folder"
sv_CodeVersion="3.2.4"

mkdir -p "${sv_InstallPath}"/rsync
cd "${sv_InstallPath}"/rsync

curl -O https://rsync.samba.org/ftp/rsync/src/rsync-${sv_CodeVersion}.tar.gz
tar -xzvf rsync-${sv_CodeVersion}.tar.gz
rm rsync-${sv_CodeVersion}.tar.gz

curl -O https://rsync.samba.org/ftp/rsync/src/rsync-patches-${sv_CodeVersion}.tar.gz
tar -xzvf rsync-patches-${sv_CodeVersion}.tar.gz
rm rsync-patches-${sv_CodeVersion}.tar.gz

cd rsync-${sv_CodeVersion}
patch -p1 <patches/fileflags.diff
./prepare-source
./configure --prefix="${sv_InstallPath}"/rsync --disable-openssl --disable-xxhash --disable-zstd --disable-lz4 

make
make install

cd "${sv_InstallPath}"/rsync
rm -Rf rsync-${sv_CodeVersion}

echo "---"
echo
echo "rsync can be found in the directory '${sv_InstallPath}'"
echo
echo "---"

osascript -e 'tell application "Finder" to open ("'"${sv_InstallPath}"'" as POSIX file)'
