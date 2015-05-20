#This script takes 'dir': the directory under which all in and out files
reset
set term png size 1280,960 transparent truecolor linewidth 3 font "arial-bold,18"
set datafile separator ";"

#set palette model RGB defined (0 "green", 1 "dark-green", 1 "yellow", 2 "dark-yellow", 2 "red", 3 "dark-red" )
set palette rgb 21,22,23
print dir
set output dir."/heatmap.png"
set cblabel "Normalized density"
plot dir."/matrix.out" matrix rowheaders columnheaders with image pixels
set output
