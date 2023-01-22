echo "Start searching using suffix array"
/usr/bin/time -v ./bin/suffixarray_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_100.fasta.gz --queries 1000 # > suf_results_100_1000.txt
/usr/bin/time -v ./bin/suffixarray_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_100.fasta.gz --queries 10000 #> suf_results_100_10000.txt
/usr/bin/time -v ./bin/suffixarray_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_100.fasta.gz --queries 100000 #> suf_results_100_100000.txt
/usr/bin/time -v ./bin/suffixarray_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_100.fasta.gz --queries 1000000 #> suf_results_100_100000.txt

echo "done"
