#!/bin/bash

#SBATCH --job-name=bwa_index_Aaeg

#SBATCH --output=ref_prep_%j.log

#SBATCH --error=refe_prep_%j.err

#SBATCH --qos=normal

#SBATCH --partition=day            # 'day' is best for a 12-hour job

#SBATCH --nodes=1

#SBATCH --ntasks=1

#SBATCH --cpus-per-task=4

#SBATCH --mem=64G                  # Increased for Aedes aegypti data

#SBATCH --time=12:00:00


# Load the BWA module


module load BWA/0.7.17-GCCcore-12.2.0

module load SAMtools/1.21-GCC-13.3.0

module load picard/2.25.6-Java-11   # Used for the .dict file


# Run the indexing command

# -p specifies the prefix for the output files

bwa index -p AaegL5_index GCF_002204515.2_AaegL5.0_genomic.fna
