#!/usr/bin/perl
#Param:  file containing list of CAs as inflow
#Input 
# STDIN
#	a csv file in YYYYmm,Issue,... format, containing the list of CAs as outflow
# STDOUT
# 	STDIN, with duplicate Issues and Issues not appearing in the Inflow removed
#
#get name of inflow file
$file=shift  @ARGV;
#grep the CAs, from inflow file
@inflow= `grep -Eo CA-[0-9]+ $file`;
chomp @inflow;
# convert array to a hash with the array elements as the hash keys and the values are simply 1
my %inflow = map {$_ => 1} @inflow;
#print 'inflow.csv:',join("\n",@inflow),"\n"; exit 0;
#Iterate through the outflow file
$count=0;
while(<>){
	$line=$_;
	($date,$wk,$cat,$issue)=split(/,/);
#Ignore issues not appearing as Inflow
	if (not defined $inflow{$issue}) {
		warn "NOT in INFLOW:$line";
		next;
	}
#ignore comment lines and skip duplicates
	if($issue eq ''){
		print $line;next;
	}
 	if($seen{$issue}){
		warn "DUP:$line";
		next;
	}
	$seen{$issue}=1;
	print $line;
	$count+=1;
}

