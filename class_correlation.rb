#This script computes the correlation between the germ layer pairs with respect to 
#persistence and specificity for e and c classes

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
open("correlation.out", "w") do |f_out|
	f_out.puts ";#{klasses.map{|k| analyses.map{|a| "#{k} #{a}"}}.join(";")}"
	layers.combination(2).each do |l1, l2|
		f_out.print "#{l1}-#{l2}"
		klasses.each do |klass|
			analyses.each do |analysis|
				print "."
				l1_vals = open("#{l1}/#{klass}_#{analysis}.out"){|f| f.read}.strip.split("\n").map{|l| l.split}.sort{|a,b| a.first <=> b.first}.map{|p| p.last.to_f}
				l2_vals = open("#{l2}/#{klass}_#{analysis}.out"){|f| f.read}.strip.split("\n").map{|l| l.split}.sort{|a,b| a.first <=> b.first}.map{|p| p.last.to_f}
				f_out.print ";#{pearson l1_vals, l2_vals}"
			end
		end
		f_out.puts
	end
end