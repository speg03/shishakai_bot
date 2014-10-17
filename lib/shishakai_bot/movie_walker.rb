# -*- coding: utf-8 -*-

require 'nokogiri'
require 'open-uri'

module ShishakaiBot
  class MovieWalker

    BASE_URI = "http://movie.walkerplus.com/shisyakai/"

    def initialize(base_uri = BASE_URI)
      @pages = parse(base_uri)
    end

    def parse(base_uri)
      pages = {}
      doc = Nokogiri::HTML(open(base_uri))
      doc.css("div.previewMovieInfo").reverse_each do |info|
        anchor = info.css("a").first
        title = anchor.text
        uri = URI.join(base_uri, anchor.attributes["href"].value).to_s

        table_data = info.css("td")
        limit = table_data[0].text
        date = table_data[1].text
        place = table_data[2].text.sub(/\(.*\)/, '')

        pages[uri] = MovieWalkerPage.new(title: title, limit: limit, date: date,
                                         place: place, uri: uri)
      end
      pages
    end

    def pages
      @pages
    end

    def uris
      @pages.keys
    end

  end

  class MovieWalkerPage

    def initialize(args)
      @title = args[:title]
      @limit = args[:limit]
      @date = args[:date]
      @place = args[:place]
      @uri = args[:uri]
    end

    def to_s
      "#{@title}\n応募締切: #{@limit}\n開催日時: #{@date}\n開催場所: #{@place}\n#{@uri}"
    end

  end
end
