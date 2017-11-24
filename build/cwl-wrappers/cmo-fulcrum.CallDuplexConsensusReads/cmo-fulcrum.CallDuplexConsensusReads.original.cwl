#java -jar ${fgbio_jar}
#--tmp-dir=${scratch_dir}
#CallDuplexConsensusReads
#-i ${output_folder}/collapsed-sample_with_UMI_sorted_mateFixed_paired_mapQ20.bam
#-o ${output_folder}/duplexConsensusReads_collapsed-sample_with_UMI_sorted_mateFixed_paired_mapQ20.bam

cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_fulcrum.CallDuplexConsensusReads]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

doc: |
  None

inputs:
  input_bam:
    type: string
    inputBinding:
      prefix: -i

  tmp_dir:
    type: File
    inputBinding:
      prefix: --tmp_dir

  output_bam:
    type: string
    inputBinding:
      prefix: -o
