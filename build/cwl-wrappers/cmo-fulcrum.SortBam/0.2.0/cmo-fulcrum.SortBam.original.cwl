#!/usr/bin/env cwl-runner

cwlVersion: "cwl:v1.0"

class: CommandLineTool

baseCommand: [cmo_fulcrum_sort_bam]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

doc: |
  None

inputs:
  tmp_dir:
    type: File
    inputBinding:
      prefix: --tmp_dir

  input_bam:
    type: File
    inputBinding:
      prefix: --input_bam

  sort_order:
    type: File
    inputBinding:
      prefix: --sort_order

  output_bam_filename:
    type: string
    inputBinding:
      prefix: --output_bam_filename

outputs:
  output_bam:
    type: File
    outputBinding:
      glob: $(inputs.output_bam_filename)
