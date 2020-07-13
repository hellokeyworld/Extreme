#!/bin/sh
#$ -S /bin/bash
#$ -cwd


##EXCAVATOR 

##TargetPerla module
perl TargetPerla.pl \
SourceTarget.txt \
'yourbedfile.bed' \
'folder_name' \
50000 \
hg19


##EXCAVATORDataPrepare module
perl EXCAVATORDataPrepare.pl \
'Prepare_input.txt' \
--processors 16 \
--target 'folder_name' \
--assembly hg19 \
--mapq 30


##EXCAVATORDataAnalysis module
perl EXCAVATORDataAnalysis.pl \
'Analysis_input.txt' \
--processors 8 \
--target 'folder_name' \
--assembly hg19 \
--output 'output_path' \
--mode pair


