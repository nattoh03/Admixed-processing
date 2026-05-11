#!/bin/bash

#SBATCH --partition=day

#SBATCH --job-name=GATK_HC

#SBATCH --qos=normal

#SBATCH --array=0-18

#SBATCH --nodes=1

#SBATCH --ntasks=1

#SBATCH --cpus-per-task=8

#SBATCH --mem=32G

#SBATCH --time=24:00:00

#SBATCH --output=logs/gatk_%a.out

#SBATCH --error=logs/gatk_%a.err



# Stop on any error

set -e



# Load GATK

module load GATK/4.6.2.0-GCCcore-13.3.0-Java-17



# 1. Define paths - Using absolute path or $HOME for reliability

# Replace 'gi64' with your actual username if $HOME isn't preferred

REF="/home/gi64/palmer_scratch/admixed_reads/kayabomu/ref_index/GCF_002204515.2_AaegL5.0_genomic.fna"

BAM_DIR="/home/gi64/palmer_scratch/admixed_reads/kayabomu/aligned"

VCF_DIR="/home/gi64/palmer_scratch/admixed_reads/kayabomu/variants"



mkdir -p $VCF_DIR

mkdir -p logs



# 2. Get sample name from your BAM list

# We use an absolute path here as well to avoid array mapping issues

SAMPLES=($(ls $HOME/palmer_scratch/admixed_reads/aligned/*_final.bam))

CURRENT_BAM=${SAMPLES[$SLURM_ARRAY_TASK_ID]}

SAMPLE_NAME=$(basename $CURRENT_BAM _final.bam)



echo "Processing Sample: $SAMPLE_NAME"

echo "BAM path: $CURRENT_BAM"



# 3. Run HaplotypeCaller in GVCF mode

# GVCF mode allows for joint genotyping later

gatk --java-options "-Xmx24g -XX:ParallelGCThreads=2" HaplotypeCaller \

    -R "$REF" \

    -I "$CURRENT_BAM" \

    -O "${VCF_DIR}/${SAMPLE_NAME}.g.vcf.gz" \

    -ERC GVCF \

    --native-pair-hmm-threads 8
