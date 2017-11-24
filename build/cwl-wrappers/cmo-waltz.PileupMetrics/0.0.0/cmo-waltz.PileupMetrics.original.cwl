cwlVersion: cmo-fulcrum.AnnotateBamWithUmis.original.cmo-fulcrum.CallDuplexConsensusReads.original.cmo-fulcrum.FilterConsensusReads.original.cmo-fulcrum.SetMateInformation.original.cmo-fulcrum.SortBam.original.cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_waltz_pileup_metrics]

arguments: ["-server", "-Xms4g", "-Xmx4g", "-cp"]

doc: |
  None

inputs:
  module:
    type: File
    inputBinding:
      prefix: --module

  minimum_mapping_quality:
    type: String
    inputBinding:
      prefix: --minimum_mapping_quality

  bam_file:
    type: File
    inputBinding:
      prefix: --bam_file

  reference_fasta_file:
    type: File
    inputBinding:
      prefix: --reference_fasta_file

  intervals_bed_file:
    type: File
    inputBinding:
      prefix: --intervals_bed_file