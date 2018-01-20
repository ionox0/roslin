#!/bin/bash

pipeline_name_version="variant/1.3.1"

roslin-runner.sh \
    -v ${pipeline_name_version} \
    -w cmo-fulcrum.GroupReadsByUmi/0.0.0/cmo-fulcrum.GroupReadsByUmi.cwl \
    -i inputs.yaml \
    -b lsf
