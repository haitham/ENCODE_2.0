#This script reads c/e persistence/specificity files and outputs the genes that 
#score 1.0 in each germ layer, as well as the overlap between the layers

layers = ["ectoderm", "mesoderm", "endoderm"]
["c", "e"].each do |k|
	["persistence", "specificity"].each do |a|
		map = layers.map{|l| { l => open("#{l}/#{k}_#{a}.out"){|f| f.read}.strip.split("\n").map{|p| p.split}.select{|p| p.last.to_f == 1.0}.map{|p| p.first} } }.reduce(:merge)
		layers.combination(2).each do |l1, l2|
			map["#{l1} & #{l2}"] = map[l1] & map[l2]
		end
		map[layers.join(" & ")] = layers.map{|l| map[l]}.reduce(:&)
		open("#{k}_#{a}.venn", "w"){|f| f.puts map.map{|l, g| "#{l}\n#{g.size}\n--------\n#{g.join "\n"}\n\n--------"}.join("\n")}
	end
end