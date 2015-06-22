reset
set term png size 1280,960 transparent truecolor linewidth 3 24

set xlabel 'Approximate pearson correlation'
set ylabel 'Number of gene pairs'
set title 'Pearson correlation of replication time among gene pairs'	
set logscale y

do for [layer in "allderm endoderm ectoderm mesoderm"]{
	set output layer.'/pearson_histogram.png'
	plot layer.'/pearson_histogram.out' w boxes t ""
	set output
}