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
  doap:name: cmo-fulcrum.FilterConsensusReads
  doap:revision: 0.5.0
- class: doap:Version
  doap:name: cmo-fulcrum.FilterConsensusReads
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
#FilterConsensusReads
#-i ${output_folder}/duplexConsensusReads_collapsed-sample_with_UMI_sorted_mateFixed_paired_mapQ20.bam
#-r /ifs/work/bergerm1/pererad1/impact-GRCh37/Homo_sapiens_assembly19.fasta
#-M=1
#-N=30
#-o ${output_folder}/filtered_duplexConsensusReads_collapsed-sample_with_UMI_sorted_mateFixed_paired_mapQ20_1-1.bam


requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 4
    coresMin: 1
cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_fulcrum_filter_consensus_reads]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

doc: |
  None

inputs:
  tmp_dir:
    type: string
    inputBinding:
      prefix: --tmp_dir

  input_bam:
    type: File
    inputBinding:
      prefix: --input_bam

  reference_fasta:
    type: File
    inputBinding:
      prefix: --reference_fasta

  something:  # todo - research
    type: string
    inputBinding:
      prefix: --something

  something_else:
    type: string
    inputBinding:
      prefix: --something_else

  output_bam:
    type: string
    inputBinding:
      prefix: --output_bam_filename
