#!/usr/bin/env cwl-runner

cwlVersion: "cwl:v1.0"

class: CommandLineTool

baseCommand: [cmo_fulcrum_call_duplex_consensus_reads]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

doc: |
  None

inputs:
  tmp_dir:
    type: string      # todo - directory?
    inputBinding:
      prefix: --tmp_dir

  input_bam:
    type: File
    inputBinding:
      prefix: --input_bam

  output_bam_filename:
    type: string
    inputBinding:
      prefix: --output_bam_filename

outputs:
  output_bam:
    type: File
    outputBinding:
      glob: $(inputs.output_bam_filename)