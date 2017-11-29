#!/usr/bin/env cwl-runner

cwlVersion: "cwl:v1.0"

class: CommandLineTool

baseCommand: [cmo_fulcrum_annotate_bam_with_umis]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

doc: |
  None

inputs:
  tmp_dir:
    type: File
    inputBinding:
      prefix: --tmp_dir

  input_bam:
    type: string
    inputBinding:
      prefix: --input_bam

  read_names_file:
    type: string
    inputBinding:
      prefix: --read_names_file

  output_bam_filename:
    type: string
    inputBinding:
      prefix: --output_bam_filename

outputs:
  output_bam:
    type: File
    outputBinding:
      glob: $(inputs.output_bam_filename)
