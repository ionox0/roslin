#!/bin/bash

pipeline_name_version="variant/1.3.1"

roslin-runner.sh \
    -v ${pipeline_name_version} \
    -w innovation_pipeline.scatter.cwl \
    -i inputs-scatter.yaml \
    -b lsf \
    -o /ifs/work/bergerm1/Innovation/sandbox/ian/outputs--scatter