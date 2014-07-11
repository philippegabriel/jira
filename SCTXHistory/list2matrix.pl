#!/usr/bin/perl
# Input 
# arg1: a file listing XS releases
# On STDIN, a csv file in YYYYmm,Issue,release name
# Output
# A matrix of number of issues
# y: month, x: releases
#
use POSIX qw(strftime);
#
#read the 'releases' file into array
#
$fname=$ARGV[0];
open my $fd, $fname or die("Couldn't open $fname");
chomp(my @xsreleases = <$fd>);
close $fd;
#
#Enumerate years and months, from 2008 until now and initialise the time series
#
#Find current date
$YearNow = strftime "%Y", localtime;
$MonthNow = strftime "%m", localtime;
#printf("date - $YearNow $MonthNow\n");
@month=qw(01 02 03 04 05 06 07 08 09 10 11 12);
@year=(2008..$YearNow-1); #magic! 2008 beginning of XS
my @indices = map {$year=$_;map{$date=$year.$_}@month}@year;
foreach(@month){
	$_<=$MonthNow and push (@indices,$YearNow.$_);
}
#declare hash output
my %output; 
#declare hash to avoid double counting issues
my %seen;
map {$i=$_;map{$output{$i.$_}=0}@xsreleases}@indices; #initialise the output hash
#
#Read STDIN, map line to a release and sum issue by month by releases
#
while(<STDIN>){
	chomp;
	($date,$issue,$rel)=split(/,/);
#avoid double counting
	if($seen{$issue})
		{next;}
	foreach(@xsreleases){
#		$rel =~ /$_/ and $output{$date.$_}+=1 and print "$date,$issue,$rel match $_\n" and last;
		$rel =~ /$_/ and $output{$date.$_}+=1 and last;
	}
	$seen{$issue}=1;
}
#print header
print "rank,month";
map{print ",$_"}sort @xsreleases;
print "\n";
#print the output hash
$rank=1;
foreach(@indices){
	print "$rank,$_";
	$i=$_;
	$rank++;
	map{print ",$output{$i.$_}"}sort @xsreleases;
	print "\n";
}
exit 0;




