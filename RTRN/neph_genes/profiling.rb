#This script reads layer network and profiles it based on
#directionality, activation/inhibition and distant/not
layer = ARGV[0]

edges = open("#{layer}/network.txt"){|f| f.read}.strip.split("\n").map{|l| l.split}
dim1 = ["directional", "bidirectional"]
dim2 = ["distant", "near"]
dim3 = ["activation", "inhibition"]

values = dim1.map{|d1| {d1 => dim2.map{|d2| {d2 => dim3.map{|d3| {d3 => 0}}.reduce(:merge)}}.reduce(:merge)}}.reduce(:merge)
edges.each do |e|
	d1 = e[2] != "0" ? dim1[0] : dim1[1]
	d2 = e[4] == "1" ? dim2[0] : dim2[1]
	d3 = e[3].to_f > 0.0 ? dim3[0] : dim3[1]
	values[d1][d2][d3] += 1
end

open("#{layer}/profile.out", "w") do |f|
	dim1.each do |d1|
		dim2.each do |d2|
			dim3.each do |d3|
				f.puts [d1, d2, d3, values[d1][d2][d3]].map{|v| sprintf "%-18s", v.to_s}.join
			end
		end
	end
end

