#!/usr/bin/perl
use POSIX qw(strftime);
use Getopt::Long;
$debug=0;

GetOptions("startweek=s" => \$startwk,"team=s" => \$team);
$startwk eq '' and die("ERROR:missing argument --startweek");
$team eq '' and die("ERROR:missing argument --team");

#Parse start date
$startwk=~ /(\d\d)wk(\d\d)/;
$startYear=$1;
$startWeekNumber=$2;
$debug and print $startYear,$startWeekNumber,"\n"; 

#Find current date, see http://en.wikipedia.org/wiki/Date_(Unix)
$endwk = strftime "%ywk%V", localtime;
$debug and print '>'.$endwk.'<',"\n";

$startwk gt $endwk and die("Starting week: $startwk must be in the past");

$i=$startYear; $j=$startWeekNumber;
while(1){
	$k=sprintf("%02dwk%02d",$i,$j);
	push (@wk , $k);
	if($k eq $endwk)
		{last;}
	++$j;
	if($j == 53)
		{$j=1;++$i;}
}
$debug and map{print $_.','}@wk and print "\n";
#$year=$YearNow; #assumes the project doesn't span accross years

#Build an array of weeks 
#@wk=map{$year.'wk'.$_} ($startwk..$endwk);
#$startwkTag=$year.'wk'.$startwk;
@inflowCat=qw(C+ V+ P+ T+ O+);
@outflowCat=qw(R- V- P- T-);
@cat=(@inflow,@outflow);

#parse the totals
#foreach(@pri){
	$file="$team.report.csv";
#grep the CAs
	-e $file or die "ABORT: $file NOT FOUND!\n";
	@CAs= `grep -E CA-[0-9]+ $file`;
#print "$file:",join(',',@CAs),"\n";
#Iterate through CAs
	foreach(@CAs){
	($date,$wk,$cat,$issue)=split(/,/);
#print "$date,$wk,$cat,$issue\n";
#Normalise wk number
#Anything that happened before $startwk is accounted to that $startweek
	if($wk lt $startwk)
		{$wk = $startwk;}
	$total{$team,$wk,$cat}+=1;
	if($cat =~ /\+/)
		{$wkinflow{$wk}{$issue}+=1}
	else
		{$wkoutflow{$wk}{$issue}+=1}
	}
#generate the csv
$ppteam = $team;
$ppteam =~ s/,/ & /g; # pretty print team(s)
#foreach(@pri){
#initialise arrays
	@outflow=();@inflow=();@cumul=();@unresEnd=();
	@wkinflow=();@wkoutflow=();
	map{$outStr{$_}=''}@outflowCat;
	map{$inStr{$_}=''}@inflowCat;
	$cumul=0;$unres=0;
	foreach(@wk){
		$wk=$_;
#Compute the Outflow
		$outflow=0;
		map{$outflow+=$total{$team,$wk,$_}}@outflowCat;
		push(@outflow,$outflow);
		$i=0;
		if(defined %wkoutflow{$wk}){
			$i=scalar (keys %wkoutflow{$wk})}
		push(@wkoutflow,$i);
#Compute the Inflow, cumulative inflow, Unresolved per week
		$inflow=0;
		map{$inflow+=$total{$team,$wk,$_}}@inflowCat;
		$cumul+=$inflow;
		$unres+=$inflow-$outflow;
		push(@inflow,$inflow);
		$i=0;
		if(defined  %wkinflow{$wk}){
			$i=scalar (keys %wkinflow{$wk})}
		push(@wkinflow,$i);
		push(@cumul,$cumul);
		push(@unresEnd,$unres);
#Generate string for all categories of outflow
		map{$outStr{$_}.= ",$total{$team,$wk,$_}"}@outflowCat;
#Generate string for all categories of inflow
		map{$inStr{$_}.= ",$total{$team,$wk,$_}"}@inflowCat;
	}
#Compute the Unresolved at start of week
	@unresStart=@unresEnd;
	pop(@unresStart);
	unshift(@unresStart,0);
#Output the csv data
	$pri =~ s/,/ & /g; # pretty print priority
	print "team,$ppteam,priority BCM\n";
	print 'week,',join(',',@wk),"\n";
#	print 'unresolved (start of week),',join(',',@unresStart),"\n";
	map{print $_,$inStr{$_},"\n"}@inflowCat;
#	print 'computed inflow,',join(',',@inflow),"\n";
	print 'inflow,',join(',',@wkinflow),"\n";
	map{print $_,$outStr{$_},"\n"}@outflowCat;
#	print 'computed outflow,',join(',',@outflow),"\n";
	print 'outflow,',join(',',@wkoutflow),"\n";
#	print 'unresolved (end of week),',join(',',@unresEnd),"\n";
#	print 'cumulative defects raised,',join(',',@cumul),"\n";
	print "\n";
#}
exit 0;

