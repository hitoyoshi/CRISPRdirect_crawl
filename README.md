CRISPRdirect_crawl.pl
======================

This script uses LWP::UserAgent to get CRISPR/Cas9 gRNAs from [CRISPRdirect]
(http://crispr.dbcls.jp/). LWP::UserAgent module is available at CPAN.

### Usage ###

	% ./CRISPRdirect_crawl.pl  sequence.txt

sequence.txt is a single FASTA file or a plain nucleotide sequence file 
(i.e., only contains nucleotide sequence). Characters other than A,T,G,C 
and U are ignored. Both lower-case and upper-case letters are accepted.

### Example of sequence.txt ###

	>sample sequence
	atgccgcgcgtcgtgcccgaccagagaagcaagttcgagaacgaggagttttttaggaag
	ctgagccgcgagtgtgagattaagtacacgggcttcagggaccggccccacgaggaacgc
	caggcacgcttccagaacgcctgccgcgacggccgctcggaaatcgcttttgtggccaca
	ggaaccaatctgtctctccagttttttccggccagctggcagggagaacagcgacaaaca
	cctagccgagagtatgtcgacttagaaagagaagcaggcaaggtatatttgaaggctccc
	atgattctgaatggagtctgtgttatctggaaaggctggattgatctccaaagactggat
	ggtatgggctgtctggagtttgatgaggagcgagcccagcaggaggatgcattagcacaa
	caggcctttgaagaggctcggagaaggacacgcgaatttgaagatagagacaggtctcat
	cgggaggaaatggaggcaagaagacaacaagaccctagtcctggttccaatttaggtggt
	ggtgatgacctcaaacttcgttaa

If you plan to submit a large number of queries, please insert 'sleep' 
command to prevent overloading CRISPRdirect web server.

### Example ###

	% ls
	CRISPRdirect_crawl.pl    CRISPRdirect_input/    CRISPRdirect_result/
	% cd  CRISPRdirect_input/
	% ls
	NM_000014.fa    NM_000015.fa    NM_000016.fa    [...]
	% foreach  n  ( * )
	../CRISPRdirect_crawl.pl  $n >  ../CRISPRdirect_result/$n.CRISPR
	sleep  5
	end
	% cd ../CRISPRdirect_result/
	% ls
	NM_000014.fa.CRISPR    NM_000015.fa.CRISPR    NM_000016.fa.CRISPR    [...]

### Options ###

CRISPRdirect options can be set using ```%param```. 
All of the parameters and values are described in the API section of 
CRISPRdirect [help page](http://crispr.dbcls.jp/doc/).

![parameters]
(http://g86.dbcls.jp/~meso/meme/wp-content/uploads/2014/12/CRISPRdirect_param.png
"CRISPRdirect parameters")

**Example 1.**
Parameters for designing human gRNAs with 'NGG' for PAM:

	my %param = (
		'userseq'   => $input_seq,
		'pam'       => 'NGG',
		'db'        => 'hg19',
		'format'    => 'txt',
	) ;

**Example 2.**
Parameters to get NM_001187 sequence in FASTA format:

	my %param = (
		'accession' => 'NM_001187',
		'format'    => 'txt',
	) ;

### CRISPRdirect web server ###

http://crispr.dbcls.jp/

### Reference ###

Naito Y, Hino K, Bono H, Ui-Tei K. (2014)  
CRISPRdirect: software for designing CRISPR/Cas guide RNA with 
reduced off-target sites.  
*Bioinformatics* http://dx.doi.org/10.1093/bioinformatics/btu743


License
-------

Copyright &copy; 2014 Yuki Naito
 ([@meso_cacase](http://twitter.com/meso_cacase)) at  
Database Center for Life Science (DBCLS), Japan.  
This software is distributed under [modified BSD license]
 (http://www.opensource.org/licenses/bsd-license.php).
