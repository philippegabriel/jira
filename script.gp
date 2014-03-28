set terminal png size 1200, 800
set style data linespoints
set datafile separator ","
set xtics border in scale 1,0.5 nomirror rotate by -45  offset character 0, 0, 0 autojustify
set xtics  norangelimit font ",8"
set grid
set xdata time
set timefmt "%Y%m"
set xrange ["200901":"201403"]
set output filename
plot  'SCTXSumByMonth.csv' using 1:2 title "all SCTXs", \
 	'XenServer.6.2.plot' using 1:2 title "XenServer 6.2", \
	'XenServer.6.1.plot' using 1:2 title "XenServer 6.1", \
	'XenServer.6.0.plot' using 1:2 title "XenServer 6.0", \
	'XenServer.6.0.2.plot' using 1:2 title "XenServer 6.0.2", \
	'XenServer.5.6.plot' using 1:2 title "XenServer 5.6", \
	'XenServer.5.5.plot' using 1:2 title "XenServer 5.5", \
	'XenServer.5.0.plot' using 1:2 title "XenServer 5.0"





