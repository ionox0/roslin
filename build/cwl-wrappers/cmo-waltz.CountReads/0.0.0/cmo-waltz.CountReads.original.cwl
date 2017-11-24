cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_waltz_count_reads]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-cp"]

doc: |
  None

inputs:
  bam_file:
    type: File
    inputBinding:
      prefix: --bam_file

  coverage_threshold:
    type: File
    inputBinding:
      prefix: --coverage_threshold

  gene_list:
    type: String
    inputBinding:
      prefix: --gene_list

  bed_file:
    type: File
    inputBinding:
      prefix: --bed_file

