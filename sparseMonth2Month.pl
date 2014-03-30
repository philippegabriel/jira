#!/usr/bin/perl
#takes a csv file in month,<number> format
#Add a row: <month>,0 for months missing from original data file
use POSIX qw(strftime);
#Find current date
$YearNow = strftime "%Y", localtime;
$MonthNow = strftime "%m", localtime;
$now=$YearNow.$MonthNow;
#printf("date - $YearNow $MonthNow\n");
@month=qw(01 02 03 04 05 06 07 08 09 10 11 12);
@year=(2008..$YearNow); #magic! 2008 beginning of XS
my @indices = map {$year=$_;map{$date=$year.$_;$date<=$now?$date:''}@month}@year;
%output; map {$output{$_}=0}@indices; #initialise the output hash
#Read STDIN and store in output hash
while(<>){
chomp;
($date,$count)=split(/,/);
$output{$date}=$count;
}
#print the output hash
$i=0;
foreach my $key (sort keys %output) {$key eq '' and next ; $i++ ; print "$i,$key,$output{$key}\n";}
exit 0;




