#!/usr/bin/env cwl-runner

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/
  doap: http://usefulinc.com/ns/doap#

$schemas:
- http://dublincore.org/2012/06/14/dcterms.rdf
- http://xmlns.com/foaf/spec/20140114.rdf
- http://usefulinc.com/ns/doap#

doap:release:
- class: doap:Version
  doap:name: module-3
  doap:revision: 1.0.0
- class: doap:Version
  doap:name: cwl-wrapper
  doap:revision: 1.0.0

dct:creator:
- class: foaf:Organization
  foaf:name: Memorial Sloan Kettering Cancer Center
  foaf:member:
  - class: foaf:Person
    foaf:name: Ian Johnson
    foaf:mbox: mailto:johnsoni@mskcc.org

dct:contributor:
- class: foaf:Organization
  foaf:name: Memorial Sloan Kettering Cancer Center
  foaf:member:
  - class: foaf:Person
    foaf:name: Ian Johnson
    foaf:mbox: mailto:johnsonsi@mskcc.org

cwlVersion: v1.0

class: Workflow
requirements:
    MultipleInputFeatureRequirement: {}
    ScatterFeatureRequirement: {}
    SubworkflowFeatureRequirement: {}
    InlineJavascriptRequirement: {}
    StepInputExpressionRequirement: {}

inputs:
  input_bam: File
  tmp_dir: string
  annotated_bam_filename: string

  sort_order: string
  sorted_bam_filename: string

  set_mate_information_bam_filename: string

  grouping_strategy: string
  min_mapping_quality: string
  tag_family_size_counts_output: string
  group_reads_output_bam_filename: string

  call_duplex_consensus_reads_output_bam_filename: string

  reference_fasta: File
  filter_min_reads: string
  filter_min_base_quality: string
  filter_consensus_reads_output_bam_filename: string

outputs:
  output_bam:
    type: File
    outputSource: filter_consensus_reads/output_bam

steps:
  map_umis_to_read_names:
    run: ./cmo-map-umis-to-read-names/0.0.0/cmo-map-read-names-to-umis.cwl
    in:
      input_bam: input_bam
      output_read_names_filename: output_read_names_filename
    out:
      [read_names_file]


  annotate_bam_with_umis:
    run: ./cmo-fulcrum.AnnotateBamWithUmis/0.2.0/cmo-fulcrum.AnnotateBamWithUmis.cwl
    in:
      tmp_dir: tmp_dir
      input_bam: input_bam
      read_names_file: read_names_file
      output_bam_filename: annotated_bam_filename
    out:
      [output_bam]

  sort_bam:
    run: ./cmo-fulcrum.SortBam/0.2.0/cmo-fulcrum.SortBam.cwl
    in:
        tmp_dir: tmp_dir
        input_bam: annotate_bam_with_umis/output_bam
        sort_order: sort_order
        output_bam_filename: sorted_bam_filename
    out:
      [output_bam]

  set_mate_information:
    run: ./cmo-fulcrum.SetMateInformation/0.2.0/cmo-fulcrum.SetMateInformation.cwl
    in:
      tmp_dir: tmp_dir
      input_bam: sort_bam/output_bam
      output_bam_filename: set_mate_information_bam_filename
    out:
      [output_bam]

  group_reads_by_umi:
    run: ./cmo-fulcrum.GroupReadsByUmi/0.2.0/cmo-fulcrum.GroupReadsByUmi.cwl
    in:
      tmp_dir: tmp_dir
      strategy: grouping_strategy
      min_mapping_quality: min_mapping_quality
      tag_family_size_counts_output: tag_family_size_counts_output
      input_bam: set_mate_information/output_bam
      output_bam_filename: group_reads_output_bam_filename
    out:
      [output_bam]

  call_duplex_consensus_reads:
    run: ./cmo-fulcrum.CallDuplexConsensusReads/0.2.0/cmo-fulcrum.CallDuplexConsensusReads.cwl
    in:
      tmp_dir: tmp_dir
      input_bam: group_reads_by_umi/output_bam
      output_bam_filename: call_duplex_consensus_reads_output_bam_filename
    out:
      [output_bam]

  filter_consensus_reads:
    run: ./cmo-fulcrum.FilterConsensusReads/0.2.0/cmo-fulcrum.FilterConsensusReads.cwl
    in:
      tmp_dir: tmp_dir
      input_bam: call_duplex_consensus_reads/output_bam
      reference_fasta: reference_fasta
      min_reads: filter_min_reads
      min_base_quality: filter_min_base_quality
      output_bam_filename: filter_consensus_reads_output_bam_filename
    out:
      [output_bam]
