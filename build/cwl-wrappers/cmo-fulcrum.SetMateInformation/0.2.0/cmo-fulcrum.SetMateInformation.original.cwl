#java -jar ${fgbio_jar}
#--tmp-dir=${scratch_dir}
#SetMateInformation
#-i ${output_folder}/sample_with_UMI_sorted.bam
#-o ${output_folder}/sample_with_UMI_sorted_mateFixed.bam

cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_fulcrum_set_mate_information]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

doc: |
  None

inputs:
  tmp_dir:
    type: File
    inputBinding:
      prefix: --tmp_dir

  input_bam:
    type: File
    inputBinding:
      prefix: --input_bam

  output_bam_filename:
    type: string
    inputBinding:
      prefix: --output_bam_filename
