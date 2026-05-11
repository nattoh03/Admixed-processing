#!/bin/bash

#SBATCH --job-name=FastQC_Fix

#SBATCH --output=logs/fastqc_%a.out

#SBATCH --error=logs/fastqc_%a.err

#SBATCH --partition=day

#SBATCH --nodes=1

#SBATCH --ntasks=1

#SBATCH --cpus-per-task=4

#SBATCH --mem=10G

#SBATCH --time=02:00:00

#SBATCH --array=0-18



# 1. Load Modules (Simplified names)

module load FastQC/0.12.1-Java-11

module load MultiQC/1.10.1-foss-2020b-Python-3.8.6



# 2. Define Paths

RAW_DIR="/home/gi64/palmer_scratch/admixed_reads/raw_reads"

TRIM_DIR="/home/gi64/palmer_scratch/admixed_reads/trimmed"

QC_OUT="/home/gi64/palmer_scratch/admixed_reads/fastqc_results"



mkdir -p "$QC_OUT"



# 3. Sample List

samples=(SRR11006665 SRR11006666 SRR11006667 SRR11006668 SRR11006669 SRR11006670 SRR11006672 SRR11006673 SRR11006674 SRR11006675 SRR11006676 SRR11006677 SRR11006678 SRR11006679 SRR11006680 SRR11006681 SRR11006683 SRR11006684 SRR11006685)



SAMPLE=${samples[$SLURM_ARRAY_TASK_ID]}



echo "Processing $SAMPLE"



# 4. Run FastQC on a single line to avoid backslash errors

# Added --extract to ensure it finishes writing before MultiQC runs

fastqc --noextract -t 4 -o "$QC_OUT" "${RAW_DIR}/${SAMPLE}_1.fastq.gz" "${RAW_DIR}/${SAMPLE}_2.fastq.gz" "${TRIM_DIR}/${SAMPLE}_1_trimmed.fastq.gz" "${TRIM_DIR}/${SAMPLE}_2_trimmed.fastq.gz"



# 5. MultiQC at the very end

if [ $SLURM_ARRAY_TASK_ID -eq 18 ]; then

    sleep 60

    multiqc "$QC_OUT" -o "$QC_OUT"

fi
