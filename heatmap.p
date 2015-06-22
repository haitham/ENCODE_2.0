#This script plots all regulation heatmaps
reset
set term png size 1280,960 transparent truecolor linewidth 3 font "arial-bold,18"
set datafile separator ";"

#set palette model CMY rgbformulae 7,5,15
set palette defined ( 0 "green", 1 "yellow", 2 "red" )
set cblabel "Normalized density"
set title "Density of regulation between gene classes"

type = "multi"
set cbrange [0:0.6]
do for [layer in "allderm ectoderm endoderm mesoderm"]{
	dir = "neph_".layer."/".type
	set output dir."/heatmap.png"
	plot dir."/matrix.out" matrix rowheaders columnheaders with image pixels
	set output
}

type = "uniq"
set cbrange [0:0.17]
do for [layer in "allderm ectoderm endoderm mesoderm"]{
	dir = "neph_".layer."/".type
	set output dir."/heatmap.png"
	plot dir."/matrix.out" matrix rowheaders columnheaders with image pixels
	set output
}