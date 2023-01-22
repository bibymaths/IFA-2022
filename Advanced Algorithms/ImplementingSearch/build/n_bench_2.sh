echo "Start searching using naive search"
>NAql40q1000.txt
/usr/bin/time -o NAql40q1000.txt -a -v ./bin/naive_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_40.fasta.gz --queries 1000 >> NAql40q1000.txt
>NAql60q1000.txt
/usr/bin/time -o NAql60q1000.txt -a -v ./bin/naive_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_60.fasta.gz --queries 1000 >> NAql60q1000.txt
>NAql80q1000.txt
/usr/bin/time -o NAql80q1000.txt -a -v ./bin/naive_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_80.fasta.gz --queries 1000 >> NAql80q1000.txt
>NAql100q1000.txt
/usr/bin/time -o NAql100q1000.txt -a -v ./bin/naive_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_100.fasta.gz --queries 1000 >> NAql100q1000.txt
echo "done"
