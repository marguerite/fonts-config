#!/usr/bin/env ruby

a = open("1.txt").read.split("\n").map {|i| i.match(/^.*:/)[0]}
b = open("2.txt").read.split("\n").map {|i| i.match(/^.*:/)[0]}

p (a & b).reject {|i| i.strip.end_with?(".gz:",".pcf:")}
