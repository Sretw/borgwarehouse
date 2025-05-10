#!/bin/bash

set -e

# print_yellow() {
#   echo -e "\e[33m$1\e[0m";
# }

if [[ -z "$EXTERNAL_CRONTAB_PATH" ]]; then 
  echo "Use default crontab $DEFAULT_CRONTAB_PATH"
  supercronic -inotify $DEFAULT_CRONTAB_PATH
else
  echo "Use external crontab $EXTERNAL_CRONTAB_PATH"
  supercronic -inotify $EXTERNAL_CRONTAB_PATH
fi