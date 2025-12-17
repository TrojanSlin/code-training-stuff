#!/bin/bash

# =============== Config ================
# Logfile that will have file names of files that need to be stored
LOGFILE=~/Documents/CBNK/mvcheck/test/logfile.txt
# UNarchived tar archive to which all listed files will get copied to
ARCH=~/Documents/CBNK/mvcheck/test/DateSorted.tar
# Directory to which all listed files will get moved to
NEWDIR=~/Documents/CBNK/mvcheck/test/NewDir/

# Directory where all files for archieving will be found
# and log files will be stored
PREFIX=$(dirname $LOGFILE)
# File to which all not found in directory but found in original log file
# files will get listed in
NOTFOUND=$PREFIX/NotFoundFiles.txt
# File to which all found in directory and found in original log file
# files will get listed in
FOUND=$PREFIX/FoundFiles.txt
# File to which all existing and listed in FOUND log file files
# but not copied in a new directory files will get listed in
NOTCOPIED=$PREFIX/NotCopiedFiles.txt

# Change IFS if needed
# IFS=

# ========== Basic error handling =============
# Check if name is specified in variable
if [ "$LOGFILE" = "" -o "$ARCH" = "" -o "$NEWDIR" = "" ]
then
  echo >&2 One of variables isn\'t specified
  echo >&2 LOGFILE = $LOGFILE
  echo >&2 ARCH = $ARCH
  echo >&2 NEWDIR = $NEWDIR
  exit 1
fi

# Check if files in variables can be found
if [ ! -e "$LOGFILE" ] ; then
  echo >&2 Log file $LOGFILE wasn\'t found
  exit 1
fi

if [ ! -e "$ARCH" ] ; then
  echo >&2 Archive $ARCH wasn\'t found
  exit 1
fi

if [ ! -e "$NEWDIR" ] ; then
  echo >&2 New file directory $NEWDIR wasn\'t found
  exit 1
fi

# =========== Every day log files clearing cycle ========
# Create log files if they are not present
if [ ! -e "$NOTFOUND" ] ; then
  touch $NOTFOUND
fi

if [ ! -e "$FOUND" ] ; then
  touch $FOUND
fi

if [ ! -e "$NOTCOPIED" ] ; then
  touch $NOTCOPIED
fi

# Check if local log files were modified a day ago or more
# and clear them if so
FILE_DEPRECATED=false
if [ "$(date "+%Y")" -gt "$(date -d "$(stat -c '%y' $NOTFOUND)" '+%Y')" ]
then
  FILE_DEPRECATED=true
elif [ "$(date "+%m")" -gt "$(date -d "$(stat -c '%y' $NOTFOUND)" '+%m')" ]
then
  FILE_DEPRECATED=true
elif [ "$(date "+%d")" -gt "$(date -d "$(stat -c '%y' $NOTFOUND)" '+%d')" ]
then
  FILE_DEPRECATED=true
fi

if [ $FILE_DEPRECATED ] ; then
  :> $NOTFOUND
  :> $FOUND
  :> $NOTCOPIED
fi

# ============= Logic ================
# Move to working directory
cd $PREFIX

# Go through all files in original log file and put them either in Found
# or NotFound text file.
NOT_FOUND_FILES_COUNT=0
for FILE in $(cat "$LOGFILE") ; do
  if [ ! -e "$FILE" ] ; then
    echo $FILE >> $NOTFOUND
    NOT_FOUND_FILES_COUNT=$(( $NOT_FOUND_FILES_COUNT + 1 ))
  else
    echo $FILE >> $FOUND
  fi
done

# Write out nuber of not found files if they are any
if [ $NOT_FOUND_FILES_COUNT -gt 0 ] ; then
  echo Total of $NOT_FOUND_FILES_COUNT files are in $LOGFILE but not in $PREFIX.\
 Check them in $NOTFOUND >&2
fi


# Get last modification date of existing file and check if there is a
# dedicated directory in archive with "YYYYMMDD" type name if there is non
# create it and put to archive
for FILE in $(cat "$FOUND") ; do
  FILE_MOD_DATE="$(date -d "$(stat -c '%y' $PREFIX/$FILE)" '+%Y%m%d')"
  if [ ! "$(tar -tf $ARCH | grep $FILE_MOD_DATE/)" ] ; then
    mkdir $FILE_MOD_DATE
    tar -rvf $ARCH $FILE_MOD_DATE/
    rm -rf $FILE_MOD_DATE
  fi
# Move file to dedicated directory in the archive
    tar --transform="s|^|$FILE_MOD_DATE/|" -rf $ARCH $FILE
done

# Move files to new directory specified in NEWDIR variable
for FILE in $(cat "$FOUND") ; do
  mv $FILE $NEWDIR
done

# Files not found in new dedicated directory but found in FOUND log file
# will get listed in NOTCOPIED log
NOT_COPIED_FILES_COUNT=0
for FILE in $(cat "$FOUND") ; do
  if [ ! -e "$NEWDIR/$FILE" ] ; then
    echo $FILE >> $NOTCOPIED
    NOT_COPIED_FILES_COUNT=$(( $NOT_COPIED_FILES_COUNT + 1 ))
  fi
done

# Write out nuber of not copied files if they are any
if [ $NOT_COPIED_FILES_COUNT -gt 0 ] ; then
  echo Total of $NOT_COPIED_FILES_COUNT files are in $FOUND but not in $NEWDIR.\
 Check them in $NOTCOPIED >&2
fi

