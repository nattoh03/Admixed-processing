#!/bin/sh

#SBATCH --job-name=subjunc_SRR7-8
#SBATCH --output=subjunc_%j.out
#SBATCH --error=subjunc_%j.err
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4       # Must match your -T 32
#SBATCH --mem=64G                # Aedes aegypti index is large; 64GB is safe
#SBATCH --time=01:00:00          # 6 hours is plenty for one SRR sample
#SBATCH --partition=devel      # Replace with your actual cluster partition name


cd /home/gi64/palmer_scratch/gong_cheng/raw_reads/
module load Subread/2.0.3-GCC-10.2.0
mkdir -p ./Bam_files
## subread-buildindex ../../Aedes/GCF_002204515.2_AaegL5.0_genomic.fna -o ./GCF_002204515.2_AaegL5.0_genomic_index
subjunc -T 4 -M 5 -d 50 -D 1500 -r SRR2637686.fastq.gz -i GCF_002204515.2_AaegL5.0_genomic_index -o ./Bam_files/SRR_6.bam 2> ./Bam_files/SRR_6_subjunc_log.txt
subjunc -T 4 -M 5 -d 50 -D 1500 -r SRR2637687.fastq.gz -i GCF_002204515.2_AaegL5.0_genomic_index -o ./Bam_files/SRR_7.bam 2> ./Bam_files/SRR_7_subjunc_log.txt
subjunc -T 4 -M 5 -d 50 -D 1500 -r SRR2637688.fastq.gz -i GCF_002204515.2_AaegL5.0_genomic_index -o ./Bam_files/SRR_8.bam 2> ./Bam_files/SRR_8_subjunc_log.txt

echo
