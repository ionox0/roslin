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
  doap:name: project-workflow
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
  - class: foaf:Person
    foaf:name: Nikhil Kumar
    foaf:mbox: mailto:kumarn1@mskcc.org

cwlVersion: v1.0

class: Workflow
requirements:
  MultipleInputFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  db_files:
    type:
      type: record
      fields:
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
            - ".idx"
        cosmic:
          type: File
          secondaryFiles:
            - ".idx"
        refseq: File
        ref_fasta: string
        vep_data: string
        exac_filter:
          type: File
          secondaryFiles:
            - .tbi
        hotspot_list: File
        curated_bams:
          type:
            type: array
            items: File
          secondaryFiles:
              - ^.bai
        ffpe_normal_bams:
          type:
            type: array
            items: File
          secondaryFiles:
              - ^.bai
        bait_intervals: File
        target_intervals: File
        fp_intervals: File
        fp_genotypes: File
        grouping_file: File
        request_file: File
        pairing_file: File

  groups:
    type:
      type: array
      items:
        type: array
        items: string
  runparams:
    type:
      type: record
      fields:
        abra_scratch: string
        covariates:
          type:
            type: array
            items: string
        emit_original_quals: boolean
        genome: string
        mutect_dcov: int
        mutect_rf:
          type:
            type: array
            items: string
        num_cpu_threads_per_data_thread: int
        num_threads: int
        tmp_dir: string
        project_prefix: string
        opt_dup_pix_dist: string
  samples:
    type:
      type: array
      items:
        type: record
        fields:
          CN: string
          LB: string
          ID: string
          PL: string

          R1:
            type:
              type: array
              items: File
          R2:
            type:
              type: array
              items: File

          # todo - revert ID and PU back to string[]
          RG_ID: string
          PU: string

          adapter: string
          adapter2: string
          bwa_output: string
  pairs:
    type:
      type: array
      items:
        type: array
        items: string

  ########## NEW STUFF ###############

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


  # broken
  md_output: string
  add_rg_output: string
  md_metrics_output: string
  fulcrum_output_filename_suffix: string
  marianas_output_filename_suffix: string

  ########## END NEW STUFF ###############

outputs:

  standard_bams:
    type:
      type: array
      items: File
    secondaryFiles:
      - ^.bai
    outputSource: group_process/standard_bams

  fulcrum_bams:
    type:
      type: array
      items: File
    secondaryFiles:
      - ^.bai
    outputSource: group_process/fulcrum_bams

  marianas_bams:
    type:
      type: array
      items: File
    secondaryFiles:
      - ^.bai
    outputSource: group_process/marianas_bams

  standard_maf:
    type: File
    outputSource: other_steps_standard/maf

  fulcrum_maf:
    type: File
    outputSource: other_steps_fulcrum/maf

  marianas_maf:
    type: File
    outputSource: other_steps_marianas/maf

steps:

  projparse:
    run: parse-project-yaml-input/1.0.0/parse-project-yaml-input.cwl
    in:
      db_files: db_files
      groups: groups
      pairs: pairs
      samples: samples
      runparams: runparams
    out: [R1, R2, adapter, adapter2, bwa_output, LB, PL, RG_ID, PU, ID, CN, genome, tmp_dir, abra_scratch, cosmic, covariates, dbsnp, hapmap, indels_1000g, mutect_dcov, mutect_rf, refseq, snps_1000g, ref_fasta, exac_filter, vep_data, curated_bams, ffpe_normal_bams, hotspot_list, group_ids, target_intervals, bait_intervals, fp_intervals, fp_genotypes, request_file, pairing_file, grouping_file, project_prefix, opt_dup_pix_dist]

  group_process:
    run:  module-1-2.chunk--mod.cwl
    in:
      ########## Innovation Inputs ###############

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

      ########## END Innovation Inputs ###############

      fastq1: projparse/R1
      fastq2: projparse/R2
      adapter: projparse/adapter
      adapter2: projparse/adapter2
      bwa_output: projparse/bwa_output
      add_rg_LB: projparse/LB
      add_rg_PL: projparse/PL

      # arrays:
      add_rg_ID: projparse/RG_ID
      add_rg_PU: projparse/PU

      add_rg_SM: projparse/ID
      add_rg_CN: projparse/CN
      tmp_dir: projparse/tmp_dir
      hapmap: projparse/hapmap
      dbsnp: projparse/dbsnp
      indels_1000g: projparse/indels_1000g
      cosmic: projparse/cosmic
      snps_1000g: projparse/snps_1000g
      genome: projparse/genome
      mutect_dcov: projparse/mutect_dcov
      mutect_rf: projparse/mutect_rf
      covariates: projparse/covariates
      abra_scratch: projparse/abra_scratch
      refseq: projparse/refseq
      group: projparse/group_ids
      opt_dup_pix_dist: projparse/opt_dup_pix_dist

    out: [
      standard_bams,
      standard_covint_list,
      standard_covint_bed,
      clstats1,
      clstats2,
      md_metrics,
      fulcrum_bams,
      fulcrum_covint_list,
      fulcrum_covint_bed,
      marianas_bams,
      marianas_covint_list,
      marianas_covint_bed
    ]
    scatter: [fastq1,fastq2,adapter,adapter2,bwa_output,add_rg_LB,add_rg_PL,add_rg_ID,add_rg_PU,add_rg_SM,add_rg_CN, tmp_dir, abra_scratch, dbsnp, hapmap, indels_1000g, cosmic, snps_1000g, mutect_dcov, mutect_rf, abra_scratch, refseq, covariates, group]
    scatterMethod: dotproduct

  other_steps_standard:
    run: other-steps.cwl
    in:
      bams: group_process/standard_bams
      pairs: pairs
      db_files: db_files
      runparams: runparams
      beds: group_process/standard_covint_bed
      genome: projparse/genome
      exac_filter: projparse/exac_filter
      ref_fasta: projparse/ref_fasta
      vep_data: projparse/vep_data
      curated_bams: projparse/curated_bams
      ffpe_normal_bams: projparse/ffpe_normal_bams
      hotspot_list: projparse/hotspot_list

    out: [maf]

  other_steps_fulcrum:
    run: other-steps.cwl
    in:
      bams: group_process/fulcrum_bams
      pairs: pairs
      db_files: db_files
      runparams: runparams
      beds: group_process/fulcrum_covint_bed
      genome: projparse/genome
      exac_filter: projparse/exac_filter
      ref_fasta: projparse/ref_fasta
      vep_data: projparse/vep_data
      curated_bams: projparse/curated_bams
      ffpe_normal_bams: projparse/ffpe_normal_bams
      hotspot_list: projparse/hotspot_list

    out: [maf]

  other_steps_marianas:
    run: other-steps.cwl
    in:
      bams: group_process/marianas_bams
      pairs: pairs
      db_files: db_files
      runparams: runparams
      beds: group_process/marianas_covint_bed
      genome: projparse/genome
      exac_filter: projparse/exac_filter
      ref_fasta: projparse/ref_fasta
      vep_data: projparse/vep_data
      curated_bams: projparse/curated_bams
      ffpe_normal_bams: projparse/ffpe_normal_bams
      hotspot_list: projparse/hotspot_list

    out: [maf]
