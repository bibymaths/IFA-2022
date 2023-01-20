#!/usr/bin/env perl 

use strict; 
use warnings;   
  
=begin Under Construction  
=== To-do === 

1. Adding the STDIO U/I (queries, selecting reads: passing as arguments) with SSH wrapper  

2. Memory, and runtime benchmarking   

3. Output file generation

=end Under Construction  
=cut 

=begin Usage   
Download and put this script and all .fasta.gz files [/data folder] in the same directory. 

Command line (unix/macos): perl read_pattern.pl  

For a windows user, you have to install perl or active state software to run it using an IDLE 
=end Usage 
=cut
 
=begin Introduction  

Author: Abhinav Mishra (Group 7)

A perl script that matches the marker sequences from illumina reads  
(length = 40,60,80,100) to the first chromosome of the human genome.  
  
The idea is to calculate how many of these markers appear in the first  
chromosome of human genome (hg38). 

The input files are of .fasta.gz format.  
 
Usage of stricts, and warnings was facilitated to create a clean code with good coding practices.  

=end Introduction 
=cut  

#################################################################
##                     Declaring Variables                     ##
################################################################# 

my %id2seq = ();
my $id = '';
my $ref = 'hg38_partial.fasta.gz';  
my $read1 = 'illumina_reads_40.fasta.gz';  
#my $read2 = 'illumina_reads_60.fasta.gz';  
#my $read3 = 'illumina_reads_80.fasta.gz';  
#my $read4 = 'illumina_reads_100.fasta.gz';    
 
=begin File   

The .fasta files are compressed into .fasta.gz. 
File reading was done such that it doesn't has  
to decompress, in turn, saving memory, and time 

=end File 
=cut  

#################################################################
##                    Reference genome hg38                    ##
################################################################# 

if ($ref =~ /.gz$/)  
    {
    open(TXT, "gunzip -c $ref |") || die "cant open pipe to $ref";
    }
else  
    {
    open(TXT, $ref) || die "cant open $ref";
    }  

#################################################################
##                   Illumina reads: Markers                   ##
#################################################################
 
if ($read1 =~ /.gz$/)  
    {
    open(RD1, "gunzip -c $read1 |") || die "cant open pipe to $read1";
    }
else  
    {
    open(RD1, $read1) || die "cant open $read1";
    }

 
print "FASTA Files have been read\n"; 
print "Extracting marker sequences for searching \n in the hg38 reference genome"; 

## Calling the function to read FASTA file

my $DNA = &read_fasta();
 
## Reading the multi FASTA file and saving the ID's and sequence in the hash table 
## as key:value pair 

while(<RD1>) 
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
 
## Reversing the hash-table to make read sequences "key" from "values" 

my %reads = reverse %id2seq;  
 
## Storing the sequences in an array
my @seq = keys %reads; 
 
print "This will take some time. Please be patient........"; 
 
#################################################################
##                          Searching                          ##
#################################################################

=begin String Matching   

Perl has a strong regular expression matching, so a regex form was  
used to search, and display number of occurences for each sequence  
(key) in the reference genome, globally.  

=end String Matching 
=cut 
 
## Accessing elements of the sequence array without using index 
## => Naive search <=

## Changing the mapping to the array will make it suffix-based  
## array search 

for my $el (@seq)  
    { 
        # Counts using regex operators =~, and m//gi 

        my $count = () = $DNA =~ m/$el/gi;    

        # Displaying the sequences, and  
        # their number of occurences  

        print "$el \n Matches: $count\n";  
    } 

print "JOB IS FINISHED. \n Please check YOUR DIRECTORY  
with files: \n read_match40.txt, read_match60.txt,  
read_match80.txt, read_match100.txt";  
 
## Closing the File handlers to avoid memory dump

close(RD1); 
close(TXT);

## Subroutine (function) for reading, and parsing FASTA files

sub read_fasta
    {   
        # blank variable 

        my $sequence = ""; 

        # looping over the open file handle  

        while(<TXT>)
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

## Exit code, useful for command-line 

exit();