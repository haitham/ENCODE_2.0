#This script creates an RT network for the given layer, 
#based on the given pearson threshold for creating an edge,
#and the given stringency to compare for deciding direction

layer, corr_thresh, stringency, dist_thresh = ARGV #e.g. allderm 0.75 0.75 500000
corr_thresh, stringency, dist_thresh = corr_thresh.to_f, stringency.to_f, dist_thresh.to_i

def pearson x, y
	xbar, ybar = x.reduce(:+)/x.size, y.reduce(:+)/y.size
	numerator = [x.map{|i| i-xbar}, y.map{|i| i-ybar}].transpose.map{|pair| pair.reduce(:*)}.reduce(:+)
	denomerator = Math.sqrt(x.map{|i| (i-xbar)*(i-xbar)}.reduce(:+)) * Math.sqrt(y.map{|i| (i-ybar)*(i-ybar)}.reduce(:+))
	corr = (numerator/denomerator)
	raise "pearson value out of bounds: #{corr}" if corr > 1.0000001 or corr < -1.0000001
	corr.round(5)
end

genes = open("geneNames.csv"){|f| f.read}.strip.split
locations = open("gene_locations.csv"){|f| f.read}.strip.split("\n").map{|l| l.split(",")}
vectors = open("#{layer}-rt.csv"){|f| f.read}.strip.split("\n").map{|l| l.split(",").map{|t| t.to_f}}
raise unless genes.size == vectors.size
edges = []
0.upto(genes.size-1) do |i|
	print "#{i} " if i % 100 == 0
	(i+1).upto(genes.size-1) do |j|
		corr = pearson vectors[i], vectors[j]
		if corr.abs >= corr_thresh
			percent = [vectors[i], vectors[j]].transpose.map{|p| p.first > p.last ? 1.0 : 0.0}.reduce(:+)/vectors[i].size
			direction = 0
			if percent >= stringency
				direction = 1
			elsif percent <= 1.0 - stringency
				direction = -1
			end
			distance = -1
			distance = (locations[i][2].to_i - locations[j][2].to_i).abs if locations[i][1] == locations[j][1]
			distant = 1
			distant = 0 if locations[i][1] == locations[j][1] and distance < dist_thresh
			edges << [genes[i], genes[j], direction, corr, distant, distance]
		end
	end
end

open("#{layer}/network.txt", "w") do |f| 
	f.puts ["Gene1", "Gene2", "Direction", "Correlation", "Distant?", "Distance"].map{|c| sprintf "%-13s", c}.join
	f.puts edges.map{|e| e.map{|c| sprintf "%-13s", c.to_s}.join}.join("\n")
end