#!/usr/bin/perl

# This script uses LWP::UserAgent to get CRISPR/Cas9 gRNAs from CRISPRdirect
# (http://crispr.dbcls.jp/). LWP::UserAgent module is available at CPAN.
#
# Usage:
# ./CRISPRdirect_crawl.pl  sequence.txt
#
# sequence.txt is a single FASTA file or a plain nucleotide sequence file
# (i.e., only contains nucleotide sequence). Characters other than A,T,G,C
# and U are ignored. Both lower-case and upper-case letters are accepted.
#
# ================= Example of sequence.txt ==================
# >sample sequence
# atgccgcgcgtcgtgcccgaccagagaagcaagttcgagaacgaggagttttttaggaag
# ctgagccgcgagtgtgagattaagtacacgggcttcagggaccggccccacgaggaacgc
# caggcacgcttccagaacgcctgccgcgacggccgctcggaaatcgcttttgtggccaca
# ggaaccaatctgtctctccagttttttccggccagctggcagggagaacagcgacaaaca
# cctagccgagagtatgtcgacttagaaagagaagcaggcaaggtatatttgaaggctccc
# atgattctgaatggagtctgtgttatctggaaaggctggattgatctccaaagactggat
# ggtatgggctgtctggagtttgatgaggagcgagcccagcaggaggatgcattagcacaa
# caggcctttgaagaggctcggagaaggacacgcgaatttgaagatagagacaggtctcat
# cgggaggaaatggaggcaagaagacaacaagaccctagtcctggttccaatttaggtggt
# ggtgatgacctcaaacttcgttaa
# ============================================================
#
# If you plan to submit a large number of queries, please insert
# 'sleep' command to prevent overloading CRISPRdirect web server.
#
# Example:
# % ls
# CRISPRdirect_crawl.pl    CRISPRdirect_input/    CRISPRdirect_result/
# % cd  CRISPRdirect_input/
# % ls
# NM_000014.fa    NM_000015.fa    NM_000016.fa    [...]
# % foreach  n  ( * )
# ../CRISPRdirect_crawl.pl  $n >  ../CRISPRdirect_result/$n.CRISPR
# sleep  5
# end
# % cd ../CRISPRdirect_result/
# % ls
# NM_000014.fa.CRISPR    NM_000015.fa.CRISPR    NM_000016.fa.CRISPR    [...]
#
# Options:
# CRISPRdirect options can be set using %param. All of the parameters and
# values are described in the API section of CRISPRdirect help page.
#
# Example 1)  Parameters for designing human gRNAs with 'NGG' for PAM:
# my %param = (
# 	'userseq'   => $input_seq,
# 	'pam'       => 'NGG',
# 	'db'        => 'hg19',
# 	'format'    => 'txt',
# ) ;
#
# Example 2)  Parameters to get NM_001187 sequence in FASTA format:
# my %param = (
# 	'accession' => 'NM_001187',
# 	'format'    => 'txt',
# ) ;
#
# CRISPRdirect web server:
# http://crispr.dbcls.jp/
#
# Reference:
# Naito Y, Hino K, Bono H, Ui-Tei K. (2014) CRISPRdirect: software for
# designing CRISPR/Cas guide RNA with reduced off-target sites.
# Bioinformatics http://dx.doi.org/10.1093/bioinformatics/btu743
#
# 2014-12-01 by Yuki Naito at Database Center for Life Science (DBCLS), Japan
#

use warnings ;
use strict ;
use LWP::UserAgent ;

my $input_seq = join '', <> ;

my %param = (
	'userseq'   => $input_seq,  # Input DNA sequence; FASTA format or 
	                            # a plain DNA sequence up to 10 kbp.
#	'accession' => 'NM_001187', # Retrieve sequence mode. Set an accession
	                            # number to retrieve sequence from GenBank
	                            # instead of designing CRISPR/Cas targets.
	                            # Genome location is also accepted for
	                            # hg19, mm10, rn5, galGal4, xenTro3,
	                            # danRer7, ci2, dm3, ce10 and sacCer3.
	                            # The variable userseq should be null.
	                            # The variable format should be html or txt.
	'pam'       => 'NGG',       # 3 nt PAM sequence using IUB codes;
	                            # 'NGG' (default), 'NAG', etc.
	'db'        => 'hg19',      # Set species for off-target searching;
	                            # 'hg19' for human, 'mm10' for mouse, etc.
	'format'    => 'txt',       # Output format: html (default), txt or json
#	'download'  => 'download',  # Set 'download' to download result as
	                            # a file via web browser. This parameter
	                            # has no effect in this perl script.
) ;

my $txt = crawl_CRISPRdirect(%param) ;
print $txt ;

exit ;

# ====================
sub crawl_CRISPRdirect {
my %param = @_ ;
my $ua = LWP::UserAgent->new ;
my $response = $ua->post('http://crispr.dbcls.jp/', \%param) ;
return $response->content ;
} ;
# ====================
