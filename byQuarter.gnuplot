set terminal png size 1200, 800
set style data linespoints
set datafile separator ","
set xtics border in scale 1,0.5 nomirror rotate by -45  offset character 0, 0, 0 autojustify
set xtics  norangelimit font ",8"
set grid
#range starts at 2008Q2, the 2nd row of input
set xrange [2:]
set output filename
plot  'SCTXSum.quarter.plot' using 1:3:xticlabels(2) title "all SCTXs", \
	'XenServer.6.2.quarter.plot' using 1:3:xticlabels(2) title "XenServer 6.2",\
	'XenServer.6.1.quarter.plot' using 1:3:xticlabels(2) title "XenServer 6.1", \
	'XenServer.6.0.quarter.plot' using 1:3:xticlabels(2) title "XenServer 6.0", \
	'XenServer.6.0.2.quarter.plot' using 1:3:xticlabels(2) title "XenServer 6.0.2", \
	'XenServer.5.6.quarter.plot' using 1:3:xticlabels(2) title "XenServer 5.6", \
	'XenServer.5.5.quarter.plot' using 1:3:xticlabels(2) title "XenServer 5.5", \
	'XenServer.5.0.quarter.plot' using 1:3:xticlabels(2) title "XenServer 5.0", \
	'XenServer.4.1.quarter.plot' using 1:3:xticlabels(2) title "XenServer 4.1", \
	'XenServer.4.0.1.quarter.plot' using 1:3:xticlabels(2) title "XenServer 4.0.1"



