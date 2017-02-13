require "koala"

class FBPostSearcher
  attr_reader :page_id, :token, :all_pages

  def initialize(page_id:, token:, all_pages: true)
    @page_id = page_id
    @token = token
    @all_pages = all_pages
  end

  def call
    results = []
    begin
      result = graph.get_connections(page_id, "feed", fields: fields, limit: 100)
      results = result

      if all_pages
        results += result while result = result.next_page
      end
    rescue Koala::Facebook::ClientError => e
      raise e
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
    ["id", "message", "created_time", "permalink_url", "full_picture"]
  end
end
