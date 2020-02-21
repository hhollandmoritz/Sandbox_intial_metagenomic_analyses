#!/bin/bash

# Bash script for creating sickle commands
# create_cutadapt_commands.sh

# Define variables; FILL THIS PART IN
PROJ_DIR=/data/hollandh/CitSciSandbox/Metagenomic_analyses
OUTPUTS=$PROJ_DIR/outputs
LOGS=$PROJ_DIR/logs
STAGE=01_preprocess
STAGE_OUT_DIR=$OUTPUTS/$STAGE
STAGE_LOG_DIR=$LOGS/$STAGE
SCRIPT_DIR=$PROJ_DIR/scripts/01_run_fastqc.sh # location of script file
IN_DIR=$PROJ_DIR/00_raw_data # location of raw fastq files
OUT_DIR=$STAGE_OUT_DIR/00_qual_check # location of output quality assessment files
LOG_DIR=$STAGE_LOG_DIR/00_qual_check # Location of logs from quality assessment
# Parallel variables
# Note: on proteus CORES*ntasks should not exceed 32
CORES=8 # number of cores for fastqc to use
ntasks=2

# Move into datafile
cd $IN_DIR

# make a directories to put outputs and logs
mkdir -p $OUT_DIR
mkdir -p $LOG_DIR

j=0
# make commands and write them to a file
for i in $(ls *.fastq.gz)
do
    
    ## Arrange the variables
    prefix=${i%.*.*}
    echo $prefix
    infile="$IN_DIR"/"$prefix".fastq.gz
    echo $infile
    outfile="$prefix".fastq.gz
    logfile_name=$LOG_DIR/"$prefix"_fastqc.log
    
    ## Writing the batch script (note: formatting without indentation here is imporant)

    # cd into the output directory
    cd $IN_DIR 
    mkdir -p $OUT_DIR # Make output directory before running

    # Run Fastqc command
    #fastqc $infile -o $OUT_DIR -t $CORES --extract > logfile_name

    # create non-leading zero version
    jeval=$(expr $j + 0)
    if (($jeval % $ntasks == 0))
        then
        wait
        echo j is "$j". Waiting for processes to finish before continuing...
    fi


done


