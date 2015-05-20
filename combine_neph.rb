#This script takes a list of neph net names and combines them into out_net
#Can be done with multiplicity or not using 'uniq' param
neph_names, out_net, uniq = ARGV
uniq = uniq.to_i
names = open(neph_names){|f| f.read}.strip.split
edges = names.map{|name| open("NephNetworks/#{name}/genes-regulate-genes.txt"){|f| f.read}.strip.split("\n").map{|e| e.strip.split}}.reduce(:+)
edges = edges.uniq unless uniq.zero?
open(out_net, "w"){|f| f.puts edges.map{|e| e.join(" ")}.join("\n")}