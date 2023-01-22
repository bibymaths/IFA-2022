#!/usr/bin/env perl 
  
use strict; 
use warnings;    
use diagnostics; 
use Data::Dumper;

=begin USAGE  

Only core modules of perl were used. Most perl versions have  
standard modules already installed.  
 
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
my $result = 'MatchedMarkers.txt'; 

my $id = '';  
my $i = '';  
my %id2seq = ();   
my @seq = ();   
 
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

print "Select the number of queries for read length of 100 (illumina_reads_100.fasta.gz):\n\n1.1000\n\n2.10,000\n\n3.100,000\n\n4.1,000,000\n\nPlease enter the option number:"; 
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
 
print "\n\nWhich search you want to perform ?\n\n1. Naive (displaying total positive occurence count only)\ni.e. how many of the markers in the read file appear in the reference\n\n2. Suffix-array based (displaying positive matches with substrings)\n\nPlease enter the option number: "; 
my $search = <STDIN>; 
chomp $search;

print "\n\nThis will take some time. Please be patient........\n\n"; 
 
## @@@ Naive search @@@    

if ($search eq '1') 
    {    
        # opening an output .txt file for storing results 
        open(R, '>', $result) or die "Could not create the output file";  

        foreach my $el (@seq)  
            { 
                # Storing the binary count of every sequence  
                # using regex operators =~, and m//gi used for  
                # matching at least once. Adding /g will provide  
                # the exact number of matches globally 
                my $count = () = $DNA =~ m/$el/;    

                # condition for the counts     
                if ($count ne 0)
                {    
                    # Displaying the sequences which have  
                    # non-zero counts of matching (occurs at least once) 
                    print "Sequence: $el | Match\n";   
         
                    ## Output file only with matched  
                    ## sequences seperated by newline char \n
                    print R "$el\n";  
                     
                    # a counter to count number of biomarkers that appeared  
                    # in the genome out of selected query length  
                    $i++;
                }   
                 
            }  
            print "\n\nBased on the selection of read length, and query length, $i biomarkers appeared in the hg38 sequence.\n\n"; 
            print "These $i occurences are the important sequences that can be processed for further analysis."; 
    }   

 
## @@@ Suffix-based array @@@ 

# elsif ($search eq '2') 
#     {  
#         suffarr();
#     }   

## Subroutine (function) for reading, and parsing FASTA files
sub read_fasta
    {   
        # blank variable 
        my $sequence = ""; 
        # looping over the open file handle  
        while(<REF>)
            { 
                # using default global variable $_ 
                my  $line = $_; 

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
 
# sub suffarr 
#     { 
#         # input string
#         my @string = @seq;       
#         # hash ref                   
#         my $parts;          
#         # break input into tokens  
#         foreach my $string (@string) 
#             {                           
#                 my @$suffixes = split '',$string;               
#                 my $running_sum   = 0;
#                 $"=''; 
#             }

#         # Build suffix tree
#         for (0..$#suffixes) 
#             {
#                 $parts->{"@suffixes"}=0;
#                 shift @suffixes;
#             }

#         # Compare suffixes to initial string
#         for my $suffix (sort keys %$parts) 
#             {
#                 $parts->{$suffix}  =  getMatch($suffix,$string);
#                 $running_sum      +=  $parts->{$suffix};
#             }

#         # Output
#         $Data::Dumper::Sortkeys++;
#         print Dumper($parts), "\nTotal Matches: $running_sum";
#     }
  
# sub getMatch 
#     {
#         my ($word,$string) = @_; 
#         my $part    = '';
#         my $offset  = 0;
#         my $matches = 0;

#         for (0..(length($word) - 1)) 
#             {
#                     $offset++;
#                     $part = substr($word,0,$offset); 

#                     if ($string =~ /^$part/) 
#                         {  
#                             $matches++;  
#                         }
#             }
#         return $matches;
#     }

## close the file handlers 

close(RD) || die "Unable to close the read file\n";  
close(REF) || die "Unable to close the reference file\n"; 
close(R) || die "Unable to close $result\n";    

## raincheck: this line will only print if everything went fine ;)
print "\n\nPlease check YOUR DIRECTORY for 'MatchedMarkers.txt'.\n\n";  
 
# exit code
exit();