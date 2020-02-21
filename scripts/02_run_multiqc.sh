#!/bin/bash

# Activate conda environment
source $(conda info --base)/etc/profile.d/conda.sh
conda activate multiqc

# Make directories
PROJ_DIR=/data/hollandh/CitSciSandbox/Metagenomic_analyses
STAGE_DIR=$PROJ_DIR/01_preprocess
IN_DIR=$STAGE_DIR/00_qual_check
MULT_QC_DIR=$STAGE_DIR/multiqc_output

cd $STAGE_DIR

mkdir -p $MULT_QC_DIR


multiqc $IN_DIR -o $MULT_QC_DIR -n 00_multiqc_report_pre_cleaning.html

conda deactivate
