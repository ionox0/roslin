#echo "SortBam"
#java  -jar ${fgbio_jar}
#--tmp-dir=${scratch_dir}
#SortBam
#--input=${output_folder}/sample_with_UMI.bam
#--sort-order=Queryname
#--output ${output_folder}/sample_with_UMI_sorted.bam

cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_fulcrum_sort_bam]

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

  sort_order:
    type: File
    inputBinding:
      prefix: --sort_order

  output_bam_filename:
    type: string
    inputBinding:
      prefix: --output_bam_filename
