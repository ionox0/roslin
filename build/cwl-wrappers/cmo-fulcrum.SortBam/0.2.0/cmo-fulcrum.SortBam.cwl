#echo "SortBam"

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
  doap:name: cmo-fulcrum.SortBam
  doap:revision: 0.5.0
- class: doap:Version
  doap:name: cmo-fulcrum.SortBam
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
#java  -jar ${fgbio_jar}
#--tmp-dir=${scratch_dir}
#SortBam
#--input=${output_folder}/sample_with_UMI.bam
#--sort-order=Queryname
#--output ${output_folder}/sample_with_UMI_sorted.bam

cwlVersion: cwl:v1.0

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 4
    coresMin: 1

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
