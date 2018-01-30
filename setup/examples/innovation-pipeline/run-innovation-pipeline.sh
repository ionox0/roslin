#!/bin/bash

pipeline_name_version="variant/1.3.1"

#roslin_request_to_yaml.py \
#    -m Innovation-Pipeline_sample_mapping.txt \
#    -p Innovation-Pipeline_sample_pairing.txt \
#    -g Innovation-Pipeline_sample_grouping.txt \
#    -r Innovation-Pipeline_request.txt \
#    -o . \
#    -f inputs.yaml

#roslin-runner.sh \
#    -v ${pipeline_name_version} \
#    -w project-workflow.cwl \
#    -i inputs.yaml \
#    -b singleMachine

#roslin_submit.py \
#   --id Innovation-Pipeline \
#   --path . \
#   --workflow project-workflow--mod.cwl \
#   --pipeline ${pipeline_name_version}


source ${ROSLIN_CORE_CONFIG_PATH}/${pipeline_name_version}/settings.sh

job_uuid=`python -c 'import uuid; print str(uuid.uuid1())'`

jobstore_path="${ROSLIN_PIPELINE_BIN_PATH}/tmp/jobstore-${job_store_uuid}"

output_directory="./outputs"

# create output directory
mkdir -p ${output_directory}

# create log directory (under output)
mkdir -p ${output_directory}/log

cwltoil \
    ${ROSLIN_PIPELINE_BIN_PATH}/cwl/project-workflow--mod.cwl \
    inputs.yaml \
    --jobStore file://${jobstore_path} \
    --defaultDisk 10G \
    --defaultMem 50G \
    --preserve-environment PATH PYTHONPATH ROSLIN_PIPELINE_DATA_PATH ROSLIN_PIPELINE_BIN_PATH ROSLIN_EXTRA_BIND_PATH ROSLIN_PIPELINE_WORKSPACE_PATH ROSLIN_PIPELINE_OUTPUT_PATH ROSLIN_SINGULARITY_PATH CMO_RESOURCE_CONFIG \
    --no-container \
    --disableCaching \
    --realTimeLogging \
    --maxLogFileSize 0 \
    --writeLogs	${output_directory}/log \
    --logFile ${output_directory}/log/cwltoil.log \
    --workDir ${ROSLIN_PIPELINE_BIN_PATH}/tmp \
    --outdir ${output_directory} \
    --logDebug \
    --cleanWorkDir never \
    --not-strict

#    | tee ${output_directory}/output-meta.json
#    --not-strict \


    # ${restart_options} ${batch_sys_options} ${debug_options} \