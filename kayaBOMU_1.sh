!/bin/bash

#SBATCH --job-name=SRA_kayaBOMU

#SBATCH --output=dl_%j.log

#SBATCH --error=dl_%j.err

#SBATCH --qos=normal

#SBATCH --partition=day            # 'day' is best for a 12-hour job

#SBATCH --nodes=1

#SBATCH --ntasks=1

#SBATCH --cpus-per-task=4

#SBATCH --mem=12G                  # Increased for Aedes aegypti data

#SBATCH --time=12:00:00



# 1. Load module and setup

module load SRA-Toolkit/3.1.1-gompi-2022b

vdb-config --set /report/usage=false



# 2. Define Cache Path FIRST

CACHE_DIR="/home/gi64/palmer_scratch/admixed_reads/sra_cache"

mkdir -p "$CACHE_DIR"




# 3. Configure SRA-Toolkit to use Scratch

export VDB_CONFIG="$CACHE_DIR"

vdb-config --set /repository/user/main/public/root="$CACHE_DIR"

vdb-config --set /repository/remote/main/CGI/resolver-cgi="https://trace.ncbi.nlm.nih.gov/Traces/names/names.cgi"



# 4. Define accessions
# Debug011\_aegypti\_KayaBomu\_Kenya

accessions=(

SRR11006665 SRR11006666 SRR11006667 SRR11006668 SRR11006669 

SRR11006670 SRR11006672 SRR11006673 SRR11006674 SRR11006675 

SRR11006676 SRR11006677 SRR11006678 SRR11006679 SRR11006680 

SRR11006681 SRR11006683 SRR11006684 SRR11006685

)


# 5. Loop and Download

echo "Starting download of ${#accessions[@]} files..."



# Move to the scratch directory so output goes there

cd /home/gi64/palmer_scratch/admixed_reads



for acc in "${accessions[@]}"; do

    echo "Processing $acc..."

    

    # threads=4 to match cpus-per-task

    fasterq-dump --split-files --threads 4 --temp "$CACHE_DIR" "$acc"

    

    # Compress to save space

    gzip ${acc}_*.fastq

    

    echo "Finished $acc"

done





