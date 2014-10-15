#!/usr/bin/env ruby

require 'nokogiri'
require 'uri'
require 'open-uri'
require 'pg'

base_uri = "http://movie.walkerplus.com/shisyakai/"
doc = Nokogiri::HTML(open(base_uri))

movie_info = {}
doc.css("div.previewMovieInfo").each do |info|
  anchor = info.css("a").first
  title = anchor.text
  uri = URI.join(base_uri, anchor.attributes["href"].value).to_s

  table_data = info.css("td")
  limit = table_data[0].text
  date = table_data[1].text
  place = table_data[2].text.sub(/\(.*\)/, '')

  movie_info[uri] = {title: title, limit: limit, date: date, place: place}
end

current_pages = movie_info.keys

db_url = URI.parse(ENV['DATABASE_URL'])

conn = PG.connect({host: db_url.host, port: db_url.port, dbname: db_url.path[1..-1], user: db_url.user, password: db_url.password})
previous_pages = conn.exec("SELECT * FROM tweeted_pages").map {|row| row["uri"] }

old_pages = previous_pages - current_pages
old_pages.each do |page|
  conn.exec("DELETE FROM tweeted_pages WHERE uri = '#{page}'")
end

new_pages = current_pages - previous_pages
new_pages.each do |page|
  # TODO: tweet movie_info[page]
  conn.exec("INSERT INTO tweeted_pages VALUES ('#{page}')")
end
