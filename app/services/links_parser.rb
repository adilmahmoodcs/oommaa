require "typhoeus"

class LinksParser
  attr_reader :links

  def initialize(links)
    @links = links
  end

  def call
    clean_links.map do |link|
      response = Typhoeus.get(link, followlocation: true)

      if response.success?
        response.effective_url
      else
        puts "Bad short url '#{link}'"
        nil
      end
    end.compact
  end

  private

  def clean_links
    links.delete_if(&:blank?).map(&:strip).uniq
  end
end
