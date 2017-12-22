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

  #########################
  # Marianas UMI Clipping #
  #########################

  fastq1: string
  fastq2: string
  sample_sheet: File
  umi_length: string
  output_project_folder: string
  outdir: string

  ############
  # Module 1 #
  ############

  adapter: string
  adapter2: string
# (Comes from PLUF):
#  fastq1: File
#  fastq2: File
  genome: string
  bwa_output: string
  add_rg_LB: string
  add_rg_PL: string
  add_rg_ID: string
  add_rg_PU: string
  add_rg_SM: string
  add_rg_CN: string
  add_rg_output: string
  md_output: string
  md_metrics_output: string
  tmp_dir: string

  ###########
  # Fulcrum #
  ###########

  # extract_read_names
  output_read_names_filename: string
  # map_read_names_to_umis
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

  # sort_bam_queryname
  sort_bam_queryname_filename: string

  # samtools fastq
  samtools_fastq_read1_output_filename: string
  samtools_fastq_read2_output_filename: string


  #########
  # Waltz #
  #########

  coverage_threshold: string
  gene_list: string
  bed_file: string
  min_mapping_quality: string
  waltz_reference_fasta: string
  waltz_reference_fasta_fai: string

outputs:
  output_bam:
    type: File
    outputSource: module_1_post_fulcrum/bam

steps:


  #########################
  # Marianas UMI Clipping #
  #########################

  cmo_process_loop_umi_fastq:
    run: ./cmo-marianas.ProcessLoopUMIFastq/0.0.0/cmo-marianas.ProcessLoopUMIFastq.cwl
    in:
      fastq1: fastq1
      fastq2: fastq2
      sample_sheet: sample_sheet
      umi_length: umi_length
      output_project_folder: output_project_folder
      outdir: outdir
    out: [processed_fastq_1, processed_fastq_2, info, output_sample_sheet, umi_frequencies]


  ####################
  # Adapted module 1 #
  ####################

  module_1_innovation:
    run: ./module-1.innovation.cwl
    in:
      fastq1: cmo_process_loop_umi_fastq/processed_fastq_1
      fastq2: cmo_process_loop_umi_fastq/processed_fastq_2
      genome: genome
      bwa_output: bwa_output
      add_rg_LB: add_rg_LB
      add_rg_PL: add_rg_PL
      add_rg_ID: add_rg_ID
      add_rg_PU: add_rg_PU
      add_rg_SM: add_rg_SM
      add_rg_CN: add_rg_CN
      add_rg_output: add_rg_output
      md_output: md_output
      md_metrics_output: md_metrics_output
      tmp_dir: tmp_dir
    out:
      [bam, bai, md_metrics] # clstats1, clstats2,


  #############################
  # Waltz Run (Standard Bams) #
  #############################

  waltz_count_reads:
    run: ./cmo-waltz.CountReads/0.0.0/cmo-waltz.CountReads.cwl
    in:
      input_bam: module_1_innovation/bam
      coverage_threshold: coverage_threshold
      gene_list: gene_list
      bed_file: bed_file
    out:
      [bam_covered_regions, bam_fragment_sizes, bam_read_counts]

  waltz_pileup_metrics:
    run: ./cmo-waltz.PileupMetrics/0.0.0/cmo-waltz.PileupMetrics.cwl
    in:
      input_bam: module_1_innovation/bam
      min_mapping_quality: min_mapping_quality
      reference_fasta: waltz_reference_fasta
      reference_fasta_fai: waltz_reference_fasta_fai
      bed_file: bed_file
    out:
      [pileup, pileup_without_duplicates, intervals, intervals_without_duplicates]


  ###########################
  # Collapsing with Fulcrum #
  ###########################

  fulcrum:
    run: ./fulcrum_workflow.cwl
    in:
      tmp_dir: tmp_dir
      output_read_names_filename: output_read_names_filename
      annotated_fastq_filename: annotated_fastq_filename
      input_bam: module_1_innovation/bam
      annotated_bam_filename: annotated_bam_filename
      sort_order: sort_order
      sorted_bam_filename: sorted_bam_filename
      set_mate_information_bam_filename: set_mate_information_bam_filename

      # Fulcrum group reads
      grouping_strategy: grouping_strategy
      min_mapping_quality: min_mapping_quality
      tag_family_size_counts_output: tag_family_size_counts_output
      group_reads_output_bam_filename: group_reads_output_bam_filename

      # Fulcrum call duplex consensus reads
      call_duplex_consensus_reads_output_bam_filename: call_duplex_consensus_reads_output_bam_filename
      reference_fasta: reference_fasta

      # Fulcrum filter reads
      filter_min_reads: filter_min_reads
      filter_min_base_quality: filter_min_base_quality
      filter_consensus_reads_output_bam_filename: filter_consensus_reads_output_bam_filename

      # Samtools sort bam
      sort_bam_queryname_filename: sort_bam_queryname_filename

      # Samtools fastq
      samtools_fastq_read1_output_filename: samtools_fastq_read1_output_filename
      samtools_fastq_read2_output_filename: samtools_fastq_read2_output_filename

    out:
      [output_fastq_1, output_fastq_2]


  ####################
  # Regular Module 1 #
  ####################

  module_1_post_fulcrum:
    run: ./module-1.cwl
    in:
      fastq1: fulcrum/output_fastq_1
      fastq2: fulcrum/output_fastq_2
      adapter: adapter
      adapter2: adapter2
      genome: genome
      bwa_output: bwa_output
      add_rg_LB: add_rg_LB
      add_rg_PL: add_rg_PL
      add_rg_ID: add_rg_ID
      add_rg_PU: add_rg_PU
      add_rg_SM: add_rg_SM
      add_rg_CN: add_rg_CN
      add_rg_output: add_rg_output
      md_output: md_output
      md_metrics_output: md_metrics_output
      tmp_dir: tmp_dir
    out:
      [bam, bai, md_metrics] # clstats1, clstats2,


  #################################
  # Waltz Run (Fulcrum Collapsed) #
  #################################

  waltz_count_reads:
    run: ./cmo-waltz.CountReads/0.0.0/cmo-waltz.CountReads.cwl
    in:
      input_bam: module_1_post_fulcrum/bam
      coverage_threshold: coverage_threshold
      gene_list: gene_list
      bed_file: bed_file
    out:
      [bam_covered_regions, bam_fragment_sizes, bam_read_counts]

  waltz_pileup_metrics:
    run: ./cmo-waltz.PileupMetrics/0.0.0/cmo-waltz.PileupMetrics.cwl
    in:
      input_bam: module_1_post_fulcrum/bam
      min_mapping_quality: min_mapping_quality
      reference_fasta: waltz_reference_fasta
      reference_fasta_fai: waltz_reference_fasta_fai
      bed_file: bed_file
    out:
      [pileup, pileup_without_duplicates, intervals, intervals_without_duplicates]


  ############################
  # Collapsing with Marianas #
  ############################


  # $java -server -Xms8g -Xmx8g -cp
  # ~/software/Marianas.jar
  # org.mskcc.marianas.umi.duplex.fastqprocessing.ProcessLoopUMIFastq
  # fastq_path umi_length .

  marianas:
    run: ./marianas.ProcessLoopUMI