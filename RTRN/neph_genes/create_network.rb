#This script creates an RT network for the given layer, 
#based on the given pearson threshold for creating an edge,
#and the given stringency to compare for deciding direction

layer, corr_thresh, stringency = ARGV #e.g. allderm 0.75 0.75
corr_thresh, stringency = corr_thresh.to_f, stringency.to_f

def pearson x, y
	xbar, ybar = x.reduce(:+)/x.size, y.reduce(:+)/y.size
	numerator = [x.map{|i| i-xbar}, y.map{|i| i-ybar}].transpose.map{|pair| pair.reduce(:*)}.reduce(:+)
	denomerator = Math.sqrt(x.map{|i| (i-xbar)*(i-xbar)}.reduce(:+)) * Math.sqrt(y.map{|i| (i-ybar)*(i-ybar)}.reduce(:+))
	corr = (numerator/denomerator)
	raise "pearson value out of bounds: #{corr}" if corr > 1.0000001 or corr < -1.0000001
	corr.round(5)
end

genes = open("geneNames.csv"){|f| f.read}.strip.split
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
			edges << [genes[i], genes[j], direction, corr]
		end
	end
end

open("#{layer}/network.txt", "w"){|f| f.puts edges.map{|e| e.join "\t"}.join("\n")}