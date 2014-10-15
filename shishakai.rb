#!/usr/bin/env ruby

require 'nokogiri'
require 'uri'
require 'open-uri'
require 'pg'

base_uri = "http://movie.walkerplus.com/shisyakai/"
doc = Nokogiri::HTML(open(base_uri))

movie_info = doc.css("div.previewMovieInfo").map do |info|
  anchor = info.css("a").first
  title = anchor.text
  uri = URI.join(base_uri, anchor.attributes["href"].value)

  table_data = info.css("td")
  limit = table_data[0].text
  date = table_data[1].text
  place = table_data[2].text.sub(/\(.*\)/, '')

  {title: title, uri: uri, limit: limit, date: date, place: place}
end

puts movie_info.map {|info| info[:uri] }

puts "----------"

db_url = URI.parse(ENV['DATABASE_URL'])

conn = PG.connect({host: db_url.host, port: db_url.port, dbname: db_url.path[1..-1], user: db_url.user, password: db_url.password})
result = conn.exec("SELECT * FROM tweeted_pages").map {|row| row["uri"] }
puts result
