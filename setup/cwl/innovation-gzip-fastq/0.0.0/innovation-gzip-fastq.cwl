#!/usr/bin/env cwl-runner

cwlVersion: "draft-3"
#cwlVersion: v1.0

class: CommandLineTool

description: "command line: gzip"

requirements:
  - class: InlineJavascriptRequirement

inputs:

  - id: input
    type: File
    inputBinding:
      position: 0

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.input.path.split("/").slice(-1)[0].split(".").slice(0,-1).join(".") + '.fastq.gz')

baseCommand: [gzip, -c]
stdout: $(inputs.input.path.split("/").slice(-1)[0].split(".").slice(0,-1).join(".") + '.fastq.gz')