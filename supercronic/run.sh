#!/bin/bash

set -e

# print_yellow() {
#   echo -e "\e[33m$1\e[0m";
# }

# define variables
CRONTAB_DIR="/etc/crontab"
CRONTAB_FILE="$CRONTAB_DIR/crontab"
DEFAULT_CRONTAB_FILE="./crontab_default"

# if crontab file not exits then
# copy defult crontab file to crontab directory
if [[ ! -f $CRONTAB_FILE ]]; then 
  echo "crontabl doesn't exists, use default crontab"
  cp $DEFAULT_CRONTAB_FILE $CRONTAB_FILE
else
  echo "Use external crontab $CRONTAB_FILE"
fi

# run crontab file
supercronic -inotify $CRONTAB_FILE