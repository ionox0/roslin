cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: samtools

stdout: $(inputs.samtools_view_file)

inputs:
  input_bam:
    type: File
    inputBinding:
      prefix: --input_bam

  samtools_view_file:
    type: string
    inputBinding:
      prefix: --samtools_view_file

outputs:
  samtools_view_file_name:
    type: stdout
