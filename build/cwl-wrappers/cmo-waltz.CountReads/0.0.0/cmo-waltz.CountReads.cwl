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
  doap:name: cmo-waltz.CountReads
  doap:revision: 0.0.0
- class: doap:Version
  doap:name: cmo-waltz.CountReads
  doap:revision: 0.0.0

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

cwlVersion: "cwl:v1.0"

class: CommandLineTool

# Example Waltz CountReads usage
#
# $java -server -Xms4g -Xmx4g -cp ~/software/Waltz.jar org.mskcc.juber.waltz.countreads.CountReads $bamFile $coverageThreshold $geneList $bedFile

baseCommand: [cmo_waltz_count_reads]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 4
    coresMin: 1

doc: |
  None

inputs:

  input_bam:
    type: File
    inputBinding:
      prefix: --input_bam

  coverage_threshold:
    type: string
    inputBinding:
      prefix: --coverage_threshold

  gene_list:
    type: File
    inputBinding:
      prefix: --gene_list

  bed_file:
    type: File
    inputBinding:
      prefix: --bed_file


# Example Waltz CountReads output files:
#
# fragment-sizes.txt
# MSK-L-007-bc-IGO-05500-DY-5_bc217_5500-DY-1_L000_mrg_cl_aln_srt_MD_IR_FX_BR.bam.covered-regions
# MSK-L-007-bc-IGO-05500-DY-5_bc217_5500-DY-1_L000_mrg_cl_aln_srt_MD_IR_FX_BR.bam.fragment-sizes
# MSK-L-007-bc-IGO-05500-DY-5_bc217_5500-DY-1_L000_mrg_cl_aln_srt_MD_IR_FX_BR.bam.read-counts
# read-counts.txt
# waltz-coverage.txt

outputs:

  fragment_sizes:
    type: File
    outputBinding:
      glob: 'fragment-sizes.txt'

  read_counts:
    type: File
    outputBinding:
      glob: 'read-counts.txt'

  waltz_coverage:
    type: File
    outputBinding:
      glob: 'waltz-coverage.txt'

  covered_regions:
    type: File
    outputBinding:
      glob: $(inputs.input_bam.basename + '.covered-regions')

  bam_fragment_sizes:
    type: File
    outputBinding:
      glob: $(inputs.input_bam.basename + '.fragment-sizes')

  bam_read_counts:
    type: File
    outputBinding:
      glob: $(inputs.input_bam.basename + '.read-counts')
