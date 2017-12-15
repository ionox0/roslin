#!/usr/bin/env bash


source ./setup/config/settings.sh

echo ${ROSLIN_PIPELINE_BIN_PATH}

# copy cwl wrappers
cp -R ./setup/cwl/* ${ROSLIN_PIPELINE_BIN_PATH}/cwl/