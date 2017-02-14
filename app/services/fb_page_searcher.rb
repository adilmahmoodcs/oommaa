require "koala"

class FBPageSearcher
  attr_reader :term, :token, :all_pages, :limit

  def initialize(term:, token:, all_pages: true, limit: 500)
    @term = term
    @token = token
    @all_pages = all_pages
    @limit = limit
  end

  def call
    results = []
    begin
      result = graph.search(term, type: "page", fields: fields, limit: limit)
      results = result

      if all_pages
        results += result while result = result.next_page
      end
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
    ["id", "name"]
  end
end
