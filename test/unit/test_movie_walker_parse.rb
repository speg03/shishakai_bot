# -*- coding: utf-8 -*-

require 'test-unit'
require 'nokogiri'
require 'open-uri'

require 'shishakai_bot/movie_walker'

module ShishakaiBot
  class TestMovieWalkerParse < Test::Unit::TestCase

    class <<self
      def startup
        @@doc = Nokogiri::HTML(open(MovieWalker::BASE_URI))
      end
    end

    test "previewMovieInfo要素が存在していること" do
      assert { 0 != @@doc.css("div.previewMovieInfo").length }
    end

    test "previewMovieInfoの各テーブルヘッダが応募締切、開催日時、開催場所であること" do
      table_header = @@doc.css("div.previewMovieInfo").first.css("th")
      assert_equal("応募締切", table_header[0].text)
      assert_equal("開催日時", table_header[1].text)
    end

  end
end
