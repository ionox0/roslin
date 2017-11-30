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

  strategy:
    type: string
    inputBinding:
      prefix: --strategy

  min_mapping_quality:
    type: string
    inputBinding:
      prefix: --min_mapping_quality

  tag_family_size_counts_outpu:
    type: string
    inputBinding:
      prefix: --tag_family_size_counts_output

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
