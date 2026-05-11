# Admixed-processing
processing archived samples to compare subspecies

# samples are categorized into two
### western kenya
##### kakamega
##### virhembe 

### coastal kenya
##### arabuko
##### kayabomu
##### rabai
##### kwale
##### shimba hill
##### ganda
## contrasting features of the two sampling regions


##### check the location of gene of interest in the .gff file

gi64@login2:~/palmer_scratch/admixed_reads/kayabomu/ref_index$ grep -iE "desaturase|elongase" GCF_002204515.2_AaegL5.0_genomic.gff | awk '{print $1}' | sort | uniq -c
    191 NC_035107.1
     15 NC_035108.1
      7 NC_035109.1
      9 NW_018736656.1
      
gi64@login2:~/palmer_scratch/admixed_reads/kayabomu/ref_index$ grep "LOC110675271" GCF_002204515.2_AaegL5.0_genomic.gff | awk '{print $1}' | sort | uniq -c
     14 NC_035107.1
gi64@login2:~/palmer_scratch/admixed_reads/kayabomu/ref_index$ ls
