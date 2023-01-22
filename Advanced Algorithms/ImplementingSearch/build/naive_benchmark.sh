echo "Start searching using naive search"
/usr/bin/time -v ./bin/naive_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_100.fasta.gz --queries 1000 #> naive_results_100_1000.txt
/usr/bin/time -v ./bin/naive_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_100.fasta.gz --queries 10000 #> naive_results_100_10000.txt
/usr/bin/time -v ./bin/naive_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_100.fasta.gz --queries 100000 #> naive_results_100_100000.txt
/usr/bin/time -v ./bin/naive_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_100.fasta.gz --queries 1000000 #> naive_results_100_1000000.txt
echo "done"
