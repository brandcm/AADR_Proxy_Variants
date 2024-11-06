#!/bin/bash
#$ -N retrieve_AADR_variants
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/AADR_proxy_variants/scripts/1240K_variants/retrieve_AADR_variants.out
#$ -e /wynton/group/capra/projects/AADR_proxy_variants/scripts/1240K_variants/retrieve_AADR_variants.err
#$ -l h_rt=1:00:00
#$ -l scratch=5G

# load conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate ancestral_allele

# change directories
cd /wynton/group/capra/projects/AADR_proxy_variants/data/1240K_variants2

# assign variables
AADR_v54_SNVs="/wynton/group/capra/data/wynton_databases/ancient_dna/V54.1.p1/v54.1.p1_1240K_public.snp"
liftOver="/wynton/group/capra/bin/liftOver/liftOver"
hg19_hg38_chain="/wynton/group/capra/bin/liftOver/hg19ToHg38.over.chain.gz"
script="/wynton/group/capra/projects/AADR_proxy_variants/scripts/1240K_variants/check_reference_bases_in_AADR_hg38_bed.py"
hg38_fasta="/wynton/group/capra/data/hg38_fasta/2022-03-14/hg38.fa"

# run
awk '{print $2}' OFS='\t' "$AADR_v54_SNVs" > 1240K_SNVs_hg19_chrs.tmp
awk '{print $4,$5,$6,$1}' OFS='\t' "$AADR_v54_SNVs" > 1240K_SNVs_hg19_pos_ref_alt.tmp
sed -i 's/23/X/g' 1240K_SNVs_hg19_chrs.tmp
sed -i 's/24/Y/g' 1240K_SNVs_hg19_chrs.tmp
paste 1240K_SNVs_hg19_chrs.tmp 1240K_SNVs_hg19_pos_ref_alt.tmp > 1240K_SNVs_hg19.txt
rm 1240K_SNVs_hg19_chrs.tmp && rm 1240K_SNVs_hg19_pos_ref_alt.tmp

awk '{print "chr"$1,$2-1,$2,$3,$4,$5}' OFS='\t' 1240K_SNVs_hg19.txt > 1240K_SNVs_hg19.bed
awk '{print $1,$2,$3,$4":"$5":"$6}' OFS='\t' 1240K_SNVs_hg19.bed > 1240K_SNVs_hg19.tmp

"$liftOver" 1240K_SNVs_hg19.tmp "$hg19_hg38_chain" 1240K_SNVs_hg38.tmp 1240K_SNVs_hg19.unlifted
awk -F'[\t:]' '{print $1,$2,$3,$4,$5,$6}' OFS='\t' 1240K_SNVs_hg38.tmp > 1240K_SNVs_hg38.tmp2

python3 "$script" --fasta "$hg38_fasta" --bed 1240K_SNVs_hg38.tmp2 --output 1240K_SNVs_hg38.bed
rm 1240K_SNVs_hg19.tmp && rm 1240K_SNVs_hg38.tmp && rm 1240K_SNVs_hg38.tmp2
