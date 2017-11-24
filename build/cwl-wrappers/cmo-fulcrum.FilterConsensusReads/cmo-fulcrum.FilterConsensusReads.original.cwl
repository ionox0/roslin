#java -jar ${fgbio_jar}
#--tmp-dir=${scratch_dir}
#FilterConsensusReads
#-i ${output_folder}/duplexConsensusReads_collapsed-sample_with_UMI_sorted_mateFixed_paired_mapQ20.bam
#-r /ifs/work/bergerm1/pererad1/impact-GRCh37/Homo_sapiens_assembly19.fasta
#-M=1
#-N=30
#-o ${output_folder}/filtered_duplexConsensusReads_collapsed-sample_with_UMI_sorted_mateFixed_paired_mapQ20_1-1.bam

cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_fulcrum.FilterConsensusReads]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

doc: |
  None

inputs:
  input_bam:
    type: string
    inputBinding:
      prefix: -i

  reference_fastq:
    type: File
    inputBinding:
      prefix: --r

  M:  # todo - research
    type: string
    inputBinding:
      prefix: -M

  N:  # todo - research
    type: string
    inputBinding:
      prefix: -N

  output_bam:
    type: string
    inputBinding:
      prefix: -o
