#!/usr/bin/env cwl-runner

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
  doap:name: map_read_names_to_umis
  doap:revision: 1.0.0
- class: doap:Version
  doap:name: cwl-wrapper
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
    foaf:mbox: mailto:johnsonsi@mskcc.org

cwlVersion: v1.0

class: CommandLineTool

requirements:
    - class: ShellCommandRequirement

inputs:
  read_names:
    type: File

  output_mapped_filename:
    type: string

outputs:
  mapped_read_names:
    type: File
    outputBinding:
      glob: $(inputs.output_mapped_filename)

baseCommand: [cmo_fulcrum_map_umis_to_read_names]

arguments:
  - $(inputs.read_names)
  - $(inputs.output_mapped_filename)


# python /ifs/work/bergerm1/pererad1/ColonWeiserAnalysis/duplexUMI.py ${output_folder}/readNames.bed ${output_folder}/Duplex_UMI_for_readNames.fastq