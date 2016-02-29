# -*- coding: utf-8 -*-

require 'test-unit'
require 'shishakai_bot/movie_walker'

module ShishakaiBot
  class TestMovieWalker < Test::Unit::TestCase
    def setup
      sample_uri = "https://raw.githubusercontent.com/speg03/shishakai_bot/master/test/sample/movie_walker.html"
      @mw = MovieWalker.new(sample_uri)
    end

    test "3件の試写会ページがあること" do
      assert { 4 == @mw.pages.length }
      assert { 4 == @mw.uris.length }
    end

    data(
         page1: ["https://raw.githubusercontent.com/shisyakai/8610/", 0],
         page2: ["https://raw.githubusercontent.com/shisyakai/8607/", 1],
         page3: ["https://raw.githubusercontent.com/shisyakai/8615/", 2],
         page4: ["https://raw.githubusercontent.com/shisyakai/9023/", 3]
    )
    test "URIがHTML上と逆順でフルパスになっていること" do |data|
      expected, index = data
      assert { expected == @mw.uris[index] }
    end
  end
end
