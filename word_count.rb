# encoding: UTF-8

require 'rubygems'
require 'csv'

textfile = File.open("descriptions.txt", "r")
descriptions = textfile.read
countcsv = CSV.open("wordcount.csv", "w")

csv_header = ['word', 'count']
countcsv << csv_header

splitting_regex = /\&|\s+\-|\-\s+|\s+‘|’\s+|\s+\'|\'\s+|\s+|\s+|\(|\)|$|\.\s+|,\s+|\.$|“|”|"/

word_counter = Hash.new
descriptions.downcase.split(splitting_regex).each do |word|
  next if (word == "")
  if (word_counter[word].nil?)
    word_counter[word] = 1
  else
    word_counter[word] += 1
  end
end

word_counter.each do |word, count|
  countcsv << [word, count]
end

countcsv.close

finished_csv = CSV.read("wordcount.csv")
CSV.open("wordcount_sorted.csv", "w") do |out|
  out << ['word','count']
  finished_csv[1..-1].sort{|a,b| [a[1].to_i] <=> [b[1].to_i]}.reverse.each do |row|
    out << row
  end
end

textfile.close
