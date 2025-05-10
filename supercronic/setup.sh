#!/bin/bash

print_yellow() {
  echo -e "\e[33m$1\e[0m";
}

if [[ -z "${CRONTAB_PATH}" ]]; then 
    print_yellow "copy default crontab" 
    CRONTAB="./crontab_default"
    print_yellow "crontab path ${CRONTAB}" 
fi