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

  * script to run fastqc
  * multiqc
  * run cutadapt and sickle
  * run multiqc again

### 2) Read-based analyses of taxonomy

   * Script to run phyloflash
    
### 3) Read-based analyses of genes

   * Script to run Squeeze meta - SQM_reads.pl