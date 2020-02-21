#!/bin/bash

# Bash script for creating sickle commands
# create_cutadapt_commands.sh

# Define variables; FILL THIS PART IN
PROJ_DIR=/scratch/summit/$USER/austrailian-metagenome/first_50_test_samples
STAGE_DIR=$PROJ_DIR/01_preprocess
COMMAND_DIR=$PROJ_DIR/01_preprocess/01_fastqc_commands # location to place the command files
IN_DIR=$PROJ_DIR/00_raw_data # location of raw fastq files
OUT_DIR=$STAGE_DIR/00_qual_check # location of output quality assessment files
CORES=1 # number of cores for fastqc to use


# Move into datafile
cd $IN_DIR

# make an file to put the command files in
mkdir -p $COMMAND_DIR

# make a directory to put the output in
mkdir -p $OUT_DIR

# make commands and write them to a file
for i in $(ls *.fastq.gz)
do
    
    ## Arrange the variables
    prefix=${i%.*.*}
    echo $prefix
    infile="$IN_DIR"/"$prefix".fastq.gz
    echo $infile
    outfile="$prefix".fastq.gz
    command_file_name=$COMMAND_DIR/"$prefix"_fastqc_command.sbatch
    logfile_name=$COMMAND_DIR/"$prefix"_fastqc.log
    
    ## Writing the batch script (note: formatting without indentation here is imporant)

cat << EOF > $command_file_name    
#!/bin/bash

# cd into the output directory
cd $IN_DIR 
mkdir -p $OUT_DIR # Make output directory before running

# Run Fastqc command
fastqc $infile -o $OUT_DIR -t 1 --extract #for zipped files use the --extract flag

# write an empty .end file into the command directory so user can keep track while program runs
touch $command_file_name.end
    
EOF

done

# Make a file that lists the location of the commands

cd $COMMAND_DIR
ls $PWD/*.sbatch > commands.txt
