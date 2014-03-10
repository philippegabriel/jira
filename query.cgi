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
s/^(.*?,.*?,.*?),(.*?),(.*?),(.*?)$/\1,<a href="https:\/\/jira.uk.xensource.com\/browse\/\2-\3">\2-\3<\/a>,\4/g for @input; #merge project and id fields
s/^(.*?),(.*?),(.*?),(.*?),(.*?)$/\1<\/td><td class="nowrap">\2<\/td><td>\3<\/td><td class="nowrap">\4<\/td><td>\5/g for @input; #subsitute comma with <td> tag
s/^(.*)$/<tr><td>\1<\/td><\/tr>/g for @input; #add <tr> tag
my $c=0; ($c++ & 1) and s/<tr>/<tr class="alt">/ for @input; #add a class attribute
#trim to make readable
s/(\d\d\d\d-\d\d-\d\d).*?<\/td>/\1<\/td>/ for @input;  #remove time specs
#generate download links and output tabulated results
print << "HTML";
<h3 class="banner">Query result (.csv files)</h3>
<a href="$report">Download jira report (.csv)</a>&nbsp;&nbsp;&nbsp;&nbsp;
<a href="$ticketlist">Download ticket summary (.csv)</a>
<h3 class="banner">Jira detailed report</h3>
<table class="report">
@input
</table>
HTML
print end_html;
exit 0;



