#This script computes specificity of genes to classes e and c in a given layer
#By computing the probability of it being in the class in this layer AND NOT in the other two

layers = ["ectoderm", "endoderm", "mesoderm"]
layers.each do |layer|
	["c", "e"].each do |klass|
		print "."
		layer_vals = {}
		open("#{layer}/#{klass}_persistence.out"){|f| f.read}.strip.split("\n").map{|l| l.split}.each{|p| layer_vals[p.first] = p.last.to_f}
		other_vals = (layers - [layer]).map{|l| {l => {}}}.reduce(:merge)
		other_vals.keys.each do |l|
			open("#{l}/#{klass}_persistence.out"){|f| f.read}.strip.split("\n").map{|l| l.split}.each{|p| other_vals[l][p.first] = p.last.to_f}
		end
		spec = layer_vals.map{|k,v| [k, v * other_vals.map{|l,vals| 1.0 - vals[k]}.reduce(:*)]}.sort{|a,b| a.last == b.last ? a.first <=> b.first : b.last <=> a.last}
		open("#{layer}/#{klass}_specificity.out", "w"){|f| f.puts spec.map{|p| p.join("\t")}.join("\n")}
	end
end