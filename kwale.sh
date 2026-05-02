!/bin/bash

#SBATCH --job-name=SRA_Kwale

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
# Debug011\_aegypti\_KWALE\_Kenya

accessions=(

SRR11006664 SRR11006663 SRR11006662 SRR11006661 SRR11006659 

SRR11006658 SRR11006657 SRR11006656 SRR11006655 SRR11006654 

SRR11006653 SRR11006652 SRR11006651 SRR11006650 SRR11006862 

SRR11006861 SRR11006860 SRR11006859 SRR11006858

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





