require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

yc_page = Nokogiri::HTML(open("http://www.yclist.com/"))

rows = yc_page.css('tbody tr')

yc_csv = CSV.open("yclist.csv", "w")

csv_header = ['name', 'url', 'class', 'status', 'description']
yc_csv << csv_header


rows.each do |row|
  puts "hi"
end