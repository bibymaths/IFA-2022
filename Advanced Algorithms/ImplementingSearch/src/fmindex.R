#!/usr/bin/env Rscript

packages <- c("seqinr", "fm.index", "optparse");

install.packages(setdiff(packages, rownames(installed.packages()))); 

options(max.print=1000000);

option_list = list( 
  make_option(c("-r", "--ref"), type="character", default=NULL, 
              help="reference file name", metavar="character"),
  make_option(c("-m", "--read"), type="character", default=NULL, 
              help="read file name", metavar="character"), 
  make_option(c("-c", "--count"), type = "integer", default = 1000,
              help = "number of queries",
              metavar = "number")
);   

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);


ref <- read.fasta(file = opt$ref, as.string = TRUE, seqonly = TRUE);
read <- read.fasta(file = opt$read, as.string = TRUE, seqonly = TRUE); 

refseqv <- unlist(ref, use.names = FALSE); 
index <- fm_index_create(refseqv, case_sensitive = TRUE); 
cat("FMIndex done. All Indices are 1-based", "\n");

readseq <- getSequence(read, as.string = TRUE); 
readseqsv <- do.call(c, unlist(readseq, recursive=FALSE));
reads <- readseqsv[seq.int(to = length(readseqsv), length.out = opt$count)]
search <-fm_index_locate(reads, index);    
cat("Matches found:")
search; 
cat("Done!", "\n");
