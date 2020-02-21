#!/bin/bash

# Set up environment:
# Load Conda Environment
source $(conda info --base)/etc/profile.d/conda.sh
conda activate multiqc

# Set up directories
PROJ_DIR=/data/hollandh/CitSciSandbox/Metagenomic_analyses
STAGE_DIR=$PROJ_DIR/01_preprocess
MULT_QC_DIR=$STAGE_DIR/multiqc_output

cd $STAGE_DIR

mkdir -p $MULT_QC_DIR

multiqc 00_qual_check 01_qual_trim_transposase 01_qual_check 02_qual_check \
        -o $MULT_QC_DIR -c $PROJ_DIR/scripts/01_preprocess/07_multiqc_config.yaml \
        -n 03_multiqc_report_post_cleaning.html \
        --interactive -f
