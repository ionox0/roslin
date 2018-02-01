#!/usr/bin/env bash


source ./setup/config/settings.sh

echo ${ROSLIN_PIPELINE_BIN_PATH}

# copy cwl wrappers
cp -R ./setup/cwl/* ${ROSLIN_PIPELINE_BIN_PATH}/cwl/


# copy the Roslin Pipeline settings.sh to Roslin Core config directory
mkdir -p ${ROSLIN_CORE_CONFIG_PATH}/${ROSLIN_PIPELINE_NAME}/${ROSLIN_PIPELINE_VERSION}
cp ./setup/config/settings.sh ${ROSLIN_CORE_CONFIG_PATH}/${ROSLIN_PIPELINE_NAME}/${ROSLIN_PIPELINE_VERSION}