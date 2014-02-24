require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/https'
require 'csv'

yc_page = Nokogiri::HTML(open("http://www.yclist.com/"))

rows = yc_page.css('tbody tr')

yc_csv = CSV.open("data_files/yclist.csv", "w")
descriptions = File.new("data_files/descriptions.txt", "w")

csv_header = ['name', 'url', 'class', 'status', 'description', 'hiring?']
yc_csv << csv_header

rows.each do |row|
  csv_row = []
  hiring_status = ''
  row.css('td')[1..5].each do |cell|
    if (cell.text != "")
      csv_row << cell.text
      if (row.css('td')[1..5].index(cell) == 1) && (cell.text != "")
        retries = 2
        begin
          puts "parsing #{cell.text}"
          uri = URI.parse(cell.text + "/careers/")
          uri2 = URI.parse(cell.text + "/jobs/")

          http = Net::HTTP.new(uri.host,uri.port)
          http.read_timeout = 4
          http.open_timeout = 4
          http.use_ssl = true if uri.scheme == "https"
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE if uri.scheme == "https"
          request = Net::HTTP::Get.new(uri.request_uri)
          res = http.request(request)

          http2 = Net::HTTP.new(uri2.host,uri2.port)
          http2.read_timeout = 4
          http2.open_timeout = 4
          http2.use_ssl = true if uri2.scheme == "https"
          http2.verify_mode = OpenSSL::SSL::VERIFY_NONE if uri2.scheme == "https"
          request2 = Net::HTTP::Get.new(uri2.request_uri)
          res2 = http.request(request2)

          if res.code.match('200') || res2.code.match('200')
            hiring_status = 'true'
          else
            hiring_status = 'false'
          end
        rescue StandardError=>e
          if retries > 0
            puts "retrying connection"
            retries -= 1
            sleep 2.0
            retry
          else
            puts "failed gg"
            hiring_status = 'false'
          end
        rescue TimeoutError=>e
          puts "timeout failed gg"
          hiring_status = 'false'
        end
      end

      if (row.css('td')[1..5].index(cell) == 4) && (cell.text != "")
        descriptions << cell.text + "\n"
      end
    end

    if (row.css('td')[1..5].index(cell) == 1) && (cell.text == "")
      csv_row << "Unavailable"
      hiring_status = 'false'
    end

    if (row.css('td')[1..5].index(cell) == 3) && (cell.text == "")
      csv_row << "Fighting"
    end

    if (row.css('td')[1..5].index(cell) == 4) && (cell.text == "")
      csv_row << "None"
    end
  end
  csv_row << hiring_status
  yc_csv << csv_row
end

descriptions.close
