#This script reads replication times of all genes in the cell lines of the given layer,
#computes pearson for every gene pair, and outputs a histogram of the values

layer = ARGV[0]

def pearson x, y
	xbar, ybar = x.reduce(:+)/x.size, y.reduce(:+)/y.size
	numerator = [x.map{|i| i-xbar}, y.map{|i| i-ybar}].transpose.map{|pair| pair.reduce(:*)}.reduce(:+)
	denomerator = Math.sqrt(x.map{|i| (i-xbar)*(i-xbar)}.reduce(:+)) * Math.sqrt(y.map{|i| (i-ybar)*(i-ybar)}.reduce(:+))
	corr = (numerator/denomerator)
	raise "pearson value out of bounds: #{corr}" if corr > 1.0000001 or corr < -1.0000001
	corr.round(5)
end

segments = -0.9.step(0.9, 0.1).map{|i| {i.round(1) => 0}}.reduce(:merge)
genes = open("../../geneNames.csv"){|f| f.read}.strip.split
vectors = open("../../#{layer}-rt.csv"){|f| f.read}.strip.split("\n").map{|l| l.split(",").map{|t| t.to_f}}
raise unless genes.size == vectors.size
0.upto(genes.size-1) do |i|
	print "#{i} " if i % 100 == 0
	(i+1).upto(genes.size-1) do |j|
		corr = pearson vectors[i], vectors[j]
		segment = (corr*10.0).truncate/10.0
		segment = 0.9 if segment == 1.0 #special case
		segments[segment] += 1
	end
end

open("#{layer}/pearson_histogram.out", "w"){|f| f.puts segments.map{|k, v| "#{k}\t#{v}"}.join("\n")}