require "koala"
require "addressable/uri"

# (try to) get a graph object ID from a facebook URL
class FbURLParser
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def call
    case url.strip
    # can also be a photo...
    when /\Ahttps:\/\/www\.facebook\.com\/.+\/posts\/(\w+)/
      [$1, :post]
    when /\Ahttps:\/\/www\.facebook\.com\/groups\/.+\/permalink\/(\w+)/
      [$1, :post]
    # FIXME this can also be a user status update
    when /\Ahttps:\/\/www\.facebook\.com\/permalink\.php/
      id = Addressable::URI.parse(url).query_values["id"].presence
      [id, :post]
    when /\Ahttps:\/\/www\.facebook\.com\/.+\/videos\/(\w+)/
      [$1, :video]
    when /\Ahttps:\/\/www\.facebook\.com\/photo\.php/
      id = Addressable::URI.parse(url).query_values["fbid"].presence
      [id, :photo]
    when /\Ahttps:\/\/www\.facebook\.com\/.+\/photos\/.+\/(\w+)/
      [$1, :photo]
    when /\Ahttps:\/\/www\.facebook\.com\/([^\/?&]+)\/?/
      [$1, :page]
    else
      [nil, nil]
    end
  end
end
