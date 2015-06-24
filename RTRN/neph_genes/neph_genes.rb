#This script filters geneNames.csv and gene_locations.csv by the genes in allderm neph network

layers = ["allderm", "ectoderm", "endoderm", "mesoderm"]
types = ["rt", "exp"]
allgenes = open("../../geneNames.csv"){|f| f.read}.strip.split
alllocations = open("../../gene_locations.csv"){|f| f.read}.strip.split("\n")
values = {}
layers.each do |layer|
	values[layer] = {}
	types.each do |type|
		values[layer][type] = open("../../#{layer}-#{type}.csv"){|f| f.read}.strip.split("\n")
		raise unless values[layer][type].size == allgenes.size
	end
end

nephgenes = open("../../neph_allderm/uniq/network.txt"){|f| f.read}.strip.split.uniq
filtered_genes = []
filtered_locations = []
filtered_values = layers.map{|l| {l => types.map{|t| {t => []}}.reduce(:merge)}}.reduce(:merge)
nephgenes.each do |g|
	0.upto(allgenes.size-1) do |i|
		if allgenes[i] == g
			filtered_genes << g
			filtered_locations << alllocations[i]
			layers.each{|l| types.each{|t| filtered_values[l][t] << values[l][t][i]}}
		end
	end
end

open("geneNames.csv", "w"){|f| f.puts filtered_genes.join("\n")}
open("gene_locations.csv", "w"){|f| f.puts filtered_locations.join("\n")}
layers.each do |layer|
	types.each do |type|
		open("#{layer}-#{type}.csv", "w"){|f| filtered_values[layer][type].each{|t| f.puts t}}
	end
end