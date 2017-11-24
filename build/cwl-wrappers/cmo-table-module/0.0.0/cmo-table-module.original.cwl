cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_table_module]

arguments: ["", ""]

doc: |
  None

inputs:

  sp:
    type: Directory
    inputBinding:
      prefix: -sp

  m:
    type: Directory
    inputBinding:
      prefix: -m
