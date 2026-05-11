#!/bin/bash

#SBATCH --job-name=fastqc

#SBATCH --output=fastqc_%a.out

#SBATCH --error=logs/fastqc_%a.err

#SBATCH --partition=day

#SBATCH --nodes=1

#SBATCH --ntasks=1

#SBATCH --cpus-per-task=4

#SBATCH --mem=10G

#SBATCH --time=02:00:00

#SBATCH --array=0-33



# 1. Load Modules (Simplified names)

module load FastQC/0.12.1-Java-11

module load MultiQC/1.10.1-foss-2020b-Python-3.8.6



# 2. Define Paths

RAW_DIR="/home/gi64/palmer_scratch/admixed_reads/raw_rabai"

TRIM_DIR="/home/gi64/palmer_scratch/admixed_reads/trimmed_rabai"

QC_OUT="/home/gi64/palmer_scratch/admixed_reads/fastqc_rabai2"



mkdir -p "$QC_OUT"



# 3. Sample List

samples=(SRR11006634 SRR11006635 SRR11006636 SRR11006637 SRR11006638 SRR11006639 SRR11006640 SRR11006641 SRR11006642 SRR11006643 SRR11006644 SRR11006645 SRR11006646 SRR11006647 SRR11006648 SRR11006649 SRR11006786 SRR11006936 SRR11006937 SRR11006938 SRR11006940 SRR11006941 SRR11006942 SRR11006943 SRR11006945 SRR11006946 SRR11006947 SRR11006948 SRR11006949 SRR11006950 SRR11006951 SRR11006952 SRR11006953 SRR11006954)


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

done

echo "completed task"
