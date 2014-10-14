#!/usr/bin/env ruby

require 'nokogiri'
require 'uri'
require 'open-uri'

base_uri = "http://movie.walkerplus.com/shisyakai/"
doc = Nokogiri::HTML(open(base_uri))

doc.css("div.previewMovieInfo").each do |info|
  anchor = info.css("a").first
  title = anchor.text
  uri = URI.join(base_uri, anchor.attributes["href"].value)

  table_data = info.css("td")
  limit = table_data[0].text
  date = table_data[1].text
  place = table_data[2].text.sub(/\(.*\)/, '')

  puts "title: #{title}, uri: #{uri}, limit: #{limit}, date: #{date}, place: #{place}"
end
