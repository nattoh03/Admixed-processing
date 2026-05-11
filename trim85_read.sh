#!/bin/bash

#SBATCH --job-name=trim_Rabai

#SBATCH --output=trim_rabai_%j.log

#SBATCH --error=trim_rabai_%j.err

#SBATCH --partition=day

#SBATCH --qos=normal

#SBATCH --nodes=1

#SBATCH --ntasks=1

#SBATCH --cpus-per-task=4

#SBATCH --mem=8G

#SBATCH --time=12:00:00



# Load fastp

module load fastp/0.23.2-GCCcore-10.2.0



DATA_DIR="/home/gi64/palmer_scratch/admixed_reads"

TRIM_DIR="$DATA_DIR/trimmed2"

mkdir -p "$TRIM_DIR"



# Move into the data directory so the 'ls' and 'fastp' find the files

cd "$DATA_DIR"



# Dynamically generate the accession list

accessions=$(ls SRR*_1.fastq.gz | sed 's/_1.fastq.gz//')



for acc in $accessions; do

    echo "Processing sample: $acc"

    

    # Verify both pairs exist

    if [[ -f "${acc}_1.fastq.gz" && -f "${acc}_2.fastq.gz" ]]; then

        

        # Run fastp on a single line to avoid backslash/whitespace errors

        fastp --in1 "${acc}_1.fastq.gz" --in2 "${acc}_2.fastq.gz" --out1 "${TRIM_DIR}/${acc}_1_trimmed.fastq.gz" --out2 "${TRIM_DIR}/${acc}_2_trimmed.fastq.gz" --html "${TRIM_DIR}/${acc}_fastp.html" --json "${TRIM_DIR}/${acc}_fastp.json" --thread 4 --qualified_quality_phred 20 --length_required 36 --detect_adapter_for_pe

        

    else

        echo "Warning: Missing pairs for $acc"

    fi

done



echo "Trimming complete."
