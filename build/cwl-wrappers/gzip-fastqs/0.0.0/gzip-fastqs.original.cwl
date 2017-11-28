cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [gzip]

arguments: ["-f"]

doc: |
  None

inputs:
  r1_fastq:
    type: File
    inputBinding:
      position: 1
  r2_fastq:
    type: File
    inputBinding:
      position: 2

outputs:
  - id: gzipped_files
    type: File
    outputBinding:
      glob: "*.gz"
