#!/usr/bin/env cwl-runner

cwlVersion: "cwl:v1.0"

class: CommandLineTool

baseCommand: [cmo_fulcrum_group_reads_by_umi]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

doc: |
  None

inputs:
  tmp_dir:
    type: string
    inputBinding:
      prefix: --tmp_dir

  # todo - research
  something:
    type: string
    inputBinding:
      prefix: --something

  something_else:
    type: string
    inputBinding:
      prefix: --something_else

  something_else_else:
    type: string
    inputBinding:
      prefix: --something_else_else

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
