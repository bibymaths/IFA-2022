for i in 0 1 2 3 4 5 6 7 8 9
do

    echo "Start searching using suffix array"
    for query in 1000 10000 100000 1000000
    do
        echo query $query
        /usr/bin/time -v ./bin/suffixarray_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_100.fasta.gz --queries $query 2>&1 | grep Time
    done
    printf "done\n\n"

    echo run number $i

    echo "Start searching using FM-Index"

    for query in 1000 10000 100000 1000000
    do
        for error in 0 1 2 3
        do
            echo query $query
            echo error $error
            /usr/bin/time -v ./bin/fmindex_search --index myIndex.index --query ../data/illumina_reads_40.fasta.gz --queries  $query --errors $error 2>&1 | grep Time
        done
    done
    printf "done\n\n"

    echo "Start searching using naive search"

    for query in 1000 #10000 100000 1000000
    do
        echo query $query
        /usr/bin/time -v ./bin/naive_search --reference ../data/hg38_partial.fasta.gz --query ../data/illumina_reads_100.fasta.gz --queries $query 2>&1 | grep Time
    done
    printf "done\n\n"
done


