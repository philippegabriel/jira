#!/usr/bin/perl

use warnings;
use strict;
use HTML::Template;
sub get_tmpl{
#see: http://search.cpan.org/~wonko/HTML-Template-2.95/lib/HTML/Template.pm
    return <<TMPL
<html>
<head>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<title>Jira report</title>
<link rel="stylesheet" type="text/css" href="index.css" />
</head>
<body>
<h3><TMPL_VAR NAME=title></h3>
C+ Created,R- Issue Resolved<br>
V+ Version set to project,V- Issue set to outgoing<br>
P+ Priority promoted,P- Priority demoted<br>
T+ Team affected,T- Team not affected<br>
O+ Issue Reopened<br>
<table>
<TMPL_LOOP table>
<TMPL_IF NAME="__even__">
<tr>
<TMPL_ELSE>
<tr class="alt">
</TMPL_IF>
<TMPL_LOOP row>
<td><TMPL_VAR cell></td></TMPL_LOOP>
</tr></TMPL_LOOP>
</table>
</body>
</html>
TMPL
}

sub fetchLinks{
my ($team,$cat,$week,$x)=@_;
if(not defined $x or $x=~ m/^\s*$/)
	{return ' ';}
if($x eq '0')
	{return '0';}
$team =~ s/ & /,/g; 
my $file="$team.report.csv";
open my $handle, '<', $file or die "ABORT: $file NOT FOUND!\n";;
chomp(my @lines = <$handle>);
close $handle;
#grep the CAs
my $pattern=$week.','.$cat;
#print "IN:".$pattern."\n";
my @CAs=();
foreach(@lines){
	if(m/$pattern/){
	my ($day,$week,$cat,$id,$rest)=split(/,/);
	push @CAs,$id;
	}
}
my $y=join('%2C',@CAs);
my $url='https://issues.citrite.net/issues/?jql=project%20%3D%20CA%20AND%20key%20IN%20('.$y.')';
#if(scalar @CAs != $x){
#	die "ABORT num issue mismatch in csvtrend2html.pl\n";
#	print "input:".$team.",".$cat.",".$week.",".$x."\n";
#	print "out:".$url." ".$x."\n";
#}
return '<a href="'.$url.'">'.$x.'</a>';
}
#
#main
#
my @table;
my $title;
my @weeks=();
my $team;
while (<>){
	chomp;
	if(m/^Report/){
		$title=$_;
		next;
	}
my @links=();
my @fields=split(/,/);
my ($cat,$x,$url);
#Skip empty lines
	if(not defined $fields[0]){next;}
	elsif($fields[0] =~ m/^team/){
#print "team\n";
		$team=$fields[1];
#For compound team name, subsitute with 'All teams'
		if(length $fields[1] > 20){
			$fields[1]='All teams'}
		}
	elsif($fields[0] =~ m/^week$/){
#print "week\n";
		@weeks=@fields[1..$#fields];
		}
	elsif($fields[0] =~ m/^[CVPTOR][\+\-]$/){
#print "CVPT\n";
		$cat=shift @fields;
		push @links,$cat;
#escape '+' for the regexp match
		$cat =~ s/\+/\\\+/;
		foreach(@weeks){
			$x=shift @fields;
			$url=fetchLinks($team,$cat,$_,$x);
			push @links,$url;
			}
		@fields=@links;}
	elsif($fields[0] =~ m/^inflow$/){
#print "inflow\n";
		$cat=shift @fields;
		push @links,$cat;
		foreach(@weeks){
			$x=shift @fields;
			$url=fetchLinks($team,'[CVPTOR]\+',$_,$x);
			push @links,$url;
			}
		@fields=@links;}
	elsif($fields[0] =~ m/^outflow$/){
#print "outflow\n";
		$cat=shift @fields;
#		@links=();
		push @links,$cat;
		foreach(@weeks){
			$x=shift @fields;
			$url=fetchLinks($team,'[CVPTOR]\-',$_,$x);
			push @links,$url;
			}
		@fields=@links;}
		
#insert href to Jira issues
    my @row = map{{cell => $_}}@fields;
    push @table, {row => \@row};
}
my $tmpl = HTML::Template->new(scalarref => \get_tmpl(), loop_context_vars => 1);
$tmpl->param(title => $title);
$tmpl->param(table => \@table);
my $page=$tmpl->output;
#remove all empty lines
$page =~ s/(^|\n)[\n\s]*/$1/g;
#Add class definition for css
$page =~ s/<tr.*?>\n<td>team/<tr class="team">\n<td>team/mg;
$page =~ s/<tr.*?>\n<td>week/<tr class="week">\n<td>week/mg;
$page =~ s/<tr.*?>\n<td>inflow/<tr class="inflow">\n<td>inflow/mg;
$page =~ s/<tr.*?>\n<td>outflow/<tr class="outflow">\n<td>outflow/mg;
print $page;
