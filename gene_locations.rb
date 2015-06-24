#This script reads source.csv, extracts gene locations for genes that have no empty fields

rows = open("source.csv"){|f| f.read}.strip.split("\n").drop(1).reject{|l| l =~ /(,,)|(^,)|(,$)/}.map{|l| l.split(",")}
open("gene_locations.csv", "w") do |f|
	rows.each do |row|
		if row[5] == "+"
			f.puts [1, 2, 6].map{|i| row[i]}.join ","
		elsif row[5] == "-"
			f.puts [1, 2, 7].map{|i| row[i]}.join ","
		else
			raise "Error with strand sign"
		end
	end
end