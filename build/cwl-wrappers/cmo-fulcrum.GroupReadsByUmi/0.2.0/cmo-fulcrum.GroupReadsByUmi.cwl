#java -jar ${fgbio_jar}

#!/usr/bin/env/cwl-runner

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/
  doap: http://usefulinc.com/ns/doap#

$schemas:
- http://dublincore.org/2012/06/14/dcterms.rdf
- http://xmlns.com/foaf/spec/20140114.rdf
- http://usefulinc.com/ns/doap#

doap:release:
- class: doap:Version
  doap:name: cmo-fulcrum.GroupReadsByUmi
  doap:revision: 0.5.0
- class: doap:Version
  doap:name: cmo-fulcrum.GroupReadsByUmi
  doap:revision: 1.0.0

 dct:creator:
 - class: foaf:Organization
   foaf:name: Memorial Sloan Kettering Cancer Center
   foaf:member:
   - class: foaf:Person
     foaf:name: Ian Johnson
     foaf:mbox: mailto:johnsoni@mskcc.org

 dct:contributor:
 - class: foaf:Organization
   foaf:name: Memorial Sloan Kettering Cancer Center
   foaf:member:
   - class: foaf:Person
     foaf:name: Ian Johnson
     foaf:mbox: mailto:johnsoni@mskcc.org
#--tmp-dir=${scratch_dir}
#GroupReadsByUmi
#-s 'paired'
#-m 20
#-f ${output_folder}/Grouped-mapQ20-histogram
#-i ${output_folder}/sample_with_UMI_sorted_mateFixed.bam
#-o ${output_folder}/collapsed-sample_with_UMI_sorted_mateFixed_paired_mapQ20.bam


requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 4
    coresMin: 1
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
