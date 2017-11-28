cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_aggregate_bam_metrics]

arguments: [""]

doc: |
  None


requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entryname: all_required_files
        listing:
          - $(inputs.intervals)
          - $(inputs.intervals_without_duplicates)
          - $(inputs.pileup)
          - $(inputs.covered_regions)
          - $(inputs.fragment_sizes)
          - $(inputs.read_counts)

inputs:
  intervals:
    type: File
    inputBinding:
      prefix:
        --intervals
  intervals_without_duplicates:
    type: File
    inputBinding:
      prefix:
        --intervals_without_duplicates
  pileup:
    type: File
    inputBinding:
      prefix:
        --pileup
  covered_regions:
    type: File
    inputBinding:
      prefix:
        --covered_regions
  fragment_sizes:
    type: File
    inputBinding:
      prefix:
        --fragment_sizes
  read_counts:
    type: File
    inputBinding:
      prefix:
        --read_counts

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

  # Also list the whole directory of outputs
  out_dir: Directory
  expression: |
    ${
      return {"out": {
        "class": "Directory",
        "basename": "bam_metrics_output",
        "listing": [outputs.fragment_sizes, outputs.read_counts,
        outputs.waltz_coverage, outputs.intervals_coverage_sum]
      } };
    }