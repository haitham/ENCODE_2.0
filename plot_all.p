reset
set term png size 1280,960 transparent truecolor linewidth 3 24

plot_layers = "\
set title 'Gene '.analysis.' in class '.klass;\
set xlabel 'Gene rank';\
set ylabel 'Gene '.analysis;\
set output klass.'_'.analysis.'.png';\
plot for [layer in 'ectoderm mesoderm endoderm'] layer.'/'.klass.'_'.analysis.'.out' u 2 w l t layer;\
set output;\
"

analysis = 'persistence'; klass = 'c'
set yrange[0:1.05]
set xrange[0:3500]
@plot_layers

analysis = 'specificity'; klass = 'c'
set yrange[0:0.26]
set xrange[0:1100]
@plot_layers

analysis = 'persistence'; klass = 'e'
set yrange[0:1.05]
set xrange[0:1050]
@plot_layers

analysis = 'specificity'; klass = 'e'
set yrange[0:1.05]
set xrange[0:1000]
@plot_layers

reset
set term png size 1280,960 transparent truecolor linewidth 3 18
set datafile separator ";"
set palette rgb 21,22,23
set ytics rotate by 90 offset 0,4
set output "correlation.png"
set cblabel "Pearson Correlation"
set title "Correlation of class persistence and specificity in germ layers"
plot "correlation.out" matrix rowheaders columnheaders with image pixels
set output