!/bin/bash

#SBATCH --job-name=SRA_shimbahills

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
# Debug011\_aegypti\_SHIMBAHILLS\_Kenya

accessions=(

SRR11006855 SRR11006857 SRR11006929 SRR11006930 SRR11006931 

SRR11006932 SRR11006934 SRR11006935

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





