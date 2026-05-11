#!/bin/bash



#SBATCH --job-name=TSV_STAT

#SBATCH --output=TSV_STAT_%j.log



#SBATCH --error=TSV_STAT_%j.err



#SBATCH --qos=normal



#SBATCH --partition=day            # 'day' is best for a 12-hour job



#SBATCH --nodes=1



#SBATCH --ntasks=1



#SBATCH --cpus-per-task=1



#SBATCH --mem=4G                  # Increased for Aedes aegypti data



#SBATCH --time=00:30:00



# 1. Create the header with tab separation

echo -e "Sample\tTotal_Reads\tMapped_Reads\tMapped_Percent\tProperly_Paired_Percent" > mapping_summary.tsv



# 2. Loop through reports and append cleaned data

for f in ./aligned/*_report.txt; do

    # Get the filename without the path or extension

    SAMPLE=$(basename "$f" _report.txt)

    

    # Extract only the first number (Total Reads)

    TOTAL=$(grep "total" "$f" | awk '{print $1}')

    

    # Extract only the first number (Mapped Reads)

    MAPPED=$(grep "primary mapped" "$f" | awk '{print $1}')

    

    # Extract the percentage between the parentheses (e.g., 97.27)

    PERCENT=$(grep "primary mapped" "$f" | cut -d '(' -f 2 | cut -d '%' -f 1)

    

    # Extract the properly paired percentage (e.g., 68.35)

    PAIRED=$(grep "properly paired" "$f" | cut -d '(' -f 2 | cut -d '%' -f 1)

    

    # Write to the file using tabs (\t)

    echo -e "${SAMPLE}\t${TOTAL}\t${MAPPED}\t${PERCENT}\t${PAIRED}" >> mapping_summary.tsv

done



# 3. Verify the layout

column -t -s $'\t' mapping_summary.tsv | head -n 5
