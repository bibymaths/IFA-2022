#!/usr/bin/env Rscript

##-------------------------------------------------------------------------------
##  Description:
##
##  This R script reads one reference genome file, and one read sequences file
##  with number of queries from the reads file based on creation, and searching
##  of fmindex. It displays the matched read sequences after the positions
##  of reads in reference sequence.
##
##  Author: Abhinav Mishra (Group 7)
##-------------------------------------------------------------------------------

#################################################################
##                     Usage: command line                     ##
#################################################################

##-----------------------------------------------------------------------------------
##  Step 1. Put all the files in one directory, and make it your working directory.
##  Step 2. Rscript -r referencefilename -m readfilename -c numberofqueries
##
##  For Step 1, you can use this command inside the R shell:
##
##  setwd('insertdirectorypath')
##
##  For Step 2, a detailed usage as follows:
##
##  Usage: Rscript fmindex.R [options]
##
##
##  Options:
##          -r CHARACTER, --ref=CHARACTER
##                  reference file name
##
##          -m CHARACTER, --read=CHARACTER
##                  read file name
##
##          -c NUMBER, --count=NUMBER
##                  number of queries
##
##          -h, --help
##                  Show this help message and exit
##-----------------------------------------------------------------------------------

##################################################################
##                           Packages                           ##
##################################################################

# If you want to install the required
# packages, uncomment the next line

# install.packages(c('seqinr','fm.index','optparse'));

require(seqinr)

require(fm.index)

require(optparse)


# increasing the STDER like max.print() output to print every sequence
options(max.print = 1000000)


#################################################################
##                      Passing arguments                      ##
#################################################################

# argument passing function
option_list = list(
  make_option(
    c("-r", "--ref"),
    type = "character",
    default = NULL,
    help = "reference file name",
    metavar = "character"
  ),
  make_option(
    c("-m", "--read"),
    type = "character",
    default = NULL,
    help = "read file name",
    metavar = "character"
  ),
  make_option(
    c("-c", "--count"),
    type = "integer",
    default = 1000,
    help = "number of queries",
    metavar = "number"
  )
)


# parsing the argument options list
opt_parser = OptionParser(option_list = option_list)


# parsing it into a data frame to call later
opt = parse_args(opt_parser)


#################################################################
##               Reading fasta files and queries               ##
#################################################################

# reading reference gzipped .fasta file for sequence retrieval
ref <- read.fasta(file = opt$ref,
             as.string = TRUE,
             seqonly = TRUE)


# reading reads gzipped .fasta file for a list of list of sequences
read <- read.fasta(file = opt$read,
             as.string = TRUE,
             seqonly = TRUE)


# making reference sequence a vector for fmindex creation
refseqv <- unlist(ref, use.names = FALSE)


# converting the read sequences into a list of list for function mapping
readseq <- getSequence(read, as.string = TRUE)


# making read sequences vector for fmindex search
readseqsv <- do.call(c, unlist(readseq, recursive = FALSE))


# reading as per number of queries
reads <- readseqsv[seq.int(to = length(readseqsv), length.out = opt$count)]


##################################################################
##                Creating fmindex and searching                ##
##################################################################

# creating index
index <- fm_index_create(refseqv, case_sensitive = TRUE)


# first checkpoint
cat("FMIndex done. All Indices are 1-based", "\n")


# searching the index created for string matching
search <- fm_index_locate(reads, index)


##################################################################
##                      Displaying matches                      ##
##################################################################

# second checkpoint
cat("Matched indexes with positions", "\n")


# displaying the data frame with
# pattern_index | corpus_index | position
search


# third checkpoint
cat("Sequences matched:", "\n")

# displaying the each sequence matched
# by retracing the index to the read list
unique(reads[search$pattern_index])


# last checkpoint
cat("Done!", "\n")
