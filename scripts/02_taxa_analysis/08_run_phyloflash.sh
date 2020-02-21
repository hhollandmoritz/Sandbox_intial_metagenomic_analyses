#!/bin/bash

# Bash script for creating sickle commands
# create_cutadapt_commands.sh

# Define variables; FILL THIS PART IN
PROJ_DIR=/data/hollandh/CitSciSandbox/Metagenomic_analyses
PREV_STAGE_DIR=$PROJ_DIR/01_preprocess
STAGE_DIR=$PROJ_DIR/02_taxa_analysis
IN_DIR=$PREV_STAGE_DIR/02_sickle_qual_filt # location of fastq files
OUT_DIR=$STAGE_DIR/01_phyloFlash # location of output quality assessment files
LOG_DIR=$OUT_DIR/logs
# Parallel variables
# Note: on proteus CORES*ntasks should not exceed 32
CORES=16 # number of cores for fastqc to use
ntasks=1

# Move into datafile
cd $IN_DIR

# make a directories to put outputs
mkdir -p $OUT_DIR
mkdir -p $LOG_DIR

j=0
# make commands and write them to a file
for i in $(ls *.fastq)
do
    # move J forward by 1
    printf -v j '%03d' $((10#$j + 1)) 
    

    ## Arrange the variables
    prefix=${i%.*}
    echo $prefix
    infile="$IN_DIR"/"$prefix".fastq
    echo $infile
    outfile="$prefix".fastq.gz
    logfile_name="$LOG_DIR"/"$prefix"_fastqc.log
    # echo $logfile_name
    # echo $CORES
    # echo $ntasks
    

    ## Writing the batch script (note: formatting without indentation here is imporant)

    # cd into the output directory
    cd $IN_DIR 
    mkdir -p $OUT_DIR # Make output directory before running

    # Run Fastqc command
    #fastqc $infile -o $OUT_DIR -t $CORES &> $logfile_name &
    # PHYLOFLASH COMMAND GOES HERE
    sleep 30 &

    # create non-leading zero version
    jeval=$(expr $j + 0)
    if (($jeval % $ntasks == 0))
        then
        wait
        echo j is "$j". Waiting for processes to finish before continuing...
    fi


done

echo "DONE"
echo "outputs can be found at $OUT_DIR"
echo "logs can be found at $LOG_DIR"

