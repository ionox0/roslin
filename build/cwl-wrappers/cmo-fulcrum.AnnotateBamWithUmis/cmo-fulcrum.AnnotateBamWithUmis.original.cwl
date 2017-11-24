#java -jar ${fgbio_jar}
#--tmp-dir=${scratch_dir} AnnotateBamWithUmis
#-i ${input_bam}
#-f ${output_folder}/Duplex_UMI_for_readNames.fastq
#-o ${output_folder}/sample_with_UMI.bam

cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_fulcrum.AnnotateBamWithUMIs]

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

  output_fastq:
    type: string
    inputBinding:
      prefix: -f
