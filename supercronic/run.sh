#!/bin/bash

set -e

# print_yellow() {
#   echo -e "\e[33m$1\e[0m";
# }

CRONTAB_DIR="/etc/crontab"
CRONTAB_FILE="$CRONTAB_DIR/crontab"
DEFAULT_CRONTAB_FILE="./crontab_default"

if [[ ! -f $CRONTAB_FILE ]]; then 
  echo "crontabl doesn't exists, use default crontab"
  cp $DEFAULT_CRONTAB_FILE $CRONTAB_FILE
else
  echo "Use external crontab $CRONTAB_FILE"
fi

supercronic -inotify $CRONTAB_FILE