#!/usr/bin/perl

use warnings;

use HTML::Template;

my @table;
sub fetchLinks{
($team,$cat,$pri,$week,$x)=@_;
if(not defined $x)
	{return ' ';}
$team =~ s/ & /,/g; 
$file="$team.$pri.report.csv";
open my $handle, '<', $file or die "ABORT: $file NOT FOUND!\n";;
chomp(my @lines = <$handle>);
close $handle;
#grep the CAs
$pattern=$week.','.$cat;
@CAs=();
foreach(grep(/$pattern/, @lines)){
($day,$week,$cat,$id,$rest)=split(/,/);
#print "hello\n";
push @CAs,$id;
}
$y=join('%2C',@CAs);
#print $y;
$url='https://issues.citrite.net/issues/?jql=project%20%3D%20CA%20AND%20key%20IN%20('.$y.')';
return '<a href="'.$url.'">'.$x.'</a>';
}
while (<>){
    chomp;
#rule for long team name
	@fields=split(/,/);
	if(defined $fields[0] and $fields[0] =~ m/^team/){
		$team=$fields[1];
		if(length $fields[1] > 20){
			$fields[1]='All teams'}
	}
	elsif(defined $fields[0] and $fields[0] =~ m/^priority$/){
#print "helloPrio\n";
		$priority=$fields[1]}
	elsif(defined $fields[0] and $fields[0] =~ m/^week$/){
#print "helloWeeks\n";
#		shift @fields;
		@weeks=@fields[1..$#fields];
#		print join(',',@weeks);
		}
	elsif(defined $fields[0] and $fields[0] =~ m/^[CVPTOR][\+\-]$/){
#print "helloC+\n";
		$cat=shift @fields;
		@links=();
		push @links,$cat;
		foreach(@weeks){
	#print "helloinWeeks\n";
			$x=shift @fields;
			$url=fetchLinks($team,$cat,$priority,$_,$x);
			push @links,$url;
			}
		@fields=@links;
#		map{push @links,fetchLinks(shift @fields,)}@weeks;
};
		
#insert href to Jira issues
#	s/,(CA-\d+)/,$url$1\">$1<\/a>/;
    my @row = map{{cell => $_}}@fields;
    push @table, {row => \@row};
}
my $tmpl = HTML::Template->new(scalarref => \get_tmpl(), loop_context_vars => 1);
$tmpl->param(table => \@table);
print $tmpl->output;

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

