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
  doap:name: module-1-2.chunk
  doap:revision: 1.0.0
- class: doap:Version
  doap:name: cwl-wrapper
  doap:revision: 1.0.0

dct:creator:
- class: foaf:Organization
  foaf:name: Memorial Sloan Kettering Cancer Center
  foaf:member:
  - class: foaf:Person
    foaf:name: Christopher Harris
    foaf:mbox: mailto:harrisc2@mskcc.org

dct:contributor:
- class: foaf:Organization
  foaf:name: Memorial Sloan Kettering Cancer Center
  foaf:member:
  - class: foaf:Person
    foaf:name: Christopher Harris
    foaf:mbox: mailto:harrisc2@mskcc.org
  - class: foaf:Person
    foaf:name: Jaeyoung Chun
    foaf:mbox: mailto:chunj@mskcc.org

cwlVersion: v1.0

class: Workflow
requirements:
  MultipleInputFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}

inputs:

  # [sample, sample, sample]
  # sample = [read1, read1, read1]
  fastq1:
    type:
      type: array
      items:
        type: array
        items: File

  # [sample, sample, sample]
  # sample = [read2, read2, read2]
  fastq2:
    type:
      type: array
      items:
        type: array
        items: File

  adapter:
    type:
      type: array
      items: string
  adapter2:
    type:
      type: array
      items: string
  bwa_output:
    type:
      type: array
      items: string
  add_rg_LB:
    type:
      type: array
      items: string
  add_rg_PL:
    type:
      type: array
      items: string


  # todo - should be arrays of arrays...? but not sure for what reason
  add_rg_ID:
    type:
      type: array
      items: string
  add_rg_PU:
    type:
      type: array
      items: string


  add_rg_SM:
    type:
      type: array
      items: string
  add_rg_CN:
    type:
      type: array
      items: string
  tmp_dir: string
  genome: string
  hapmap:
    type: File
    secondaryFiles:
       - .idx
  dbsnp:
    type: File
    secondaryFiles:
       - .idx
  indels_1000g:
    type: File
    secondaryFiles:
       - .idx
  snps_1000g:
    type: File
    secondaryFiles:
       - .idx
  cosmic:
    type: File
    secondaryFiles:
       - .idx
  group: string[]
  mutect_dcov: int
  mutect_rf: string[]
  covariates: string[]
  abra_scratch: string
  intervals: ['null', string]
  refseq: File
  opt_dup_pix_dist: string


  ########## NEW INPUTS ###############

  title_file: File
  sample_sheet:
    type:
      type: array
      items: File

  umi_length: string
  output_project_folder: string
  # todo - remove:
  outdir: string

  tmp_dir: string
  sort_order: string
  grouping_strategy: string
  min_mapping_quality: string
  tag_family_size_counts_output: string
  reference_fasta: File
  filter_min_reads: string
  filter_min_base_quality: string

  marianas_mismatches: string
  marianas_wobble: string

  coverage_threshold: string
  gene_list: string
  bed_file: string
  min_mapping_quality: string
  waltz_reference_fasta: string
  waltz_reference_fasta_fai: string

  # broken:
  md_output: string
  add_rg_output: string
  md_metrics_output: string
  fulcrum_output_filename_suffix: string
  marianas_output_filename_suffix: string

  ########## END NEW INPUTS ###############


outputs:

  standard_bams:
    type:
      type: array
      items: File
    secondaryFiles:
      - ^.bai
    outputSource: realignment/outbams

  standard_covint_list:
    type:
      type: array
      items: File
    outputSource: realignment/covint_list

  standard_covint_bed:
    type:
      type: array
      items: File
    outputSource: realignment/covint_bed

  clstats1:
    type:
      type: array
      items: File
    outputSource: mapping/clstats1

  clstats2:
    type:
      type: array
      items: File
    outputSource: mapping/clstats2

  md_metrics:
    type:
      type: array
      items: File
    outputSource: mapping/md_metrics

  fulcrum_bams:
    type:
      type: array
      items: File
    secondaryFiles:
      - ^.bai
    outputSource: module_1_post_fulcrum/bam

  marianas_bams:
    type:
      type: array
      items: File
    secondaryFiles:
      - ^.bai
    outputSource: module_1_post_fulcrum/bam

steps:
  mapping:
    run: module-1.scatter.chunk--mod.cwl
    in:
      # [read1, read1, read1]
      fastq1: fastq1
      # [read2, read2, read2]
      fastq2: fastq2
      adapter: adapter
      adapter2: adapter2
      bwa_output: bwa_output
      genome: genome
      add_rg_LB: add_rg_LB
      add_rg_PL: add_rg_PL
      add_rg_ID: add_rg_ID
      add_rg_PU: add_rg_PU
      add_rg_SM: add_rg_SM
      add_rg_CN: add_rg_CN
      tmp_dir: tmp_dir
      group: group
      opt_dup_pix_dist: opt_dup_pix_dist

      ########## NEW INPUTS ###############

      title_file: title_file
      sample_sheet: sample_sheet

      umi_length: umi_length
      output_project_folder: output_project_folder
      # todo - remove:
      outdir: outdir

      tmp_dir: tmp_dir
      sort_order: sort_order
      grouping_strategy: grouping_strategy
      min_mapping_quality: min_mapping_quality
      tag_family_size_counts_output: tag_family_size_counts_output
      reference_fasta: reference_fasta
      filter_min_reads: filter_min_reads
      filter_min_base_quality: filter_min_base_quality

      marianas_mismatches: marianas_mismatches
      marianas_wobble: marianas_wobble

      coverage_threshold: coverage_threshold
      gene_list: gene_list
      bed_file: bed_file
      min_mapping_quality: min_mapping_quality
      waltz_reference_fasta: waltz_reference_fasta
      waltz_reference_fasta_fai: waltz_reference_fasta_fai

      # broken:
      md_output: md_output
      add_rg_output: add_rg_output
      md_metrics_output: md_metrics_output
      fulcrum_output_filename_suffix: fulcrum_output_filename_suffix
      marianas_output_filename_suffix: marianas_output_filename_suffix

      ########## END NEW INPUTS ###############

    out: [clstats1, clstats2, bam, md_metrics]
    scatter: [
      sample_sheet,
      fastq1,
      fastq2,
      adapter,
      adapter2,
      bwa_output,
      add_rg_LB,
      add_rg_PL,

      add_rg_ID,
      add_rg_PU,

      add_rg_SM,
      add_rg_CN
      ]
    scatterMethod: dotproduct

  realignment:
    run: module-2.cwl
    in:
      bams: mapping/bam
      hapmap: hapmap
      dbsnp: dbsnp
      indels_1000g: indels_1000g
      snps_1000g: snps_1000g
      covariates: covariates
      abra_scratch: abra_scratch
      group: group
      genome: genome
    out: [outbams, covint_list, covint_bed]

  standard_waltz:
    run: ./waltz-workflow.cwl
    in:
      input_bam: realignment/outbams
      coverage_threshold: coverage_threshold
      gene_list: gene_list
      bed_file: bed_file
      min_mapping_quality: min_mapping_quality
      reference_fasta: waltz_reference_fasta
      reference_fasta_fai: waltz_reference_fasta_fai
    out: [waltz_output_files, pileup]
    scatter: [input_bam]
    scatterMethod: dotproduct


  ###########################
  # Collapsing with Fulcrum #
  ###########################

  fulcrum:
    run: ./fulcrum_workflow.cwl
    in:
      tmp_dir: tmp_dir
      input_bam: realignment/outbams
      sort_order: sort_order

      # Fulcrum group reads
      grouping_strategy: grouping_strategy
      min_mapping_quality: min_mapping_quality
      tag_family_size_counts_output: tag_family_size_counts_output

      # Fulcrum call duplex consensus reads
      reference_fasta: reference_fasta

      # Fulcrum filter reads
      filter_min_reads: filter_min_reads
      filter_min_base_quality: filter_min_base_quality
    out:
      [output_fastq_1, output_fastq_2]

  module_1_post_fulcrum:
    run: ./module-1.innovation.cwl
    in:
      # todo - adapter trimming again?
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
      tmp_dir: tmp_dir

      # broken:
      add_rg_output: add_rg_output
      md_output: md_output
      md_metrics_output: md_metrics_output
      output_filename_suffix: fulcrum_output_filename_suffix
    out:
      [bam, bai, md_metrics, clstats1, clstats2]


  fulcrum_waltz:
    run: ./waltz-workflow.cwl
    in:
      input_bam: module_1_post_fulcrum/bam
      coverage_threshold: coverage_threshold
      gene_list: gene_list
      bed_file: bed_file

      min_mapping_quality: min_mapping_quality
      reference_fasta: waltz_reference_fasta
      reference_fasta_fai: waltz_reference_fasta_fai

    out: [waltz_output_files]


  ############################
  # Collapsing with Marianas #
  ############################

  marianas:
    run: ./marianas_collapsing_workflow.cwl
    in:
      input_bam: realignment/outbams
      reference_fasta: reference_fasta
      pileup: standard_waltz/pileup
      mismatches: marianas_mismatches
      wobble: marianas_wobble

      output_dir: output_project_folder
    out:
      [output_fastq_1, output_fastq_2]

  module_1_post_marianas:
    run: ./module-1.innovation.cwl
    in:
      # todo - adapter trimming again?
      fastq1: marianas/output_fastq_1
      fastq2: marianas/output_fastq_2
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
      tmp_dir: tmp_dir

      # broken:
      add_rg_output: add_rg_output
      md_output: md_output
      md_metrics_output: md_metrics_output
      output_filename_suffix: marianas_output_filename_suffix

    out:
      [bam, bai, md_metrics, clstats1, clstats2]


  marianas_waltz:
    run: ./waltz-workflow.cwl
    in:
      input_bam: module_1_post_marianas/bam
      coverage_threshold: coverage_threshold
      gene_list: gene_list
      bed_file: bed_file

      min_mapping_quality: min_mapping_quality
      reference_fasta: waltz_reference_fasta
      reference_fasta_fai: waltz_reference_fasta_fai

    out: [waltz_output_files]
