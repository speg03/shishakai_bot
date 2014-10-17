require 'uri'
require 'pg'

module ShishakaiBot
  class TweetedPages

    def initialize(database_url)
      url = URI.parse(database_url)
      @conn = PG.connect(host: url.host, port: url.port,
                         user: url.user, password: url.password,
                         dbname: url.path[1..-1])
    end

    def uris
      @conn.exec("SELECT * FROM tweeted_pages").map do |row|
        row['uri']
      end
    end

    def add(uri)
      @conn.exec("INSERT INTO tweeted_pages VALUES ('#{uri}')")
    end

    def remove(uri)
      @conn.exec("DELETE FROM tweeted_pages WHERE uri = '#{uri}'")
    end

  end
end
