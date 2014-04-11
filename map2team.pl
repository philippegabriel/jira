#!/usr/bin/perl
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
#Note: Assumes the input doesn't span accross multiple years
my %sprints;
@sprints=qw(02 04 06 08 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52);
map{my $sprintId = $_;map{$sprints{$sprintId.$_}=0}@teams}@sprints;
#foreach my $key (sort keys %sprints){print "$key\n";} #debug - check %sprints hash
#Map each issue to its team and sprint
while(<STDIN>){
	chomp;
	my($year,$week,$issueId,$name,$rel)=split(/,/);
#map name to team
	my $team=$map2team{$name};
#map week to sprint
#sprint are always even week, so assume previous odd week is in same sprint
	$sprintId=sprintf("%02d",$week+1 & hex '0xFFFE'); #map odd week to following even week
#concatenate team name
	$sprintId.=$team;
	$sprints{$sprintId}++;
#print $year.','.$week.','.$issueId.','.$name.','.$rel.','.$sprintId.','.$team."\n"; # debug - mapping
}
#output final result
print 'sprint,'.join(',',@teams)."\n";
foreach(@sprints){
	$sprintId = $_;print $_;
	foreach(@teams){
		print ",$sprints{$sprintId.$_}"
	}
	print "\n";
}
exit 0;

