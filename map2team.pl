#!/usr/bin/perl
use POSIX qw(strftime);
#first argument is the map of people to team
$mapfile=$ARGV[0];
#populate the team map
my %map2team,%teams;
open my $fd, $mapfile or die("Couldn't open $mapfile");
while(<$fd>){
	chomp;
	my ($id,$team) = split(/,/);
	$team eq '' and next;
	$map2team{$id} = $team;
	$teams{$team} = 1;
}
close $fd;
my @teams=sort keys %teams;
#foreach(@teams){print ">$_<\n";} # debug - check content of teams
#initialise sprint hash, from teams and sprint arrays
#Find current date
$YearNow = strftime "%Y", localtime;
@year=(2005..$YearNow); #magic! 2005 beginning of jira records
my %sprints;
@evenWeeks=qw(02 04 06 08 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52);
map{my $year=$_;map{my $sprintId = $_;map{$sprints{$year.'w'.$sprintId.$_}=0}@teams}@evenWeeks}@year;
#foreach my $key (sort keys %sprints){print "$key\n";} ;exit0; #debug - check %sprints hash
#Map each issue to its team and sprint
my %seen; #remove duplicate 
while(<STDIN>){
	chomp;
	my($year,$week,$issueId,$priority,$name,$rel)=split(/,/);
#skip issue if already accounted for
	$seen{$issueId} and next;
	$seen{$issueId}=1;
#map name to team
	my $team=$map2team{$name};
#map week to sprint
#sprint are always even week, so assume previous odd week is in same sprint
	$week=sprintf("%02d",$week+1 & hex '0xFFFE'); #map odd week to following even week
#prepend Year an append team name
	$sprintId= $year.'w'.$week.$team;
	$sprints{$sprintId}++;
#print $year.','.$week.','.$issueId.','.$name.','.$rel.','.$sprintId.','.$team."\n"; # debug - mapping
}
#output final result
print ',sprint,'.join(',',@teams)."\n";
$i=0;
foreach(@year){
	$year=$_;
	foreach(@evenWeeks){
		$sprintId = $_;print $i++.','.$year.'w'.$sprintId;
		foreach(@teams){
			print ",$sprints{$year.'w'.$sprintId.$_}";
		}
	print "\n";
	}
}
exit 0;

