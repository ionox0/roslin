cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_aggregate_bam_metrics]

arguments: ["", ""]

doc: |
  None

inputs:

  # Somehow need to run from inside directory with Waltz output...

  dummy_input:
    type: string
    inputBinding:
      prefix: --dummy_input

outputs:

  fragment_sizes:
    type: File
    outputBinding:
      glob: ${ return "**/fragment-sizes.txt" }

  read_counts:
    type: File
    outputBinding:
      glob: ${ return "**/read-counts.txt" }

  waltz_coverage:
    type: File
    outputBinding:
      glob: ${ return "**/waltz-coverage.txt" }

  intervals_coverage_sum:
    type: File
    outputBinding:
      glob: ${ return "**/intervals-coverage-sum.txt" }
