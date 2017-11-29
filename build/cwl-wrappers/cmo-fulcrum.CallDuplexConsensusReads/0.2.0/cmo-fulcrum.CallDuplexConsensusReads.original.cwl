#java -jar ${fgbio_jar}
#--tmp-dir=${scratch_dir}
#CallDuplexConsensusReads
#-i ${output_folder}/collapsed-sample_with_UMI_sorted_mateFixed_paired_mapQ20.bam
#-o ${output_folder}/duplexConsensusReads_collapsed-sample_with_UMI_sorted_mateFixed_paired_mapQ20.bam

cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_fulcrum_call_duplex_consensus_reads]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

doc: |
  None

inputs:
  tmp_dir:
    type: string      # todo - directory?
    inputBinding:
      prefix: --tmp_dir

  input_bam:
    type: File
    inputBinding:
      prefix: --input_bam

  output_bam:
    type: string
    inputBinding:
      prefix: --output_bam_filename
