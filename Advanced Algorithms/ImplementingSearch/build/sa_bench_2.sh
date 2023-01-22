echo "Start searching using suffix array"
>SAql40q1000.txt
/usr/bin/time -o SAql40q1000.txt -a -v ./bin/suffixarray_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_40.fasta.gz --queries 1000 >> SAql40q1000.txt
>SAql60q1000.txt
/usr/bin/time -o SAql60q1000.txt -a -v ./bin/suffixarray_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_60.fasta.gz --queries 1000 >> SAql60q1000.txt
>SAql80q1000.txt
/usr/bin/time -o SAql80q1000.txt -a -v ./bin/suffixarray_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_80.fasta.gz --queries 1000 >> SAql80q1000.txt
>SAql100q1000.txt
/usr/bin/time -o SAql100q1000.txt -a -v ./bin/suffixarray_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_100.fasta.gz --queries 1000 >> SAql100q1000.txt
echo "done"
