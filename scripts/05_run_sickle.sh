#!/bin/bash

# Bash script for creating sickle commands
# create_sickle_commands.sh

# Define variables; FILL THIS PART IN
QUAL=20 # quality threshold
LENG=50 # length threshold
PROJ_DIR=/data/hollandh/CitSciSandbox/Metagenomic_analyses
STAGE_DIR=$PROJ_DIR/01_preprocess
DATA_DIR=$STAGE_DIR/01_qual_trim_transposase # location of the input files
OUTPUT_DIR=$STAGE_DIR/02_sickle_qual_filt # location to put sickle-processed files
LOG_DIR=$OUT_DIR/logs
# Parallel variables
# Note: on proteus ntasks should not exceed 32
ntasks=30


# Move into datafile
cd $DATA_DIR


# Make an output directory for processed files
mkdir -p $OUTPUT_DIR
mkdir -p $LOG_DIR

j=0
# make commands and write them to a file
for i in $(ls *.fastq.gz)
do
    # move J forward by 1
    printf -v j '%03d' $((10#$j + 1)) 

    ## Arrange the variables
    prefix=${i%_R*.*}
    infile1="$DATA_DIR"/"$prefix"_R1_trans_trim.fastq.gz
    infile2="$DATA_DIR"/"$prefix"_R2_trans_trim.fastq.gz
    outfile1="$OUTPUT_DIR"/"$prefix"_R1_qual_filt.fastq
    outfile2="$OUTPUT_DIR"/"$prefix"_R2_qual_filt.fastq
    outfile3="$OUTPUT_DIR"/"$prefix"_singles_qual_filt.fastq
    command_file_name=$COMMAND_DIR/"$prefix"_sickle_command.sbatch
    
    ## Running command
    # make a directory for the output
    mkdir -p $OUTPUT_DIR

    # run the sickle command
    sickle pe -f $infile1 -r $infile2 -t sanger -o $outfile1 -p $outfile2 -s $outfile3 -q $QUAL -l $LENG 

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

