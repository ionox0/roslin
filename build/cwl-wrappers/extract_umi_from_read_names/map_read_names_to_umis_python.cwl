cwlVersion: v1.0

class: CommandLineTool

baseCommand: [map_read_names_to_umis]

inputs:
  input_bed:
    type: string
    inputBinding:
      position: 1

  output_file_name:
    type: string

outputs:
  umi_to_read_name_mapping:
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)
