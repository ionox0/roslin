#!/bin/bash

# Process the given UMI bam file and generate collapsed fatsqs and stats

# $1 - UMI bam file to be processed

# $2 - normal pileup file corresponding to the bam file (made with correct bed file)

#export TMPDIR=/ifs/work/scratch

java="/opt/common/CentOS_6/java/jdk1.8.0_31/bin/java"
referenceFasta=~/resources/impact-GRCh37/Homo_sapiens_assembly19.fasta
mismatches="1"
wobble="2"

bam=$1

pileup=$2
# accomodate situations where pileup is not given
if [[ "$pileup" == "" ]]
then
	pileup="pileup-not-given"
fi


sample=`basename $bam`
sample=${sample/.bam}


# pass 1
echo -e "`date` Pass 1"
$java -server -Xms8g -Xmx8g -cp ~/software/Marianas.jar org.mskcc.marianas.umi.duplex.DuplexUMIBamToCollapsedFastqFirstPass $bam $pileup $mismatches $wobble $referenceFasta .


# sort the first pass output by mate position
echo -e "`date` Sorting first-pass.txt"
sort -S 8G -k 6,6n -k 8,8n first-pass.txt > first-pass.mate-position-sorted.txt

