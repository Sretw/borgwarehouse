#!/bin/bash

if [[ -z "${CRONTAB_PATH}" ]]; then 
    echo copy default crontab 
    cp crontab ./crontab 
    ${CRONTAB}=./crontab 
fi