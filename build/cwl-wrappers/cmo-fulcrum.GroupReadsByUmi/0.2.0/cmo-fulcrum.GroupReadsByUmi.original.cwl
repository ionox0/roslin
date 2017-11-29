#java -jar ${fgbio_jar}
#--tmp-dir=${scratch_dir}
#GroupReadsByUmi
#-s 'paired'
#-m 20
#-f ${output_folder}/Grouped-mapQ20-histogram
#-i ${output_folder}/sample_with_UMI_sorted_mateFixed.bam
#-o ${output_folder}/collapsed-sample_with_UMI_sorted_mateFixed_paired_mapQ20.bam

cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_fulcrum_group_reads_by_umi]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

doc: |
  None

inputs:
  tmp_dir:
    type: File
    inputBinding:
      prefix: --tmp_dir

  # todo - research
  something:
    type: string
    inputBinding:
      prefix: --something

  something_else:
    type: string
    inputBinding:
      prefix: --something_else

  something_else_else:
    type: File
    inputBinding:
      prefix: --something_else_else

  input_bam:
    type: File
    inputBinding:
      prefix: --input_bam

  output_bam_filename:
    type: string
    inputBinding:
      prefix: --output_bam_filename
