#!/bin/bash

# Process the given UMI bam file and generate collapsed fatsqs and stats
# $1 - UMI bam file to be processed
# $2 - normal pileup file corresponding to the bam file (made with correct bed file)

#export TMPDIR=/ifs/work/scratch

#java="/opt/common/CentOS_6/java/jdk1.8.0_31/bin/java"
#referenceFasta=~/resources/impact-GRCh37/Homo_sapiens_assembly19.fasta
#mismatches="1"
#wobble="2"
#
#bam=$1
#
#pileup=$2
## accomodate situations where pileup is not given
#if [[ "$pileup" == "" ]]
#then
#	pileup="pileup-not-given"
#fi
#
#sample=`basename $bam`
#sample=${sample/.bam}
#
#
#...
#
## pass 2
#echo -e "`date` Pass 2"
#$java -server -Xms8g -Xmx8g -cp ~/software/Marianas.jar org.mskcc.marianas.umi.duplex.DuplexUMIBamToCollapsedFastqSecondPass $bam $pileup $mismatches $wobble $referenceFasta .


cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_marianas_collapsing_second_pass]

arguments: ["-server", "-Xms8g", "-Xmx8g", "-cp"]

doc: |
  None

inputs:
  bam_file:
    type: File
    inputBinding:
      position: 1

  pileup:
    type: File
    inputBinding:
      position: 2

  mismatches:
    type: String
    inputBinding:
      position: 3

  wobble:
    type: File
    inputBinding:
      position: 4

  reference_fasta:
    type: File
    inputBinding:
      position: 5

  output_folder:
    type: string
    inputBinding:
      position: 6

#
## delete unnecessory files
## rm first-pass.mate-position-sorted.txt
#
## gzip
#echo -e "`date` Compressing fastqs"
#gzip collapsed_R1_.fastq
#gzip collapsed_R2_.fastq
#
#
## make collapsed bam
#echo -e "`date` Running juber-fastq-to-bam.sh "
#~/software/bin/juber-fastq-to-bam.sh collapsed_R1_.fastq.gz
#
## link in the FinalBams folder
#echo -e "`date` Linking bams"
#wd=`readlink -f .`
#cd ../FinalBams
#ln -s $wd/collapsed.bam $sample.bam
#ln -s $wd/collapsed.bai $sample.bai
#ln -s $wd/collapsed.bai $sample.bam.bai
#
#echo -e "`date` Done."
