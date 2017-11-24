#java -jar ${fgbio_jar}
#--tmp-dir=${scratch_dir}
#SetMateInformation
#-i ${output_folder}/sample_with_UMI_sorted.bam
#-o ${output_folder}/sample_with_UMI_sorted_mateFixed.bam

cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_fulcrum.SetMateInformation]

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
