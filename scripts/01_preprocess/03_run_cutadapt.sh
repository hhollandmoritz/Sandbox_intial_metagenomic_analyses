#!/bin/bash

# Bash script for running cutadapt


# Activate conda environment
source $(conda info --base)/etc/profile.d/conda.sh
conda activate cutadapt


# Define variables; FILL THIS PART IN
TN5_SEQ=CTGTCTCTTATACACATCT # transposase sequence
TN5_RC=AGATGTGTATAAGAGACAG # reverse complement of transposase sequence
PROJ_DIR=/data/hollandh/CitSciSandbox/Metagenomic_analyses
STAGE_DIR=$PROJ_DIR/01_preprocess
SCRIPT_DIR=$PROJ_DIR/scripts/03_run_cutadapt.sh # location to place the command files
DATA_DIR=$PROJ_DIR/00_raw_data # location of the input files
OUTPUT_DIR=$STAGE_DIR/01_qual_trim_transposase # location to put trimmed fastq files
LOG_DIR=$OUTPUT_DIR/logs
# Parallel variables
# Note: on proteus CORES*ntasks should not exceed 32
CORES=11 # number of cores for cutadapt to use
ntasks=2

# Move into datafile
cd $DATA_DIR

# make a directory to put the output in
mkdir -p $OUTPUT_DIR
mkdir -p $LOG_DIR

# make commands and write them to a file
for i in $(ls *.fastq.gz)
do
    # move J forward by 1
    printf -v j '%03d' $((10#$j + 1)) 
    
    ## Arrange the variables
    prefix=${i%_R*.*}
    echo $prefix
    infile1="$DATA_DIR"/"$prefix"_R1 # note: must do this b/c sloppy 001 in filenames
    infile2="$DATA_DIR"/"$prefix"_R2 # note: ditto ^
    outfile1="$prefix"_R1_trans_trim.fastq.gz
    outfile2="$prefix"_R2_trans_trim.fastq.gz
    echo "INFILES"
    echo $infile1
    echo $infile2
    echo "OUT_FILES"
    echo $outfile1
    echo $outfile2

    logfile_name=$LOG_DIR/"$prefix"_cutadapt.log
    
    ## Run Commands
    # cd into the output directory
    cd $OUTPUT_DIR 

    # run the cutadapt command
    # NOTE: to use multiqc with output logs, make sure cutadapt command ends with filename
    #cutadapt -a $TN5_SEQ -a $TN5_RC -o $outfile1 -p $outfile2 $infile1 $infile2 -j $CORES > $logfile_name
    cutadapt -a $TN5_SEQ -a $TN5_RC -A $TN5_SEQ -A $TN5_RC -n 2 -j $CORES -o $outfile1 -p $outfile2 $infile1*.fastq.gz $infile2*.fastq.gz &> $logfile_name &


    # create non-leading zero version
    jeval=$(expr $j + 0)
    if (($jeval % $ntasks == 0))
        then
        wait
        echo j is "$j". Waiting for processes to finish before continuing...
    fi

done

conda deactivate

echo "DONE"
echo "outputs can be found at $OUT_DIR"
echo "logs can be found at $LOG_DIR"
