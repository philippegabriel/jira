set terminal png size 1200, 800
set title infile
set ylabel ylabel
set xlabel xlabel
set datafile separator ","
set xtics border in scale 1,0.5 nomirror rotate by -45  offset character 0, 0, 0 autojustify
set xtics  norangelimit font ",8"
set xrange [xmin:xmax]
set grid
set output outfile
plot	infile	using 1:($4+$5+$6+$7+$8+$9+$10+$11+$12):xticlabels(2) with filledcurve y1=0 title columnhead linecolor rgb 'red',\
		infile	using 1:($4+$5+$6+$7+$8+$9+$10+$11):xticlabels(2) with filledcurve y1=0 title columnhead linecolor rgb 'dark-red',\
		infile	using 1:($4+$5+$6+$7+$8+$9+$10):xticlabels(2) with filledcurve y1=0 title columnhead linecolor rgb 'salmon',\
		infile	using 1:($4+$5+$6+$7+$8+$9):xticlabels(2) with filledcurve y1=0 title columnhead linecolor rgb 'gold',\
		infile	using 1:($4+$5+$6+$7+$8):xticlabels(2) with filledcurve y1=0 title columnhead linecolor rgb 'forest-green',\
		infile	using 1:($4+$5+$6+$7):xticlabels(2) with filledcurve y1=0 title columnhead linecolor rgb 'greenyellow',\
		infile	using 1:($4+$5+$6):xticlabels(2) with filledcurve y1=0 title columnhead linecolor rgb 'light-blue',\
		infile	using 1:($4+$5):xticlabels(2) with filledcurve y1=0 title columnhead linecolor rgb 'blue',\
		infile	using 1:4:xticlabels(2) with filledcurve y1=0 title columnhead linecolor rgb 'purple'

