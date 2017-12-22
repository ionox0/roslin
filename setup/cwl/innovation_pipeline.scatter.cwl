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
  doap:name: innovation_pipeline.scatter
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
    foaf:mbox: mailto:johnsoni@mskcc.org

cwlVersion: v1.0

class: Workflow
requirements:
  MultipleInputFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:

  fastq1: string[]
  fastq2: string[]
  sample_sheet: File[]

  umi_length: string
  output_project_folder: string
  outdir: string

  adapter: string
  adapter2: string
  genome: string
  add_rg_PL: string
  add_rg_CN: string
  tmp_dir: string

  bwa_output: string[]
  add_rg_LB: string[]
  add_rg_ID: string[]
  add_rg_PU: string[]
  add_rg_SM: string[]
  add_rg_output: string[]
  md_output: string[]
  md_metrics_output: string[]

  output_read_names_filename: string
  annotated_fastq_filename: string
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
  sort_bam_queryname_filename: string
  samtools_fastq_read1_output_filename: string
  samtools_fastq_read2_output_filename: string
  coverage_threshold: string
  gene_list: string
  bed_file: string
  min_mapping_quality: string
  waltz_reference_fasta: string
  waltz_reference_fasta_fai: string


outputs:

  standard_bam:
    type:
      type: array
      items: File
    outputSource: scatter_step/standard_bam

  standard_waltz_bam_covered_regions:
    type:
      type: array
      items: File
    outputSource: scatter_step/standard_waltz_bam_covered_regions
  standard_waltz_bam_fragment_sizes:
    type:
      type: array
      items: File
    outputSource: scatter_step/standard_waltz_bam_fragment_sizes
  standard_waltz_bam_read_counts:
    type:
      type: array
      items: File
    outputSource: scatter_step/standard_waltz_bam_read_counts
  standard_waltz_pileup:
    type:
      type: array
      items: File
    outputSource: scatter_step/standard_waltz_pileup
  standard_waltz_pileup_without_duplicates:
    type:
      type: array
      items: File
    outputSource: scatter_step/standard_waltz_pileup_without_duplicates
  standard_waltz_intervals:
    type:
      type: array
      items: File
    outputSource: scatter_step/standard_waltz_intervals
  standard_waltz_intervals_without_duplicates:
    type:
      type: array
      items: File
    outputSource: scatter_step/standard_waltz_intervals_without_duplicates


  fulcrum_collapsed_bam:
    type:
      type: array
      items: File
    outputSource: scatter_step/fulcrum_collapsed_bam

  fulcrum_waltz_bam_covered_regions:
    type:
      type: array
      items: File
    outputSource: scatter_step/fulcrum_waltz_bam_covered_regions
  fulcrum_waltz_bam_fragment_sizes:
    type:
      type: array
      items: File
    outputSource: scatter_step/fulcrum_waltz_bam_fragment_sizes
  fulcrum_waltz_bam_read_counts:
    type:
      type: array
      items: File
    outputSource: scatter_step/fulcrum_waltz_bam_read_counts
  fulcrum_waltz_pileup:
    type:
      type: array
      items: File
    outputSource: scatter_step/fulcrum_waltz_pileup
  fulcrum_waltz_pileup_without_duplicates:
    type:
      type: array
      items: File
    outputSource: scatter_step/fulcrum_waltz_pileup_without_duplicates
  fulcrum_waltz_intervals:
    type:
      type: array
      items: File
    outputSource: scatter_step/fulcrum_waltz_intervals
  fulcrum_waltz_intervals_without_duplicates:
    type:
      type: array
      items: File
    outputSource: scatter_step/fulcrum_waltz_intervals_without_duplicates


steps:

  scatter_step:
    run: ./innovation_pipeline.cwl

    in:
      fastq1: fastq1
      fastq2: fastq2
      sample_sheet: sample_sheet
      umi_length: umi_length
      output_project_folder: output_project_folder
      outdir: outdir
      adapter: adapter
      adapter2: adapter2
      genome: genome
      add_rg_PL: add_rg_PL
      add_rg_CN: add_rg_CN
      tmp_dir: tmp_dir
      bwa_output: bwa_output
      add_rg_LB: add_rg_LB
      add_rg_ID: add_rg_ID
      add_rg_PU: add_rg_PU
      add_rg_SM: add_rg_SM
      add_rg_output: add_rg_output
      md_output: md_output
      md_metrics_output: md_metrics_output
      output_read_names_filename: output_read_names_filename
      annotated_fastq_filename: annotated_fastq_filename
      tmp_dir: tmp_dir
      annotated_bam_filename: annotated_bam_filename
      sort_order: sort_order
      sorted_bam_filename: sorted_bam_filename
      set_mate_information_bam_filename: set_mate_information_bam_filename
      grouping_strategy: grouping_strategy
      min_mapping_quality: min_mapping_quality
      tag_family_size_counts_output: tag_family_size_counts_output
      group_reads_output_bam_filename: group_reads_output_bam_filename
      call_duplex_consensus_reads_output_bam_filename: call_duplex_consensus_reads_output_bam_filename
      reference_fasta: reference_fasta
      filter_min_reads: filter_min_reads
      filter_min_base_quality: filter_min_base_quality
      filter_consensus_reads_output_bam_filename: filter_consensus_reads_output_bam_filename
      sort_bam_queryname_filename: sort_bam_queryname_filename
      samtools_fastq_read1_output_filename: samtools_fastq_read1_output_filename
      samtools_fastq_read2_output_filename: samtools_fastq_read2_output_filename
      coverage_threshold: coverage_threshold
      gene_list: gene_list
      bed_file: bed_file
      min_mapping_quality: min_mapping_quality
      waltz_reference_fasta: waltz_reference_fasta
      waltz_reference_fasta_fai: waltz_reference_fasta_fai

    scatter: [fastq1,fastq2,sample_sheet,bwa_output,add_rg_LB,add_rg_ID,add_rg_PU,add_rg_SM,add_rg_output,md_output,md_metrics_output]

    scatterMethod: dotproduct

    out: [standard_bam,standard_waltz_bam_covered_regions,standard_waltz_bam_fragment_sizes,standard_waltz_bam_read_counts,standard_waltz_pileup,standard_waltz_pileup_without_duplicates,standard_waltz_intervals,standard_waltz_intervals_without_duplicates,fulcrum_collapsed_bam,fulcrum_waltz_bam_covered_regions,fulcrum_waltz_bam_fragment_sizes,fulcrum_waltz_bam_read_counts,fulcrum_waltz_pileup,fulcrum_waltz_pileup_without_duplicates,fulcrum_waltz_intervals,fulcrum_waltz_intervals_without_duplicates]