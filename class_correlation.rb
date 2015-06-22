#This script computes the correlation between the germ layer pairs with respect to 
#persistence and specificity for e and c classes after filtering genes that have 0.0 in all three layers

def pearson x, y
	xbar, ybar = x.reduce(:+)/x.size, y.reduce(:+)/y.size
	numerator = [x.map{|i| i-xbar}, y.map{|i| i-ybar}].transpose.map{|pair| pair.reduce(:*)}.reduce(:+)
	denomerator = Math.sqrt(x.map{|i| (i-xbar)*(i-xbar)}.reduce(:+)) * Math.sqrt(y.map{|i| (i-ybar)*(i-ybar)}.reduce(:+))
	corr = (numerator/denomerator)
	raise "pearson value out of bounds: #{corr}" if corr > 1.0000001 or corr < -1.0000001
	corr.round(5)
end

layers = ["ectoderm", "mesoderm", "endoderm"]
klasses = ["e", "c"]
analyses = ["persistence", "specificity"]

map = {}
klasses.each do |k|
	map[k] = {}
	analyses.each do |a|
		open("#{k}_#{a}_filtered.out", "w") do |f|
			values = []
			layers.each do |l|
				values << open("#{l}/#{k}_#{a}.out"){|f| f.read}.strip.split("\n").map{|l| l.split}.sort{|a,b| a.first <=> b.first}.map{|p| p.last.to_f}
			end
			map[k][a] = values.transpose.reject{|col| col.map{|v| v.zero?}.all?}.transpose
			f.puts layers.map{|l| sprintf "%-20s", l}.join
			f.puts map[k][a].transpose.map{|row| row.map{ |v| sprintf "%-20f", v}.join}.join "\n"
		end
	end
end


open("correlation.out", "w") do |f_out|
	f_out.puts ";#{klasses.map{|k| analyses.map{|a| "#{k} #{a}"}}.join(";")}"
	0.upto(2).map{|i| i}.combination(2).each do |l1, l2|
		f_out.print "#{layers[l1]}-#{layers[l2]}"
		klasses.each do |klass|
			analyses.each do |analysis|
				print "."
				f_out.print ";#{pearson map[klass][analysis][l1], map[klass][analysis][l2]}"
			end
		end
		f_out.puts
	end
end
