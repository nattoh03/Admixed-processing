!/bin/bash

#SBATCH --job-name=SRA_kakamega

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
# Debug011\_aegypti\_KAKAMEGA\_Kenya

accessions=(

SRR11006686 SRR11006687 SRR11006688 SRR11006689 SRR11006690

SRR11006691 SRR11006692 SRR11006694 SRR11006695 SRR11006696

SRR11006697 SRR11006698 SRR11006699 SRR11006700 SRR11006701

SRR11006702 SRR11006705 SRR11006703 SRR11006705 SRR11006706

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





