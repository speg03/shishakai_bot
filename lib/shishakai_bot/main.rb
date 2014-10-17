require 'twitter'

module ShishakaiBot
  class Main

    def initialize(config)
      @twitter = Twitter::REST::Client.new do |c|
        c.consumer_key = config[:consumer_key]
        c.consumer_secret = config[:consumer_secret]
        c.access_token = config[:access_token]
        c.access_token_secret = config[:access_token_secret]
      end

      @tweeted_pages = TweetedPages.new(config[:database_url])
      @movie_walker = MovieWalker.new
    end

    def run
      old_uris = @tweeted_pages.uris
      uris = @movie_walker.uris
      pages = @movie_walker.pages

      (old_uris - uris).each do |uri|
        @tweeted_pages.remove(uri)
      end

      (uris - old_uris).each do |uri|
        @twitter.update(pages[uri].to_s)
        @tweeted_pages.add(uri)
      end
    end

  end
end
