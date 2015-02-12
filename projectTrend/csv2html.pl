#!/usr/bin/perl

use warnings;

use HTML::Template;

my @table;
my $url='<a href="https://issues.citrite.net/browse/';
while (<>){
    chomp;
#insert href to Jira issues
	s/,(CA-\d+)/,$url$1\">$1<\/a>/;
    my @row = map{{cell => $_}} split(/,/, $_);
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

