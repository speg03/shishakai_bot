require 'twitter'
require 'logger'

module ShishakaiBot
  class Main

    def initialize(config)
      @log = Logger.new(STDOUT)
      @log.level = Logger::INFO

      @twitter = Twitter::REST::Client.new do |c|
        c.consumer_key = config[:consumer_key]
        c.consumer_secret = config[:consumer_secret]
        c.access_token = config[:access_token]
        c.access_token_secret = config[:access_token_secret]
      end

      @tweeted_pages = TweetedPages.new(config[:database_url])
      @movie_walker = MovieWalker.new
    end

    def run(dry_run = false)
      old_uris = @tweeted_pages.uris
      uris = @movie_walker.uris
      pages = @movie_walker.pages

      (old_uris - uris).each do |uri|
        @tweeted_pages.remove(uri) unless dry_run
        @log.info("Remove from tweeted_pages: #{uri}")
      end

      (uris - old_uris).each do |uri|
        tweet = pages[uri].to_s
        @twitter.update(tweet) unless dry_run
        @log.info("Twitter updated: #{tweet}")
        @tweeted_pages.add(uri) unless dry_run
        @log.info("Add to tweeted_pages: #{uri}")
      end
    end

  end
end
