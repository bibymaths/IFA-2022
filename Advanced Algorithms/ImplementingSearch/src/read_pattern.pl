#!/usr/bin/env perl 
  
use strict; 
use warnings;    
use diagnostics;   

=begin USAGE  

Only core modules of perl were used. Most perl versions have  
standard modules already installed, making it executable on 
servers, and local systems. 
 
STEP 1. 

Download and put this script and all .fasta.gz files  
[/data folder from Simon's github repo] in the same directory.    
  
STEP 2. 

For Windows: 

Install perl or active state software to run it using   
an IDLE, and use Valgrind software to benchmark it.

Command line (MacOS):   

1. Usage: perl read_pattern.pl  
==> User I/O + Output file only <==  

2. Usage: /usr/bin/time -l perl read_pattern.pl
===> User I/O + Output file + Benchmarking (memory+runtime) <=== 
 
Command line (Linux):   

1. Usage: perl read_pattern.pl  
==> User I/O + Output file only <==  

2. Usage: /usr/bin/time -v perl read_pattern.pl
===> User I/O + Output file + Benchmarking (memory+runtime) <=== 

Display for (2.) usage: 

'maximum resident set size' is the Memory usage (in bytes)
'real' is the Runtime usage (wallclock) (in seconds) 

=end USAGE 
=cut
 
=begin INTRODUCTION  

Author: Abhinav Mishra (Group 7)

A perl script that matches the marker sequences from illumina reads  
(length = 40,60,80,100) to the partial hg38.  
  
The idea is to calculate how many of these markers appear in the first  
chromosome of human genome (hg38). The input files are of .fasta.gz format.  
 
Usage of stricts, and warnings was facilitated to create a clean code  
with good coding practices. There are check points in the script to make  
sure error handling, and lexical manner is maintained.   
 
Benchmarking for runtime, and memory was done using   
'/usr/bin/time -l perl read_pattern.pl' command  
in the zsh terminal (MacOS).

=end INTRODUCTION 
=cut  

#################################################################
##                     Declaring Variables                     ##
################################################################# 

my $ref = 'hg38_partial.fasta.gz';  
my $read1 = 'illumina_reads_40.fasta.gz';  
my $read2 = 'illumina_reads_60.fasta.gz';  
my $read3 = 'illumina_reads_80.fasta.gz';  
my $read4 = 'illumina_reads_100.fasta.gz'; 

## If you would like an output file, uncomment the next line 
## and line 258, 274, 301, 313, 370 as well    
# my $result = 'MatchedMarkers.txt';   
 
my $id = '';  
my $i = '';   
my $sequence = '';   
my $line = '';
my @seq = (); 
my %id2seq = ();  
   
 
#################################################################
##                    Reference genome hg38                    ##
#################################################################  
=begin FILE DETAILS   

.fasta.gz is a compressed version of .fasta. Hence, File reading was done  
such that it doesn't has to decompress but directly read, in turn, saving  
memory, and time. 
 
An output file would be generated at the end of file execution.

=end FILE DETAILS
=cut   

if ($ref =~ /.gz$/)  
    {
    open(REF, "gunzip -c $ref |") || die "cant open pipe to $ref";
    }
else  
    {
    open(REF, $ref) || die "cant open $ref";
    }   


## Calling the function to store reference  
## sequence from hg38 FASTA file

my $DNA = &read_fasta();   
 
## for checking in the reverse complementary sequence 
## my $DNAc = reverse $DNA;
 

#################################################################
##                   Illumina reads: Markers                   ##
#################################################################   

print "\n\nWhich read file do you want to use?\n1. illumina_reads_40.fasta.gz\n2. illumina_reads_60.fasta.gz\n3. illumina_reads_80.fasta.gz\n4. illumina_reads_100.fasta.gz\n\nPlease enter the option number:";
my $reads = <STDIN>;   
chomp $reads; 
 
if ($reads eq '1') 
    {
        if ($read1 =~ /.gz$/)  
            {
            open(RD, "gunzip -c $read1 |") || die "cant open pipe to $read1";
            }
        else  
            {
            open(RD, $read1) || die "cant open $read1";
            }   
    }
elsif ($reads eq '2') 
    {        
        if ($read2 =~ /.gz$/)  
            {
            open(RD, "gunzip -c $read2 |") || die "cant open pipe to $read2";
            }
        else  
            {
            open(RD, $read2) || die "cant open $read2";
            }  
    }  

elsif ($reads eq '3') 
    {
        if ($read3 =~ /.gz$/)  
            {
            open(RD, "gunzip -c $read3 |") || die "cant open pipe to $read3";
            }
        else  
            {
            open(RD, $read3) || die "cant open $read3";
            }   
    }  

elsif ($reads eq '4') 
    {
        if ($read4 =~ /.gz$/)  
            {
            open(RD, "gunzip -c $read4 |") || die "cant open pipe to $read4";
            }
        else  
            {
            open(RD, $read4) || die "cant open $read4";
            }  
    } 
else  
    { 
        print "\n\nPlease run the script again!\n\n"; 
        exit;
    } 
 
print "\nFASTA Files have been read. Done.\n\n"; 
print "Extracting marker sequences for searching in the hg38 reference genome. Done.\n\n";   
 
print "PLEASE READ: For memory, and time consuming problems, this script has been optimized for not counting zero \nmatches, only single or more matched counts will be calculated\n\n";
 
#################################################################
##                      Number of Queries                      ##
################################################################# 

## Reading the multi FASTA file and saving the ID's and sequence in the hash table 
## as key:value pair  

while(<RD>) 
    {
        chomp;
        if  ($_ =~ /^>(.+)/) 
            {
                $id = $1;
            } 
        else 
            {
                $id2seq{$id} .= $_;
            }
    }  
 

## Storing the sequences in an array  
## for different queries  

print "Select the number of queries for the selected read length:\n\n1.1000\n\n2.10,000\n\n3.100,000\n\n4.1,000,000\n\nPlease enter the option number:"; 
my $query = <STDIN>; 
chomp $query; 

if ($query eq '1') 
    {
     @seq =  (values %id2seq)[0..999];        
    }   
elsif ($query eq '2') 
    {
     @seq =  (values %id2seq)[0..9999];    
    }   
elsif ($query eq '3') 
    {
     @seq =  (values %id2seq)[0..99999];     
    }   
elsif ($query eq '4') 
    {
     @seq =  (values %id2seq)[0..999999];      
    } 
else 
    {  
     print "\n\nPlease run the script again!\n\n"; 
     exit;
    } 

#################################################################
##                          Searching                          ##
#################################################################  
=begin STRING MATCHING   

Perl has a strong regular expression matching, so a regex form was  
used to search, and display number of occurences for each sequence  
(key) in the reference genome, globally.  

=end STRING MATCHING 
=cut 
 
print "\n\nNaive (displaying total positive occurence count only) i.e. how many of the markers in the read file appear in the reference\n\nPress one: "; 
my $search = <STDIN>; 
chomp $search;   
  
if ($search eq '1') 
    {    
        # opening an output .txt file for storing results 
        # open(R, '>', $result) or die "Could not create the output file"; 
        print"Do you want to use index ? 'yes' or 'no'\n(If you say yes, then index function will be used[FASTER]\nIf you say no, then regex pattern matching function will be used[SLOWER])\nPlease enter:"; 
        my $index = <STDIN>; 
        chomp $index;  
        print "\n\nThis will take some time. Please be patient........\n\n"; 
        if($index eq "yes") 
            {
                foreach my $el (@seq)  
                    {    
                    # Using index to find the first match, and skip the  
                    # file and move on to another sequence to match
                    if (index($DNA, $el) != -1) 
                        { 
                            print"Sequence: $el | Match\n"; 
                            # Output file only with matched  
                            # sequences seperated by newline char \n
                            # print R "$el\n"; 
                            $i++; 
                        }                     
                    }    
                    print "\n\nFor the selection of read length, and query length, $i biomarkers appeared in the hg38 sequence based on a 'naive search' algorithm.\n\n"; 
                    print "These $i occurences are the important sequences that can be processed for further analysis.\n\n";  
                    # close(R) || die "Unable to close $result\n";  
            } 
        elsif($index eq "no") 
            {
                foreach my $el (@seq)  
                { 
                    # Storing the binary count of every sequence  
                    # using regex operators =~, and m//gi used for  
                    # matching at least once. Adding /g will provide  
                    # the exact number of matches globally 
                    my $count = () = $DNA =~ m/$el/;    
                    
                    # condition for the counts     
                    unless($count eq 0)
                    {    
                        # Displaying the sequences which have  
                        # non-zero counts of matching (occurs at least once) 
                        print "Sequence: $el | Match\n";   
            
                        # Output file only with matched  
                        # sequences seperated by newline char \n
                        # print R "$el\n";   
                        
                        
                        # a counter to count number of biomarkers that appeared  
                        # in the genome out of selected query length  
                        $i++; 
                    } 
                            
                } 
            }     
            print "\n\nFor the selection of read length, and query length, $i biomarkers appeared in the hg38 sequence based on a 'naive search' algorithm.\n\n"; 
            print "These $i occurences are the important sequences that can be processed for further analysis.\n\n";  
            # close(R) || die "Unable to close $result\n";
    }   

 
## @@@ Suffix-based array @@@   
## === started uusing a module but Couldn't finish due to time and exhaustion === ## 
## Later found out that the libstree library couldn't symlink to Tree::Suffix     ## 
## Unfortunately, it had to stopped there in perl implementation                  ##   

     
## Auto-flush special variable: 
## It forces a flush after every write or print, so the output  
## appears as soon as it's generated rather than being buffered.    

# elsif ($search eq '2') 
#     {  
#       $|=1; 
#       my $tree = SuffixTree->new($DNA);
#       $tree->dump();  
#     }   
 
#################################################################
##                          Subroutines                        ##
#################################################################  

## Subroutine (function) for reading, and parsing FASTA files
sub read_fasta
    {   
        # looping over the open file handle  
        while(<REF>)
            { 
                # using default global variable $_ 
                $line = $_; 

                # removing any newline characters 
                chomp($line); 
                # removing FASTA header 
                if($line =~ /^>/) 
                    {  
                        next;  
                    } 
                # append 
                else  
                    {  
                        $sequence .= $line  
                    } 
            }  
        # only the parsed DNA sequence remains 
        return($sequence);
    }   
   
## close the original file handlers   

close(RD) || die "Unable to close the read file\n";  
close(REF) || die "Unable to close the reference file\n";     

## raincheck: this line will only print if everything went fine ;)
# print "\n\nPlease check YOUR DIRECTORY for 'MatchedMarkers.txt'.\n\n";  
 
## exit code
exit();
 
__END__ 
 
This script can be easily modified to suit the 
needs for short or long sequence matching according  
to user's requirements. Calling another script 
or passing argument variables is also manageable  
to make it a standalone sequence matcher. 
 
Some modifications might be done for contigs, motifs,  
etc to account for biological intricacies. 
 
For that scenarios, using BioPerl is recommended. 
