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
  doap:name:
  doap:revision: 1.0.0
- class: doap:Version
  doap:name:
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
  InlineJavascriptRequirement: {}

inputs:
  umi_length: string
  output_project_folder: File
  # outdir: File

  reference_fastq: File
  bed_file: File

  bait_intervals: File
  target_intervals: File
  fp_intervals: File
  fp_genotypes: File
  grouping_file: File
  request_file: File
  pairing_file: File

  adapter: string
  adapter2: string

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

  groups:
    type:
      type: array
      items:
        type: array
        items: string

  pairs:
    type:
      type: array
      items:
        type: array
        items: string

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
          PU: string[]
          R1:
            type:
              type: array
              items: File
          R2:
            type:
              type: array
              items: File
          RG_ID: string[]
          adapter: string
          adapter2: string
          bwa_output: string

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


  cmo_process_umi_fastq:
    run: ./cmo-marianas.ProcessLoopUMIFastq/0.0.0/cmo-marianas.ProcessLoopUMIFastq.cwl
    in:
      r1_fastq: projparse/R1
      umi_length: umi_length
      output_project_folder: output_project_folder
    out: [processed_fastq_1, processed_fastq_2, composite_umi_frequencies, info, sample_sheet, umi_frequencies]
    scatter: [r1_fastq, umi_length, output_project_folder]
    scatterMethod: dotproduct


  mapping:
    run: module-1.scatter.cwl
    in:
      fastq1: cmo_process_umi_fastq/processed_fastq_1
      fastq2: cmo_process_umi_fastq/processed_fastq_2
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
    out: [clstats1, clstats2, bam, bai, md_metrics]
    scatter: [fastq1, fastq2, adapter, adapter2, bwa_output, add_rg_LB, add_rg_PL, add_rg_ID, add_rg_PU, add_rg_SM, add_rg_CN, tmp_dir]
    scatterMethod: dotproduct


  # todo - incorporate
#  cmo-picard.FixMateInformation:
#    run: ./cmo-picard.FixMateInformation/1.96/cmo-picard.FixMateInformation.cwl
#    in:
#      I:
#        source: cmo-picard.MarkDuplicates/bam
#        valueFrom: ${ return [self]; }
#      O: md_output
#      M: md_metrics_output
#      TMP_DIR: tmp_dir
#    out: [bam, bai, mdmetrics]


  cmo-waltz.CountReads:
    run: ./cmo-waltz.CountReads/0.0.0/cmo-waltz.CountReads.cwl
    in:
      bam_file:
        source: cmo-picard.FixMateInformation/bam
        valueFrom: ${ return [self]; }
      coverage_threshold: coverage_threshold
      gene_list: gene_list
      bed_file: bed_file
    out: [covered_regions, fragment_sizes, read_counts]

  cmo-waltz.PileupMetrics:
    run: ./cmo-waltz.PileupMetrics/0.0.0/cmo-waltz.PileupMetrics.cwl
    in:
      bam_file:
        source: cmo-picard.FixMateInformation/bam
        valueFrom: ${ return [self]; }
      minimum_mapping_quality: '20'
      reference_fasta_file: projparse/ref_fasta # todo - check
      intervals_bed_file: bed_file # todo - include in inputs^
    out: [intervals, intervals_without_duplicates, pileup]


  # QC #1 (Standard Bams)
  cmo-aggregate-bam-metrics:
    run: ./cmo-aggregate-bam-metrics/0.0.0/cmo-aggregate-bam-metrics.cwl
    in:
      # todo - need to specify folder? Can use current dir somehow?
      dummy_input: 'asdf'
    out: [fragment_sizes, read_counts, waltz_coverage, intervals_coverage_sum]


  # Collapsing (Marianas)
  # todo - merge into one subworkflow
  cmo-marianas.CollapseReadsFirstPass:
    run: ./cmo-marianas.DuplexUMIBamToCollapsedFastqFirstPass/0.0.0/cmo-marianas.DuplexUMIBamToCollapsedFastqFirstPass.cwl
    in:
      bam:
        source: cmo-picard.FixMateInformation/bam
        valueFrom: ${ return [self]; }
      pileup:
        source: cmo-waltz.PileupMetrics/pileup
      mismatches: '3'
      wobble: '2'
      reference_fasta: ref_fasta
      output_folder: '.'
    out: [bam]

  cmo-marianas.CollapseReadsSecondPass:
    run: ./cmo-marianas.DuplexUMIBamToCollapsedFastqSecondPass/0.0.0/cmo-marianas.DuplexUMIBamToCollapsedFastqSecondPass.cwl
    in:
      bam:
        source: cmo-marianas.CollapseReadsFirstPass/bam
        valueFrom: ${ return [self]; }
      pileup:
        source: cmo-waltz.PileupMetrics/pileup
      mismatches: '3'
      wobble: '2'
      reference_fasta: ref_fasta
      output_folder: '.'
    out: [bam]



# todo - need to figure these steps out:

# delete unnecessory files
# rm first-pass.mate-position-sorted.txt

# gzip
#echo -e "`date` Compressing fastqs"
#gzip collapsed_R1_.fastq
#gzip collapsed_R2_.fastq
#
#
## make collapsed bam
#echo -e "`date` Running juber-fastq-to-bam.sh "
#~/software/bin/juber-fastq-to-bam.sh collapsed_R1_.fastq.gz
#
## link in the FinalBams folder
#echo -e "`date` Linking bams"
#wd=`readlink -f .`
#cd ../FinalBams
#ln -s $wd/collapsed.bam $sample.bam
#ln -s $wd/collapsed.bai $sample.bai
#ln -s $wd/collapsed.bai $sample.bam.bai
#
#echo -e "`date` Done."



  # cmo-fulcrum.ProcessUMIBam:    ? todo


  # Collapsing (Fulcrum)
  cmo-fulcrum.AnnotateBamWithUMIs:
    run: ./cmo-fulcrum.AnnotateBamWithUMIs/0.0.0/cmo-fulcrum.AnnotateBamWithUMIs.cwl
    in:
      input_bam:
        source: cmo-picard.FixMateInformation/output_bam
        valueFrom: ${ return [self]; }
      tmp_dir: tmp_dir
      output_bam: sample_with_UMI.bam
      output_fastq: Duplex_UMI_for_readNames.fastq
    out: [output_bam]

  cmo-fulcrum.SortBam:
    run: ./cmo-fulcrum.SortBam/0.0.0/cmo-fulcrum.SortBam.cwl
    in:
      input_bam:
        source: cmo-fulcrum.AnnotateBamWithUMIs/output_bam
        valueFrom: ${ return [self]; }
      sort_order: Queryname
      tmp_dir: tmp_dir
      output_bam: sample_with_UMI_sorted.bam
    out: [output_bam]

  cmo-fulcrum.SetMateInformation:
    run: ./cmo-fulcrum.SetMateInformation/0.0.0/cmo-fulcrum.SetMateInformation.cwl
    in:
      input_bam:
        source: cmo-fulcrum.SortBam/output_bam
        valueFrom: ${ return [self]; }
      tmp_dir: tmp_dir
      output_bam: sample_with_UMI_sorted.bam
    out: [output_bam]

  cmo-fulcrum.GroupReadsByUmi:
    run: ./cmo-fulcrum.GroupReadsByUmi/0.0.0/cmo-fulcrum.GroupReadsByUmi.cwl
    in:
      input_bam:
        source: cmo-fulcrum.SetMateInformation/output_bam
        valueFrom: ${ return [self]; }
      s: paired
      m: 20
      f: ???? # todo - research
      tmp_dir: tmp_dir
      output_bam: collapsed-sample_with_UMI_sorted_mateFixed_paired_mapQ20.bam
    out: [output_bam]

  cmo-fulcrum.CallDuplexConsensusReads:
    run: ./cmo-fulcrum.CallDuplexConsensusReads/0.0.0/cmo-fulcrum.CallDuplexConsensusReads.cwl
    in:
      input_bam:
        source: cmo-fulcrum.GroupReadsByUmi/output_bam
        valueFrom: ${ return [self]; }
      tmp_dir: tmp_dir
      output_bam: duplexConsensusReads_collapsed-sample_with_UMI_sorted_mateFixed_paired_mapQ20.bam
    out: [output_bam]

  cmo-fulcrum.FilterConsensusReads:
    run: ./cmo-fulcrum.FilterConsensusReads/0.0.0/cmo-fulcrum.FilterConsensusReads.cwl
    in:
      input_bam:
        source: cmo-fulcrum.CallDuplexConsensusReads/output_bam
        valueFrom: ${ return [self]; }
      reference_fastq: reference_fastq
      M: 1
      N: 30
      output_bam: filtered_duplexConsensusReads_collapsed-sample_with_UMI_sorted_mateFixed_paired_mapQ20_1-1.bam
      tmp_dir: tmp_dir
    out: [output_bam]


  # todo - need this?:
  #    cmo-fulcrum.ProcessUMIBam:


  # Turn the Collapsed Fastq into a Collapsed Bam (Why do we need to trim again?)
  mapping:
    run: module-1.scatter.cwl
    in:
      fastq1: cmo_process_umi_fastq/processed_fastq_1
      fastq2: cmo_process_umi_fastq/processed_fastq_2
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
    out: [clstats1, clstats2, bam, bai, md_metrics]
    scatter: [fastq1, fastq2, adapter, adapter2, bwa_output, add_rg_LB, add_rg_PL, add_rg_ID, add_rg_PU, add_rg_SM, add_rg_CN, tmp_dir]
    scatterMethod: dotproduct


# todo - incorporate this
#  cmo-picard.FixMateInformation:
#    run: ./cmo-picard.FixMateInformation/1.96/cmo-picard.FixMateInformation.cwl
#    in:
#      I:
#        source: cmo-picard.MarkDuplicates/bam
#        valueFrom: ${ return [self]; }
#      O: md_output
#      M: md_metrics_output
#      TMP_DIR: tmp_dir
#    out: [bam, bai, mdmetrics]


  # Run Waltz #2
  cmo-waltz.CountReads:
    run: ./cmo-waltz.CountReads/0.0.0/cmo-waltz.CountReads.cwl
    in:
      I:
        source: cmo-picard.AddOrReplaceReadGroups/bam
        valueFrom: ${ return [self]; }
      O: md_output
      M: md_metrics_output
      TMP_DIR: tmp_dir
    out: [bam,bai,mdmetrics]

  cmo-waltz.PileupMetrics:
    run: ./cmo-waltz.PileupMetrics/0.0.0/cmo-waltz.PileupMetrics.cwl
    in:
      I:
        source: cmo-picard.AddOrReplaceReadGroups/bam
        valueFrom: ${ return [self]; }
      O: md_output
      M: md_metrics_output
      TMP_DIR: tmp_dir
    out: [bam,bai,mdmetrics]


  # QC #2 (Collapsed)
  cmo-aggregate-bam-metrics:
    run: ./cmo-aggregate-bam-metrics/0.0.0/cmo-aggregate-bam-metrics.cwl
    in:
      # todo - need to specify folder? Can use current dir somehow?
      dummy_input: 'asdf'
    out: [fragment_sizes, read_counts, waltz_coverage, intervals_coverage_sum]

  cmo-tables-module:
    run: ./cmo-tables-module/0.0.0/cmo-tables-module.cwl
    in:
      sp: '.'     # todo - what will be the actual output dir?
      m: '.'
    out: [fragment_sizes, read_counts, waltz_coverage, gc_bias_all_samples, gc_bias_each_sample, gc_bias_with_coverage, insert_size_peaks, read_counts_agg, read_counts_total]

  cmo-plotting-module:
    run: ./cmo-plotting-module/0.0.0/cmo-plotting-module.cwl
    in:
      input_waltz: '.'
      input_tables: '.'
      output_folder: '.'
    out: [plots]


outputs:
#  bam:
#    type: File
#    outputSource: cmo-picard.MarkDuplicates/bam
#
#  bai:
#    type: File
#    outputSource: cmo-picard.MarkDuplicates/bai

  plots:
    type: File
    outputSource: cmo-plotting-module/plots
