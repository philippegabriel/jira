#!/usr/bin/perl
# Input 
# STDIN
#	a csv file in YYYYmm,Issue,... format
# STDOUT
# 	STDIN, with duplicate Issues removed
#
$count=0;
while(<>){
	$line=$_;
	($date,$wk,$cat,$issue)=split(/,/);
#ignore comment lines and skip duplicates
	if($issue eq '')
		{print $line;next;}
 	if($seen{$issue})
		{next;}
	$seen{$issue}=1;
	print $line;
	$count+=1;
}

