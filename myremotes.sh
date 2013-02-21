#!/bin/bash

# Written by Alexander Yukhnenko
# auwerk (at) gmail (dot) com

# This script mounts/unmounts SSHFS locations
# to the subdirectories in ~/_Remotes
#
# Usage: ./myremotes mount|umount <path_to_hostlist_file>
#
# Host list file example:
#
# user@host.de
# specificsshport@92.56.87.162:1222
# tram@pampam.eu#/home/users/trampam
# bam@bambam.tv:1222#/home/users/bam

# Check if specified host list exists
if [ ! -f $2 ]; then
  echo "Host list '$2' doesn't exist"
  exit
fi

# Create ~/_Remotes directory if doesn't exist
if [ ! -d "/home/$(whoami)/_Remotes" ]; then
  mkdir -p "/home/$(whoami)/_Remotes"
fi

case "$1" in
"mount")
  FILENAME=$2
  while read line
  do
    USER_HOST_PORT=`echo $line | awk -F"#" '{print $1}'`
    REMOTEDIR=`echo $line | awk -F"#" '{print $2}'`
    USERHOST=`echo $USER_HOST_PORT | awk -F":" '{print $1}'`
    PORT=`echo $USER_HOST_PORT | awk -F":" '{print $2}'`
    if [ -z $PORT ]; then
      let PORT=22
    fi
    USER=`echo $USERHOST | awk -F"@" '{print $1}'`
    HOST=`echo $USERHOST | awk -F"@" '{print $2}'`
    DEFAULT_REMOTEDIR="/home/$USER"
    LOCAL_MPT="/home/$(whoami)/_Remotes/$HOST/$USER"
    if [ ! -d $LOCAL_MPT ]; then
      mkdir -p $LOCAL_MPT
      if [ -z $REMOTEDIR ]; then
        `sshfs $USER@$HOST:$DEFAULT_REMOTEDIR $LOCAL_MPT -p $PORT`
      else
        `sshfs $USER@$HOST:$REMOTEDIR $LOCAL_MPT -p $PORT`
      fi
    fi
  done < $FILENAME
  ;;
"umount")
  FILENAME=$2
  while read line
  do
    USER_HOST_PORT=`echo $line | awk -F"#" '{print $1}'`
    USERHOST=`echo $USER_HOST_PORT | awk -F":" '{print $1}'`
    USER=`echo $USERHOST | awk -F"@" '{print $1}'`
    HOST=`echo $USERHOST | awk -F"@" '{print $2}'`
    LOCAL_MPT="/home/$(whoami)/_Remotes/$HOST/$USER"
    LOCAL_MPT_H="/home/$(whoami)/_Remotes/$HOST"
    echo $LOCAL_MPT
    if [ -d $LOCAL_MPT ]; then
      sudo umount $LOCAL_MPT
      rmdir $LOCAL_MPT
      rmdir $LOCAL_MPT_H
    fi
  done < $FILENAME
  rmdir "/home/$(whoami)/_Remotes"
  ;;
*)
  echo "Usage: myrem mount|umount"
  ;;
esac
