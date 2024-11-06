#!/bin/bash
#$ -N identify_AGV_LD_variants
#$ -t 1-92
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/AADR_proxy_variants/scripts/AGV_LD_variants/identify_AGV_LD_variants.out
#$ -e /wynton/group/capra/projects/AADR_proxy_variants/scripts/AGV_LD_variants/identify_AGV_LD_variants.err
#$ -l h_rt=2:00:00
#$ -l mem_free=10G

# assign variables
pop_chrs="/wynton/group/capra/projects/AADR_proxy_variants/data/metadata/chrs_by_pop.txt"
pop=$(awk -v row=$SGE_TASK_ID 'NR == row {print $1}' "$pop_chrs")
chr=$(awk -v row=$SGE_TASK_ID 'NR == row {print $2}' "$pop_chrs")
dictionary="/wynton/group/capra/projects/AADR_proxy_variants/data/1240K_variants/1240K_SNVs_hg38.pkl"
LD_directory="/wynton/group/capra/projects/AADR_proxy_variants/data/TopLD"
out_directory="/wynton/group/capra/projects/AADR_proxy_variants/data/AGV_LD_variants"
script="/wynton/group/capra/projects/AADR_proxy_variants/scripts/AGV_LD_variants/identify_AGV_LD_variants.py"

# run
mkdir -p "$out"
python3 "$script" --dictionary "$dictionary" --population "$pop" --chromosome "$chr" --LD_files_directory "$LD_directory" --out_directory "$out_directory"
gzip "${out_directory}/${pop}_${chr}_AGV_LD_variants.txt"