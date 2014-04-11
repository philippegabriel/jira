#!/usr/bin/perl
#first argument is the map of people to team
@teams=split(/ /,$ARGV[0]);
$fnametemplate=$ARGV[1];
$inflow=$ARGV[2];
$outflow=$ARGV[3];
#populate the team map
open my $fd1, $inflow  or die("Couldn't open $inflow");
open my $fd2, $outflow or die("Couldn't open $outflow");
@inflow=<$fd1>;@outflow=<$fd2>; #buffer the files
shift @inflow;shift @outflow; #skip first header line
chomp @inflow;chomp @outflow; #skip first header line
close $fd1;close $fd2;
#accumulate output in teams hash
%teams;
foreach(@inflow){
	@inflowRow=split(/,/); 
	@outflowRow= split(/,/,shift @outflow);
	$sprintID=shift @inflowRow;
	$discard=shift @outflowRow;
	foreach(@teams){
#		printf("%s,%s,%s\n",$sprintID,shift @inflowRow,shift @outflowRow);
		$row=sprintf("%s,%s,%s\n",$sprintID,shift @inflowRow,shift @outflowRow);
		$teams{$_}.=$row;
	}
}
foreach(@teams){
	my $filename = $fnametemplate.'.'.$_.'.csv';
	open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
	print $fh $teams{$_};
	close $fh;	
}
exit 0;

