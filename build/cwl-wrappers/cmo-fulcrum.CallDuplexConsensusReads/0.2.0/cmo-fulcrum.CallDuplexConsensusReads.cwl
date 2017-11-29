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
  doap:name: cmo-fulcrum.CallDuplexConsensusReads
  doap:revision: 0.5.0
- class: doap:Version
  doap:name: cmo-fulcrum.CallDuplexConsensusReads
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
#CallDuplexConsensusReads
#-i ${output_folder}/collapsed-sample_with_UMI_sorted_mateFixed_paired_mapQ20.bam
#-o ${output_folder}/duplexConsensusReads_collapsed-sample_with_UMI_sorted_mateFixed_paired_mapQ20.bam

cwlVersion: cwl:v1.0

class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 4
    coresMin: 1

baseCommand: [cmo_fulcrum_call_duplex_consensus_reads]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

doc: |
  None

inputs:
  tmp_dir:
    type: string      # todo - directory?
    inputBinding:
      prefix: --tmp_dir

  input_bam:
    type: File
    inputBinding:
      prefix: --input_bam

  output_bam:
    type: string
    inputBinding:
      prefix: --output_bam_filename
