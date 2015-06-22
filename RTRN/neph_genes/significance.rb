#This script compares the RT network of the given layer to its neph network,
#and lists the differences and intersection between them,
#as well as the hypergeometric p value of the RT network wrt the neph network
#require 'bigdecimal'
layer = ARGV[0]
rt_edges = open("#{layer}/network.txt"){|f| f.read}.strip.split("\n").map{|l| l.split}
neph_edges = open("../../neph_#{layer}/uniq/network.txt"){|f| f.read}.strip.split("\n").map{|l| l.split}
genes_count = 486

def p_value pop, draws, pop_succ, draws_succ
	p = 0.0
	puts "#{draws_succ} -> #{draws}"
	draws_succ.upto(draws) do |draw_succ|
		print "#{draw_succ} "
		d = draws.times.map{|i| Math.log10(pop-i) - Math.log10(draws-i)}.reduce(:+)
		u1 = draw_succ.times.map{|i| Math.log10(pop_succ-i) - Math.log10(draw_succ-i)}.reduce(:+)
		u2 = (draws-draw_succ).times.map{|i| Math.log10(pop-pop_succ-i) - Math.log10(draws-draw_succ-i)}.reduce(0.0,:+)
		p += 10**(u1+u2-d)
	end
	puts
	p
end

#directed
intersection = 0
rt_edges.each do |rt|
	neph_edges.each do |neph|
		if rt[2] == 0
			if neph.include? rt[0] and neph.include? rt[1]
				intersection += 1 
				break
			end
		elsif rt[2] == 1
			if neph[0] == rt[0] and neph[1] == rt[1]
				intersection += 1 
				break
			end
		else #-1
			if neph[0] == rt[1] and neph[1] == rt[0]
				intersection += 1 
				break
			end
		end
	end
end

rt_minus_neph = rt_edges.size - intersection
neph_minus_rt = neph_edges.size - intersection
pv = p_value(genes_count*(genes_count-1), rt_edges.size, neph_edges.size, intersection)
puts pv

open("#{layer}/stats.out", "w") do |f|
	f.puts "RT network size: #{rt_edges.size} edges"
	f.puts "Neph network size: #{neph_edges.size} edges"
	f.puts
	f.puts
	f.puts "First: If direction is significant:"
	f.puts "==================================="
	f.puts "RT edges intersection neph edges: #{intersection}"
	f.puts "RT edges minus neph edges: #{rt_minus_neph}"
	f.puts "neph edges minus RT edges: #{neph_minus_rt}"
	f.puts "hypergeometric p value: #{pv}"
	f.puts
	f.puts
end

#undirected
intersection = 0
rt_edges.each do |rt|
	neph_edges.each do |neph|
		if neph.include? rt[0] and neph.include? rt[1]
			intersection += 1
			break
		end
	end
end

rt_minus_neph = rt_edges.size - intersection
neph_minus_rt = neph_edges.size - intersection
pv = p_value(genes_count*(genes_count-1), rt_edges.size, neph_edges.size, intersection)
puts pv

open("#{layer}/stats.out", "a") do |f|
	f.puts "Second: If direction is NOT significant:"
	f.puts "======================================="
	f.puts "RT edges intersection neph edges: #{intersection}"
	f.puts "RT edges minus neph edges: #{rt_minus_neph}"
	f.puts "neph edges minus RT edges: #{neph_minus_rt}"
	f.puts "hypergeometric p value: #{pv}"
	f.puts
	f.puts
end










