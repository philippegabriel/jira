set terminal png size 1200, 800
set title infile
set ylabel "# defects"
set xlabel "sprints"
set datafile separator ","
set xtics border in scale 1,0.5 nomirror rotate by -45  offset character 0, 0, 0 autojustify
set xtics  norangelimit font ",8"
set grid
set boxwidth 1 absolute
set style fill solid 1.00 noborder
set style histogram clustered gap 1 
set style data histograms 
set output outfile
plot	infile using 2:xtic(1) title columnhead linecolor rgb 'red',\
		infile using 3:xtic(1) title columnhead linecolor rgb 'green'

