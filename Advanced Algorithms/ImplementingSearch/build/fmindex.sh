echo "Start searching using fmindex" 
/usr/bin/time -v ./bin/fmindex_construct --reference ../data/hg38_partial.fasta.gz --index myIndex.index 
/usr/bin/time -v ./bin/fmindex_search --index myIndex.index --query ../data/illumina_reads_100.fasta.gz --queries 1000 
/usr/bin/time -v ./bin/fmindex_search --index myIndex.index --query ../data/illumina_reads_100.fasta.gz --queries 10000 
/usr/bin/time -v ./bin/fmindex_search --index myIndex.index --query ../data/illumina_reads_100.fasta.gz --queries 100000 
/usr/bin/time -v ./bin/fmindex_search --index myIndex.index --query ../data/illumina_reads_100.fasta.gz --queries 1000000 
echo "done"
