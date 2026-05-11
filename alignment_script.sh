#!/bin/bash

#SBATCH --job-name=BWA_Aedes

#SBATCH --output=logs/align_%a.out

#SBATCH --error=logs/align_%a.err

#SBATCH --partition=day

#SBATCH --qos=normal

#SBATCH --nodes=1

#SBATCH --ntasks=1

#SBATCH --cpus-per-task=12

#SBATCH --mem=64G

#SBATCH --time=24:00:00

#SBATCH --array=0-34




# 1. Load Modules

module purge
module load BWA/0.7.17-GCCcore-12.2.0
module load SAMtools/1.21-GCC-12.2.0
module load picard/2.25.6-Java-11


# 2. Define Paths

# Use the index you just built today

INDEX="/home/gi64/palmer_scratch/admixed_reads/kayabomu/ref_index/AaegL5_index"

TRIM_DIR="/home/gi64/palmer_scratch/admixed_reads/trimmed_rabai"

OUT_DIR="/home/gi64/palmer_scratch/admixed_reads/aligned_rabai"



# Ensure the log and output directories exist

mkdir -p $OUT_DIR

mkdir -p /home/gi64/palmer_scratch/admixed_reads/logs




# 3. Create a list of Sample IDs (SRR numbers)
# This finds all unique SRR prefixes in your trimmed folder
SAMPLES=($(ls $TRIM_DIR/SRR*_1_trimmed.fastq.gz | xargs -n 1 basename | sed 's/_1_trimmed.fastq.gz//'))

# Pick the sample for THIS specific array task
SAMPLE=${SAMPLES[$SLURM_ARRAY_TASK_ID]}

echo "Processing sample: $SAMPLE"



# 4. Run BWA MEM -> Samtools Sort
bwa mem -t $SLURM_CPUS_PER_TASK -M \
  -R "@RG\tID:${SAMPLE}\tSM:${SAMPLE}\tPL:ILLUMINA" \
  $INDEX \
  ${TRIM_DIR}/${SAMPLE}_1_trimmed.fastq.gz \
  ${TRIM_DIR}/${SAMPLE}_2_trimmed.fastq.gz | \
  samtools sort -@ 4 -m 4G -o ${OUT_DIR}/${SAMPLE}_sorted.bam -

# 5. Mark Duplicates (Critical for admixed genetic analysis)
java -Xmx32G -jar $EBROOTPICARD/picard.jar MarkDuplicates \
      I=${OUT_DIR}/${SAMPLE}_sorted.bam \
      O=${OUT_DIR}/${SAMPLE}_final.bam \
      M=${OUT_DIR}/${SAMPLE}_dup_metrics.txt \
      REMOVE_DUPLICATES=false

# 6. Index and Stats
samtools index ${OUT_DIR}/${SAMPLE}_final.bam
samtools flagstat ${OUT_DIR}/${SAMPLE}_final.bam > ${OUT_DIR}/${SAMPLE}_report.txt

# Cleanup intermediate sorted BAM to save space
rm ${OUT_DIR}/${SAMPLE}_sorted.bam


