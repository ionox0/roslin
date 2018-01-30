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

  input_bams:
    type:
      type: array
      items: File


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
            - .idx
        cosmic:
          type: File
          secondaryFiles:
            - .idx
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

  pairs:
    type:
      type: array
      items:
        type: array
        items: string

  covint_bed:
    type:
      type: array
      items: File


  genome: string
  exac_filter:
    type:
      type: array
      items: File
  ref_fasta:
    type:
      type: array
      items: string
  vep_data:
    type:
      type: array
      items: string
  curated_bams:
    type:
      type: array
      items:
        type: array
        items: File
  ffpe_normal_bams:
    type:
      type: array
      items:
        type: array
        items: File
  hotspot_list:
    type:
      type: array
      items: File

outputs:

  maf:
    type: File
    outputSource: filter/maf

  fillout_maf:
    type: File
    outputSource: filter/portal_fillout


steps:

  pairing:
    run: sort-bams-by-pair/1.0.0/sort-bams-by-pair.cwl
    in:
      bams: input_bams
      pairs: pairs
      db_files: db_files
      runparams: runparams
      beds: covint_bed
    out: [tumor_bams, normal_bams, tumor_sample_ids, normal_sample_ids, dbsnp, cosmic, mutect_dcov, mutect_rf, refseq, genome, covint_bed]

  variant_calling:
    run: module-3.cwl
    in:
      tumor_bam: pairing/tumor_bams
      normal_bam: pairing/normal_bams
      genome: pairing/genome
      bed: pairing/covint_bed
      normal_sample_name: pairing/normal_sample_ids
      tumor_sample_name: pairing/tumor_sample_ids
      dbsnp: pairing/dbsnp
      cosmic: pairing/cosmic
      mutect_dcov: pairing/mutect_dcov
      mutect_rf: pairing/mutect_rf
      refseq: pairing/refseq
    out: [combine_vcf, facets_png, facets_txt, facets_out, facets_rdata, facets_seg, mutect_vcf, mutect_callstats, vardict_vcf, pindel_vcf]
    scatter: [tumor_bam, normal_bam, normal_sample_name, tumor_sample_name, genome, dbsnp, cosmic, refseq, mutect_rf, mutect_dcov, bed]
    scatterMethod: dotproduct

  parse_pairs:
    run: parse-pairs-and-vcfs/2.0.0/parse-pairs-and-vcfs.cwl
    in:
      bams: input_bams
      pairs: pairs
      combine_vcf: variant_calling/combine_vcf

      genome: genome
      exac_filter: exac_filter
      ref_fasta: ref_fasta
      vep_data: vep_data
      curated_bams: curated_bams
      ffpe_normal_bams: ffpe_normal_bams
      hotspot_list: hotspot_list

    out: [tumor_id, normal_id, srt_genome, srt_combine_vcf, srt_ref_fasta, srt_exac_filter, srt_vep_data, srt_bams, srt_curated_bams, srt_ffpe_normal_bams, srt_hotspot_list]

  filter:
    run: module-4.cwl
    in:
      bams: parse_pairs/srt_bams
      combine_vcf: parse_pairs/srt_combine_vcf
      genome: parse_pairs/srt_genome
      ref_fasta: parse_pairs/srt_ref_fasta
      exac_filter: parse_pairs/srt_exac_filter
      vep_data: parse_pairs/srt_vep_data
      tumor_sample_name: parse_pairs/tumor_id
      normal_sample_name: parse_pairs/normal_id
      curated_bams: parse_pairs/srt_curated_bams
      ffpe_normal_bams: parse_pairs/srt_ffpe_normal_bams
      hotspot_list: parse_pairs/srt_hotspot_list
    out: [maf, portal_fillout]
    scatter: [combine_vcf, tumor_sample_name, normal_sample_name, ref_fasta, exac_filter, vep_data]
    scatterMethod: dotproduct



#  gather_metrics:
#    run: module-5.cwl
#    in:
#      aa_bams: group_process/bams
#      runparams: runparams
#      db_files: db_files
#      bams:
#        valueFrom: ${ var output = [];  for (var i=0; i<inputs.aa_bams.length; i++) { output=output.concat(inputs.aa_bams[i]); } return output; }
#      genome: projparse/genome
#      bait_intervals: projparse/bait_intervals
#      target_intervals: projparse/target_intervals
#      fp_intervals: projparse/fp_intervals
#      fp_genotypes: projparse/fp_genotypes
#      md_metrics_files: group_process/md_metrics
#      trim_metrics_files: [ group_process/clstats1, group_process/clstats2]
#      project_prefix: projparse/project_prefix
#      grouping_file: projparse/grouping_file
#      request_file: projparse/request_file
#      pairing_file: projparse/pairing_file
#
#    out: [ as_metrics, hs_metrics, insert_metrics, insert_pdf, per_target_coverage, qual_metrics, qual_pdf, doc_basecounts, gcbias_pdf, gcbias_metrics, gcbias_summary, qc_files]
