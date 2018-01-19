#!/bin/bash

pipeline_name_version="variant/1.3.1"

# This test pipeline gets run with
# singleMachine (don't use lsf / bjobs)
# and -d (debug output)

roslin-runner.sh \
    -v ${pipeline_name_version} \
    -w innovation_pipeline.scatter.cwl \
    -i inputs-pipeline-test.yaml \
    -b singleMachine \
    -d \
    -o /ifs/work/bergerm1/Innovation/sandbox/ian/outputs-scatter-1-12-2018--new

# (Include for restarting failed job):
#    -r \
# --> translates to:
# --logDebug --cleanWorkDir never
