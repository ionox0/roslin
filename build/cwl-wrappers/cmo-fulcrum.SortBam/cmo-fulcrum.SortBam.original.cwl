#echo "SortBam"
#java  -jar ${fgbio_jar}
#--tmp-dir=${scratch_dir}
#SortBam
#--input=${output_folder}/sample_with_UMI.bam
#--sort-order=Queryname
#--output ${output_folder}/sample_with_UMI_sorted.bam

cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_fulcrum.SortBam]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

doc: |
  None

inputs:
  input_bam:
    type: string
    inputBinding:
      prefix: --input

  sort_order:
    type: File
    inputBinding:
      prefix: --sort-order

  tmp_dir:
    type: File
    inputBinding:
      prefix: --tmp_dir

  output_bam:
    type: string
    inputBinding:
      prefix: --output
