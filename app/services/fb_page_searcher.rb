require "koala"

class FBPageSearcher
  attr_reader :term, :token

  def initialize(term:, token:)
    @term = term
    @token = token
  end

  def call
    results = []
    begin
      result = graph.search(term, type: "page", fields: fields, limit: 500)
      results = result

      results += result while result = result.next_page
    rescue Koala::Facebook::ClientError => e
      puts "Facebook client error: #{e.message}"
      # TODO handle errors
      return []
    end

    results
  end

  private

  def graph
    @graph ||= Koala::Facebook::API.new(token)
  end

  def fields
    ["id", "name", "link", "picture.width(200)"]
  end
end
