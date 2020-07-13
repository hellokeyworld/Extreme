#!/bin/bash
#$ -S /bin/bash
#$ -cwd

REF=##human_hg19_reference
DATAPATH=##DataPah_located_BAMfiles
NORMAL=##Normal_BAM
TUMOR=##Tumor_BAM 
INTERVAL=$5
OUT=${TUMOR%%.bam*}
NID=##Normal ID 
TID=##Tumor ID

AnalysisPath=##Path_for_output/

###dbSMP b151
dbSNP=dbSNP_hg19.vcf.gz
###cosmic v86
COSMIC=cosmic_hg19.vcf.gz
gnomAD=GATK/bundle/Mutect2/af-only-gnomad.raw.sites.b37.chr_added.vcf.gz


## 0. contamination Calculate
gatk GetPileupSummaries \
-I $DATAPATH$TUMOR \
-V GATK/bundle/Mutect2/GetPileupSummaries/small_exac_common_3_b37.chr_added.vcf.gz \
-L GATK/bundle/Mutect2/GetPileupSummaries/small_exac_common_3_b37.chr_added.vcf.gz \
-O $AnalysisPath$OUT.getpileupsummaries.table

gatk CalculateContamination \
-I $AnalysisPath$OUT.getpileupsummaries.table \
-O $AnalysisPath$OUT.calculatecontamination.table


## 1. Mutect2 call
gatk Mutect2 \
-R $REF \
-I $DATAPATH$TUMOR \
-I $DATAPATH$NORMAL \
-tumor $TID \
-normal $NID \
-O $AnalysisPath$OUT.mutect2.vcf \
--germline-resource $gnomAD \
-mbq 30

## 2. Filter for confident somatic calls
gatk FilterMutectCalls \
--min-median-base-quality 30 \
--min-median-mapping-quality 30 \
--normal-artifact-lod 0.5 \
--max-events-in-region 50 \
--contamination-table $AnalysisPath$OUT.calculatecontamination.table \
-V $AnalysisPath$OUT.mutect2.vcf \
-O $AnalysisPath$OUT.mutect2.oncefiltered.vcf


## 3. Estimate artifacts
gatk CollectSequencingArtifactMetrics \
-I $DATAPATH$TUMOR \
-O $AnalysisPath$OUT.tumor_artifact \
--FILE_EXTENSION ".txt" \
-R $REF


## 4. Filter oritentation bias
gatk FilterByOrientationBias \
-V $AnalysisPath$OUT.mutect2.oncefiltered.vcf \
-P $AnalysisPath$OUT.tumor_artifact.pre_adapter_detail_metrics.txt \
-O $AnalysisPath$OUT.mutect2.twicefiltered.vcf

