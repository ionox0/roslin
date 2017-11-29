#!/usr/bin/env cwl-runner

cwlVersion: "cwl:v1.0"

class: CommandLineTool

baseCommand: [cmo_fulcrum_filter_consensus_reads]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

doc: |
  None

inputs:
  tmp_dir:
    type: string
    inputBinding:
      prefix: --tmp_dir

  input_bam:
    type: File
    inputBinding:
      prefix: --input_bam

  reference_fasta:
    type: File
    inputBinding:
      prefix: --reference_fasta

  something:  # todo - research
    type: string
    inputBinding:
      prefix: --something

  something_else:
    type: string
    inputBinding:
      prefix: --something_else

  output_bam_filename:
    type: string
    inputBinding:
      prefix: --output_bam_filename

outputs:
  output_bam:
    type: File
    outputBinding:
      glob: $(inputs.output_bam_filename)
