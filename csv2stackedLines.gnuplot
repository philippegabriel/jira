set terminal png size 1200, 800
set title infile
set ylabel "# defects"
set xlabel "sprints"
set datafile separator ","
set xtics border in scale 1,0.5 nomirror rotate by -45  offset character 0, 0, 0 autojustify
set xtics  norangelimit font ",8"
set grid
set output outfile
plot	infile	using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10):xticlabels(1) with filledcurve y1=0 title columnhead linecolor rgb 'red',\
		infile	using 1:($2+$3+$4+$5+$6+$7+$8+$9):xticlabels(1) with filledcurve y1=0 title columnhead linecolor rgb 'dark-red',\
		infile	using 1:($2+$3+$4+$5+$6+$7+$8):xticlabels(1) with filledcurve y1=0 title columnhead linecolor rgb 'salmon',\
		infile	using 1:($2+$3+$4+$5+$6+$7):xticlabels(1) with filledcurve y1=0 title columnhead linecolor rgb 'gold',\
		infile	using 1:($2+$3+$4+$5+$6):xticlabels(1) with filledcurve y1=0 title columnhead linecolor rgb 'forest-green',\
		infile	using 1:($2+$3+$4+$5):xticlabels(1) with filledcurve y1=0 title columnhead linecolor rgb 'greenyellow',\
		infile	using 1:($2+$3+$4):xticlabels(1) with filledcurve y1=0 title columnhead linecolor rgb 'light-blue',\
		infile	using 1:($2+$3):xticlabels(1) with filledcurve y1=0 title columnhead linecolor rgb 'blue',\
		infile	using 1:2:xticlabels(1) with filledcurve y1=0 title columnhead linecolor rgb 'purple'

