require 'embiggen'

class LinksParser
  attr_reader :links

  def initialize(links)
    @links = links
  end

  def call
    clean_links.map do |link|
      begin
        Embiggen::URI(link).expand.to_s
      rescue BadShortenedURI, TooManyRedirects => e
        puts "Bad short url '#{raw_link}': #{e.message}"
        nil
      end
    end.compact
  end

  private

  def clean_links
    links.delete_if(&:blank?).map(&:strip).uniq
  end
end