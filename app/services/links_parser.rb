require "faraday_middleware"

class LinksParser
  attr_reader :links

  def initialize(links)
    @links = links
  end

  def call
    clean_links.map do |link|
      begin
        connection = Faraday.new(link) do |conn|
          conn.response :follow_redirects, limit: 5
          conn.adapter Faraday.default_adapter
        end
        # final URL after following redirects
        connection.get.env.url.to_s
      rescue Faraday::ConnectionFailed, URI::InvalidURIError => e
        puts "Bad short url '#{link}': #{e.message}"
        nil
      end
    end.compact
  end

  private

  def clean_links
    links.delete_if(&:blank?).map(&:strip).uniq
  end
end
