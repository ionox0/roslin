cwlVersion: cmo-fulcrum.AnnotateBamWithUmis.original.cmo-fulcrum.CallDuplexConsensusReads.original.cmo-fulcrum.FilterConsensusReads.original.cmo-fulcrum.GroupReadsByUmi.original.cmo-fulcrum.SetMateInformation.original.cmo-fulcrum.SortBam.original.cwl:v1.0

#!/usr/bin/env/cmo-fulcrum.AnnotateBamWithUmis.original.cmo-fulcrum.CallDuplexConsensusReads.original.cmo-fulcrum.FilterConsensusReads.original.cmo-fulcrum.GroupReadsByUmi.original.cmo-fulcrum.SetMateInformation.original.cmo-fulcrum.SortBam.original.cwl-runner

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
  doap:name: waltz-pileup-metrics
  doap:revision: 0.5.0
- class: doap:Version
  doap:name: cmo-fulcrum.AnnotateBamWithUmis.original.cmo-fulcrum.CallDuplexConsensusReads.original.cmo-fulcrum.FilterConsensusReads.original.cmo-fulcrum.GroupReadsByUmi.original.cmo-fulcrum.SetMateInformation.original.cmo-fulcrum.SortBam.original.cwl-wrapper
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

class: CommandLineTool

baseCommand:
- cmo_waltz_pileup_metrics
- PileupMetrics         # todo - correct syntax?

arguments: ["-server", "-Xms4g", "-Xmx4g", "-cp"]

# get coverage and other metrics from Waltz
# $java -server -Xms4g -Xmx4g -cp ~/software/Waltz.jar org.mskcc.juber.waltz.Waltz PileupMetrics 20 $bamFile $referenceFasta $bedFile

doc: |

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 4
    coresMin: 1
  None

inputs:

  minimum_mapping_quality:
    type: String
    inputBinding:
      prefix: --minimum_mapping_quality

  bam_file:
    type: File
    inputBinding:
      prefix: --bam_file

  reference_fasta_file:
    type: File
    inputBinding:
      prefix: --reference_fasta_file

  intervals_bed_file:
    type: File
    inputBinding:
      prefix: --intervals_bed_file

outputs:
  intervals:
    type: File
    outputBinding:
      glob: ${ return "**/" + inputs.r1_fastq.basename.replace(".bam", "-intervals.txt") }

  intervals_without_duplicates:
    type: File
    outputBinding:
      glob: ${ return "**/" + inputs.r1_fastq.basename.replace(".bam", "-intervals-without-duplicates.txt") }

  pileup:
    type: File
    outputBinding:
      glob: ${ return "**/" + inputs.r1_fastq.basename.replace(".bam", "-pileup.txt") }



# Example outputs:
#
# BG742590-N_bc510_DummyPool_L000_mrg_cl_aln_srt_MD_IR_FX_BR.bam--small-intervals.txt
# BG742590-N_bc510_DummyPool_L000_mrg_cl_aln_srt_MD_IR_FX_BR.bam--small-intervals-without-duplicates.txt
# BG742590-N_bc510_DummyPool_L000_mrg_cl_aln_srt_MD_IR_FX_BR.bam--small-pileup.txt
