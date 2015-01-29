#!/usr/bin/perl

use strict;
use CGI qw( :standard );
sub abort {
my ($err,$msg)=@_;
print "<h2 class=\"error\">Error: $err</h2>\n<p>$msg</p>";print end_html."\n";exit -1;
}
#fetch CGI parameters
my $names=param( "names" );
$names =~ s/ //g;
my $startdate=param( "startdate" );
$startdate =~ s/ //g;
my $enddate=param( "enddate" );
$enddate =~ s/ //g;
my $projects=uc(param( "projects" ));
$projects =~ s/ //g;

#start emitting html
print header( "text/html" );
print start_html(	-title => "Jira Historical Ticket Query", 
			-style => "query.css",
			-expires=>'+1d');
#display the parameters
print << "HTML";
<h2 class="banner">Jira Historical Ticket Query</h2>
<table class="noborder">
<tr><td class="bold">Name(s):</td><td>$names</td></tr>
<tr><td class="bold">Project(s):</td><td>$projects</td></tr>
<tr><td class="bold">Start Date:</td><td>$startdate</td></tr>
<tr><td class="bold">End Date:</td><td>$enddate</td></tr>
</table>
HTML

#parameter validation
($names ne "" and $startdate ne "" and $enddate ne "" and $projects ne "") or abort("One or more parameter is null","");


#invoke the Jira query
my $makeout=`make names="$names" startdate=$startdate enddate=$enddate projects=$projects`;
#print "$makeout\n";
$makeout =~ s/\n/<br>/g;

#Look for csv files
my $report = glob "jira.report.$names.$projects.from.$startdate.to.$enddate.csv"; 
my $ticketlist = glob "jira.ticketlist.$names.$projects.from.$startdate.to.$enddate.csv"; 
#abort if report is not found
open my $fd, $report or abort("Couldn't contact the Jira server",$makeout);
my @input=<$fd>;
close $fd;
#abort if query contains no records
(scalar @input != 0) or abort("Jira query returned no record",$makeout);
#format the jira output to html
my @HTMLoutput;
my $c=0;
my $jiraquery;
my %seen;
foreach (@input) {
	chomp;
	my ($author,$date,$action,$project,$id,$comment) = split(/,/);
	$date=~s/^(\d\d\d\d-\d\d-\d\d \d\d:\d\d).*?$/\1/;	 #remove time
	my $jiraissue=$project.'-'.$id;
	my $url='<a href="https://issues.citrite.net/browse/'.$jiraissue.'">'.$jiraissue.'</a>'; #setup a url to ticket
	my $alt_tr=($c++ & 1) ? '<tr class="alt">' : '<tr>';
	push @HTMLoutput , $alt_tr.'<td>'.$author.'</td><td class="nowrap">'.$date.'</td><td>'.$action.'</td><td class="nowrap">'.$url.'</td><td>'.$comment."</td>\n";
	#build up jira query
	$c ==1 and $jiraquery=$jiraissue;
	! $seen{$jiraissue}++ and  $jiraquery=$jiraquery.','.$jiraissue;
}
#generate download links and output tabulated results
print << "HTML";
<h3 class="banner">Query results</h3>
<a href="https://issues.citrite.net/issues/?jql=%20id%20in%20($jiraquery)">View the jira issues</a>&nbsp;&nbsp;&nbsp;&nbsp;
<a href="$report">Download jira report (.csv)</a>&nbsp;&nbsp;&nbsp;&nbsp;
<a href="$ticketlist">Download ticket summary (.csv)</a>
<h3 class="banner">Jira detailed report</h3>
<table class="report">
@HTMLoutput
</table>
HTML
print end_html;
exit 0;



