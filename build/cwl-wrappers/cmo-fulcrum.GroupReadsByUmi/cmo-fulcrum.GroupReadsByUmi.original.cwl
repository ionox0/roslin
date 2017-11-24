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

baseCommand: [cmo_fulcrum.GroupReadsByUmi]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

doc: |
  None

inputs:
  input_bam:
    type: string
    inputBinding:
      prefix: -i

  s:
    type: string
    inputBinding:
      prefix: --s

  m:
    type: string
    inputBinding:
      prefix: --m

  f: # todo - research
    type: File
    inputBinding:
      prefix: --f

  tmp_dir:
    type: File
    inputBinding:
      prefix: --tmp_dir

  output_bam:
    type: string
    inputBinding:
      prefix: -o
