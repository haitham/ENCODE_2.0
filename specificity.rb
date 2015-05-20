#This script computes specificity of genes to classes e and c in a given layer
#By computing the probability of it being in the class in this layer AND NOT in allderm

["ectoderm", "endoderm", "mesoderm"].each do |layer|
	["c", "e"].each do |klass|
		print "."
		all_vals = {}
		layer_vals = {}
		open("allderm/#{klass}_percent.out"){|f| f.read}.strip.split("\n").map{|l| l.split}.each{|p| all_vals[p.first] = p.last.to_f}
		open("#{layer}/#{klass}_percent.out"){|f| f.read}.strip.split("\n").map{|l| l.split}.each{|p| layer_vals[p.first] = p.last.to_f}
		spec = layer_vals.map{|k,v| [k, v*(1.0-all_vals[k])]}.sort{|a,b| a.last == b.last ? a.first <=> b.first : b.last <=> a.last}
		open("#{layer}/#{klass}_specificity.out", "w"){|f| f.puts spec.map{|p| p.join("\t")}.join("\n")}
	end
end