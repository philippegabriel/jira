#!/usr/bin/perl
#takes a csv file in month,<number> format
#output a csv: <quarter>,<sum numbers>
%toQuarter=
('01'=>'Q01','02'=>'Q01','03'=>'Q01','04'=>'Q02','05'=>'Q02','06'=>'Q02',
 '07'=>'Q03','08'=>'Q03','09'=>'Q03','10'=>'Q04','11'=>'Q04','12'=>'Q04');
while(<>){
chomp;
($null,$date,$count)=split(/,/);
($year,$month)= $date =~ m/^\d\d(\d\d)(\d\d)$/;
#print $year.':'.$month."\n";
$output{$year.$toQuarter{$month}}+=$count;
}
#print the output hash
$i=0;
foreach my $key (sort keys %output) {$key eq '' and next ; $i++ ; print "$i,$key,$output{$key}\n";}
exit 0;



