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
@pri =('BC','M');
@inflowCat=qw(C+ V+ P+ T+ O+);
@outflowCat=qw(R- V- P- T-);
@cat=(@inflow,@outflow);

#parse the totals
foreach(@pri){
	$pri=$_;
	$file="$team.$pri.report.csv";
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
	$total{$team,$wk,$cat,$pri}+=1;
	}
}
#generate the csv
$ppteam = $team;
$ppteam =~ s/,/ & /g; # pretty print team(s)
foreach(@pri){
	$pri=$_;
#initialise arrays
	@outflow=();@inflow=();@cumul=();@unresEnd=();
	map{$outStr{$_}=''}@outflowCat;
	map{$inStr{$_}=''}@inflowCat;
	$cumul=0;$unres=0;
	foreach(@wk){
		$wk=$_;
#Compute the Outflow
		$outflow=0;
		map{$outflow+=$total{$team,$wk,$_,$pri}}@outflowCat;
		push(@outflow,$outflow);
#Compute the Inflow, cumulative inflow, Unresolved per week
		$inflow=0;
		map{$inflow+=$total{$team,$wk,$_,$pri}}@inflowCat;
		$cumul+=$inflow;
		$unres+=$inflow-$outflow;
		push(@inflow,$inflow);
		push(@cumul,$cumul);
		push(@unresEnd,$unres);
#Generate string for all categories of outflow
		map{$outStr{$_}.= ",$total{$team,$wk,$_,$pri}"}@outflowCat;
#Generate string for all categories of inflow
		map{$inStr{$_}.= ",$total{$team,$wk,$_,$pri}"}@inflowCat;
	}
#Compute the Unresolved at start of week
	@unresStart=@unresEnd;
	pop(@unresStart);
	unshift(@unresStart,0);
#Output the csv data
	print 'team,'.$ppteam."\n";
	$pri =~ s/,/ & /g; # pretty print priority
	print "priority,$pri\n";
	print 'week,',join(',',@wk),"\n";
	print 'unresolved (start of week),',join(',',@unresStart),"\n";
	map{print $_,$inStr{$_},"\n"}@inflowCat;
	print 'inflow,',join(',',@inflow),"\n";
	map{print $_,$outStr{$_},"\n"}@outflowCat;
	print 'outflow,',join(',',@outflow),"\n";
	print 'unresolved (end of week),',join(',',@unresEnd),"\n";
	print 'cumulative defects raised,',join(',',@cumul),"\n";
	print "\n";
}
exit 0;

