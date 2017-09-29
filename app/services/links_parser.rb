require "typhoeus"

class LinksParser
  attr_reader :links

  def initialize(links)
    @links = links
  end

  def call
    clean_links.map do |link|
      response = Typhoeus.get(link,
                              followlocation: true,
                              timeout: 60,
                              maxredirs: 6)
      if response.return_code == :ok
        response.effective_url
      else
        puts "Bad short url '#{link}'"
        nil
      end
    end.compact
  end

  private

  def clean_links
    links.delete_if(&:blank?).
          map(&:strip).
          map { |link| URI.escape(link) }.
          uniq
  end
end
