cwlVersion: v1.0

class: CommandLineTool

baseCommand: awk

inputs:
  input_bam:
    type: string
    inputBinding:
      position: 1

  awk_pattern:
    type: File
    inputBinding:
      position: 2

  output_read_names_filename:
    type: string

outputs:
  read_names_file:
    type: File
    outputBinding:
      glob: $(inputs.output_read_names_filename)
