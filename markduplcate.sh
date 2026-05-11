#!/bin/bash

#SBATCH --job-name=MarkDup_Aedes

#SBATCH --output=logs_markdup_%a.out

#SBATCH --error=logs_markdup_%a.err

#SBATCH --partition=day

#SBATCH --qos=normal

#SBATCH --nodes=1

#SBATCH --ntasks=1

#SBATCH --cpus-per-task=2

#SBATCH --mem=32G               # Picard needs a lot of RAM for sorting

#SBATCH --time=12:00:00

#SBATCH --array=0-18





# 1. Load Modules

module load picard/2.27.5-Java-11

module load SAMtools/1.17-GCC-12.2.0



# 2. Paths

ALIGNED_DIR="/home/gi64/palmer_scratch/admixed_reads/aligned"

MOCKED_DIR="/home/gi64/palmer_scratch/admixed_reads/deduped"

METRICS_DIR="/home/gi64/palmer_scratch/admixed_reads/metrics"

mkdir -p $MOCKED_DIR $METRICS_DIR



# 3. Sample List

samples=(SRR11006665 SRR11006666 SRR11006667 SRR11006668 SRR11006669 

         SRR11006670 SRR11006672 SRR11006673 SRR11006674 SRR11006675 

         SRR11006676 SRR11006677 SRR11006678 SRR11006679 SRR11006680 

         SRR11006681 SRR11006683 SRR11006684 SRR11006685)



SAMPLE=${samples[$SLURM_ARRAY_TASK_ID]}



echo "Marking duplicates for $SAMPLE..."



# 4. Run Picard MarkDuplicates

# Xmx28g tells Java to use 28GB of the 32GB requested (leave some for the OS)

java -Xmx28g -jar $EBROOTPICARD/picard.jar MarkDuplicates \

      I=${ALIGNED_DIR}/${SAMPLE}_sorted.bam \

      O=${MOCKED_DIR}/${SAMPLE}_dedup.bam \

      M=${METRICS_DIR}/${SAMPLE}_dup_metrics.txt \

      REMOVE_DUPLICATES=false \

      TAGGING_POLICY=All



# 5. Index the new BAM

samtools index ${MOCKED_DIR}/${SAMPLE}_dedup.bam



echo "Finished $SAMPLE at $(date)"

