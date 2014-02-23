# encoding: UTF-8

require 'rubygems'
require 'csv'

textfile = File.open("descriptions.txt", "r")
descriptions = textfile.read
countcsv = CSV.open("wordcount.csv", "w")

csv_header = ['word', 'count']
countcsv << csv_header

splitting_regex = /\&|\s+\-|\-\s+|\s+\'|\'\s+|\s+|\(|\)|$|\.\s+|,\s+|\.$|“|”/

word_counter = Hash.new
descriptions.downcase.split(splitting_regex).each do |word|
  if (word_counter[word].nil?)
    word_counter[word] = 1
  else
    word_counter[word] += 1
  end
end

word_counter.each do |word, count|
  countcsv << [word, count]
end

textfile.close
