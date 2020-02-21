# Plan for Analysis of Sandbox Metagenomic Data
## Questions:
1) How do functional genes vary with MAT and MAP

  - Functional genes of interest: 
     * N-fixation genes - *nifH*
     * C-fixation genes - *Rubisco*
     * phototrophy - ....
     * heterotrophy - ...
     
## Pipeline
### 1) Clean data

  * run fastqc
  	- inputs: raw fastq files
  	- outputs: fastqc outputs
  * multiqc
  	- inputs: fastqc outputs
  	- outputs: multiqc report
  * run cutadapt
  	- inputs: raw fastq files
  	- outputs: adapter trimmed fastq files
  * run fastqc again
       - inputs: adapter trimmed fastq files
       - outputs: fastqc outputs
  * run sickle
       - inputs: adapter trimmed fastq files
       - outputs: qual-trimmed fastq files
  * run fastqc again
       - intputs: qual-trimmed fastq files 
       - outputs: fastqc outputs
  * run multiqc again
       - inputs: All three fastqc outputs
       - outputs: final multiqc qual report

### 2) Read-based analyses of taxonomy

   * Script to run phyloflash
    
### 3) Read-based analyses of genes

   * Script to run Squeeze meta - SQM_reads.pl