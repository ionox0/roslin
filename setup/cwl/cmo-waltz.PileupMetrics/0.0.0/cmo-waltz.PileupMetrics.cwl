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
  doap:name: cmo-waltz.PileupMetrics
  doap:revision: 0.0.0
- class: doap:Version
  doap:name: cmo-waltz.PileupMetrics
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

# Example Waltz PileupMetrics usage:
#
# $java -server -Xms4g -Xmx4g -cp ~/software/Waltz.jar org.mskcc.juber.waltz.Waltz PileupMetrics 20 $bamFile $referenceFasta $bedFile

baseCommand: [cmo_waltz_pileup_metrics]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-jar"]

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 4
    coresMin: 1

doc: |
  None

inputs:

  min_mapping_quality:
    type: string
    inputBinding:
      prefix: --min_mapping_quality

  input_bam:
    type: File
    inputBinding:
      prefix: --input_bam

  reference_fasta:
    type: File
    inputBinding:
      prefix: --reference_fasta

  bed_file:
    type: string
    inputBinding:
      prefix: --bed_file


# Example Waltz PileupMetrics output files:
#
# MSK-L-007-bc-IGO-05500-DY-5_bc217_5500-DY-1_L000_mrg_cl_aln_srt_MD_IR_FX_BR-pileup.txt
# MSK-L-007-bc-IGO-05500-DY-5_bc217_5500-DY-1_L000_mrg_cl_aln_srt_MD_IR_FX_BR-pileup-without-duplicates.txt
# MSK-L-007-bc-IGO-05500-DY-5_bc217_5500-DY-1_L000_mrg_cl_aln_srt_MD_IR_FX_BR-intervals.txt
# MSK-L-007-bc-IGO-05500-DY-5_bc217_5500-DY-1_L000_mrg_cl_aln_srt_MD_IR_FX_BR-intervals-without-duplicates.txt

outputs:

  pileup:
    type: File
    outputBinding:
      glob: $(inputs.input_bam.basename.replace('.bam', '') + '-pileup.txt')

  pileup_without_duplicates:
    type: File
    outputBinding:
      glob: $(inputs.input_bam.basename.replace('.bam', '') + '-pileup_without_duplicates.txt')

  intervals:
    type: File
    outputBinding:
      glob: $(inputs.input_bam.basename.replace('.bam', '') + '-intervals')

  intervals_without_duplicates:
    type: File
    outputBinding:
      glob: $(inputs.input_bam.basename.replace('.bam', '') + '-intervals-without-duplicates')