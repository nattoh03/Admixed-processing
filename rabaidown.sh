#!/bin/bash

#SBATCH --job-name=rabai_dl

#SBATCH --output=rabai_%j.log

#SBATCH --error=rabai_%j.err

#SBATCH --qos=normal

#SBATCH --partition=day

#SBATCH --nodes=1

#SBATCH --ntasks=1

#SBATCH --cpus-per-task=4

#SBATCH --mem=12G

#SBATCH --time=5:00:00



# 1. Load module and setup

module load SRA-Toolkit/3.1.1-gompi-2022b

vdb-config --set /report/usage=false



# 2. Define Cache Path

CACHE_DIR="/home/gi64/palmer_scratch/admixed_reads/rabai3/sra_cache"

mkdir -p "$CACHE_DIR"



# 3. Configure SRA-Toolkit

vdb-config --set /repository/user/main/public/root="$CACHE_DIR"

vdb-config --set /repository/remote/main/CGI/resolver-cgi="https://trace.ncbi.nlm.nih.gov/Traces/names/names.cgi"



# 4. Define accessions

accessions=(

SRR11006641

)



# 5. Loop and Download

echo "Starting download of ${#accessions[@]} files..."



# Move to the scratch directory

cd /home/gi64/palmer_scratch/admixed_reads



for acc in "${accessions[@]}"; do

    echo "Processing $acc..."



    # Use 4 threads to match --cpus-per-task

    fasterq-dump --split-files --threads 4 --temp "$CACHE_DIR" "$acc"



    # Check if files were created before attempting to gzip

    if ls ${acc}_*.fastq 1> /dev/null 2>&1; then

        echo "Compressing $acc..."

        # Added -f to force overwrite if a previous failed run left files behind

        gzip -f ${acc}_*.fastq

        echo "Finished $acc"

    else

        echo "Error: FASTQ files for $acc were not found."

    fi

done  # <--- This was missing!



echo "All tasks complete."
