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
  doap:name: module-3
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


- id: create_read_names_file
  class: CommandLineTool

  requirements:
      - class: ShellCommandRequirement

  inputs:
    input_bam:
      type: File

    output_read_names_filename:
      type: string

  outputs:
    read_names:
      type: File
      outputBinding:
        glob: $(inputs.output_read_names_filename)

  baseCommand: [samtools]

  arguments:
    - view
    - $(inputs.input_bam)
    - '|'
    - awk
    - '{print $1 "\t" $3 "\t" $4 "\t" $4+length($10)-1}'
    - '>'
    - $(inputs.output_read_names_filename)


- id: map_umis_to_read_names
  class: CommandLineTool

  requirements:
      - class: ShellCommandRequirement

  inputs:
    read_names:
      type: string

    output_fastq_filename:
      type: string

  outputs:
    output_fastq:
      type: File
      outputBinding:
        glob: $(inputs.output_fastq_filename)

  baseCommand: [cmo_fulcrum_map_read_names_to_umis]

  arguments:
    - $(inputs.read_names)
    - $(inputs.output_fastq_filename)


- id: main
  class: Workflow
  inputs:
    input_bam: File
    output_read_names_filename: string
    output_fastq_filename: string

  outputs:
    output_fastq:
      type: File
      outputSource: step2/output_fastq

  steps:
    create_read_names_file:
      in:
        input_bam: input_bam
        output_read_names_filename: output_read_names_filename
      out: [ read_names ]
      run: "#create_read_names_file"

    map_umis_to_read_names:
      in:
        read_names: create_read_names_file/read_names
        output_fastq_filename: output_fastq_filename
      out: [ output_fastq ]
      run: "#map_umis_to_read_names"
