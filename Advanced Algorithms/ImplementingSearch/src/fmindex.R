require(seqinr) 
require(fm.index) 
  

ref <- read.fasta(file = "hg38_partial.fasta.gz", as.string = TRUE)
read40 <- read.fasta(file = "illumina_reads_40.fasta.gz", as.string = TRUE)
 
refseq <- getSequence(ref, as.string = TRUE)  
read40seqs <- getSequence(read40, as.string = TRUE) 
read40seqsv <- do.call(c, unlist(read40seqs, recursive=FALSE))
refseqv <- unlist(refseq, use.names = FALSE) 
index <- fm_index_create(refseqv, case_sensitive = FALSE) 
 
for (i in 1:length(read40seqsv)) {
search <-fm_index_locate(read40seqsv[i], index) 
if (is.null(nrow(search)) != NULL) { 
  cat ("Match:", read40seqsv[i]) 
  cat ("Position", search$corpus_index)
  count = count + 1} 
print(paste0("Total matches:", count))
}
