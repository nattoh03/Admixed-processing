#!/bin/bash

#SBATCH --job-name=Aedes_Ref_Prep

#SBATCH --mem=20G

#SBATCH --time=04:00:00


#!/bin/bash

#SBATCH --job-name=SRA_d
#SBATCH --output=ref_prep_%j.log

#SBATCH --error=refe_prep_%j.err

#SBATCH --qos=normal

#SBATCH --partition=day            # 'day' is best for a 12-hour job

#SBATCH --nodes=1

#SBATCH --ntasks=1

#SBATCH --cpus-per-task=4

#SBATCH --mem=12G                  # Increased for Aedes aegypti data

#SBATCH --time=12:00:00




# 1. Load the necessary modules

module load BWA/0.7.17-GCC-12.2.0

module load SAMtools/1.17-GCC-12.2.0

module load picard/2.27.5-Java-11   # Used for the .dict file



GENOME="GCF_002204515.2_AaegL5.0_genomic.fna"

DICT="GCF_002204515.2_AaegL5.0_genomic.dict"



echo "Started reference preparation at $(date)"



# 2. BWA Indexing (The most time-consuming part)

echo "Generating BWA index files..."

bwa index $GENOME



# 3. SAMtools Indexing (Fast)

echo "Generating FAI index..."

samtools faidx $GENOME



# 4. Picard/GATK Dictionary (Crucial for downstream SNP calling)

echo "Generating sequence dictionary..."

# Note: If your cluster uses a wrapper, the command might just be 'picard'

java -jar $EBROOTPICARD/picard.jar CreateSequenceDictionary \

      R=$GENOME \

      O=$DICT



echo "Reference preparation complete at $(date)"

echo "Listing directory contents:"

ls -lh
