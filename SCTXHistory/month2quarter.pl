#!/usr/bin/perl
#takes a csv file in rank,month,xsreleases... format
#output the same summed up per quarter
%toQuarter=
('01'=>'Q01','02'=>'Q01','03'=>'Q01','04'=>'Q02','05'=>'Q02','06'=>'Q02',
 '07'=>'Q03','08'=>'Q03','09'=>'Q03','10'=>'Q04','11'=>'Q04','12'=>'Q04');
$header=<STDIN>;
chomp $header;
@xsreleases=split(/,/,$header);
shift(@xsreleases);shift(@xsreleases); #remove 'rank' and 'date', so only release names are left
#print join(',',@xsreleases)."\n";

while(<STDIN>){
	chomp;
	@input=split(/,/);
	($rank,$date)=(shift(@input),shift(@input));
	($year,$month)= $date =~ m/^\d\d(\d\d)(\d\d)$/;
#	print $year.':'.$month."\n";
	$quarter=$year.$toQuarter{$month};
#print "$quarter\n";
	$quarterHash{$quarter}=0;
	foreach(@xsreleases){
		$x=shift(@input); $output{$quarter.$_}+=$x; next ; 
	}
}
#emit header
print "rank,quarter,".join(',',@xsreleases)."\n";
#emit the output hash
$i=0;
foreach $key (sort keys %quarterHash){
	$i++ ; 
	print "$i,$key";
	foreach(@xsreleases){
		print ",$output{$key.$_}";
	}
	print"\n";
}
exit 0;

