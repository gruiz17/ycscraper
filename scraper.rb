require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

yc_page = Nokogiri::HTML(open("http://www.yclist.com/"))

rows = yc_page.css('tbody tr')

yc_csv = CSV.open("yclist.csv", "w")
descriptions = File.new("descriptions.txt", "w")

csv_header = ['name', 'url', 'class', 'status', 'description']
yc_csv << csv_header

rows.each do |row|
  csv_row = []
  row.css('td')[1..5].each do |cell|
    if (cell.text != "")
      csv_row << cell.text
      if (row.css('td')[1..5].index(cell) == 4) && (cell.text != "")
        descriptions << cell.text + "\n"
      end
    end
    if (row.css('td')[1..5].index(cell) == 1) && (cell.text == "")
      csv_row << "Unavailable"
    end
    if (row.css('td')[1..5].index(cell) == 3) && (cell.text == "")
      csv_row << "Fighting"
    end
    if (row.css('td')[1..5].index(cell) == 4) && (cell.text == "")
      csv_row << "None"
    end
  end
  yc_csv << csv_row
end

descriptions.close
