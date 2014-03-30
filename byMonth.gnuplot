set terminal png size 1200, 800
set style data linespoints
set datafile separator ","
set xtics border in scale 1,0.5 nomirror rotate by -45  offset character 0, 0, 0 autojustify
set xtics  norangelimit font ",8"
set grid
#range starts at 2008/05, the 5th row of input
set xrange [5:]
set output filename
plot  'SCTXSum.month.plot' using 1:3:xticlabels(2) title "all SCTXs", \
 	'XenServer.6.2.month.plot' using 1:3:xticlabels(2) title "XenServer 6.2", \
	'XenServer.6.1.month.plot' using 1:3:xticlabels(2) title "XenServer 6.1", \
	'XenServer.6.0.month.plot' using 1:3:xticlabels(2) title "XenServer 6.0", \
	'XenServer.6.0.2.month.plot' using 1:3:xticlabels(2) title "XenServer 6.0.2", \
	'XenServer.5.6.month.plot' using 1:3:xticlabels(2) title "XenServer 5.6", \
	'XenServer.5.5.month.plot' using 1:3:xticlabels(2) title "XenServer 5.5", \
	'XenServer.5.0.month.plot' using 1:3:xticlabels(2) title "XenServer 5.0", \
	'XenServer.4.1.month.plot' using 1:3:xticlabels(2) title "XenServer 4.1", \
	'XenServer.4.0.1.month.plot' using 1:3:xticlabels(2) title "XenServer 4.0.1"





