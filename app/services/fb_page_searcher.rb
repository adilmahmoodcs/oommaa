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
    result = graph.search(term, type: "page", fields: fields, limit: limit)
    results = result

    if all_pages
      results += result while result = result.next_page
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
