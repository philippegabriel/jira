set terminal png size 1200, 800
set title title
set ylabel ylabel
set xlabel xlabel
set datafile separator ","
set xtics border in scale 1,0.5 nomirror rotate by -45  offset character 0, 0, 0 autojustify
set xtics  norangelimit font ",8"
set xrange [xmin:xmax]
set grid
set boxwidth 1 absolute
set style fill solid 1.00 noborder
set style histogram clustered gap 1 
set output outfile
plot	infile using 1:3:xticlabels(2) with lines title columnhead linewidth 5 linecolor rgb 'red',\
		infile using 1:4:xticlabels(2) with lines title columnhead linewidth 5 linecolor rgb 'green',\
		infile using 1:3:4 with filledcurves above notitle linecolor rgb "#DC143C", \
		infile using 1:3:4 with filledcurves below notitle linecolor rgb "#32CD32",





