set terminal png size 1200, 800
set title infile
set ylabel "# defects"
set xlabel "sprints"
set datafile separator ","
set xtics border in scale 1,0.5 nomirror rotate by -45  offset character 0, 0, 0 autojustify
set xtics  norangelimit font ",8"
set grid
set style data linespoints
set output outfile
plot	infile	using 1:2:xticlabels(1) title columnhead,\
		infile	using 1:3:xticlabels(1) title columnhead

