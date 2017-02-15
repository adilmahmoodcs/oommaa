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
      page = graph.get_connections(page_id, "feed", fields: fields, limit: 100)
      filtered_results = filter_data(page)
      results = filtered_results
      # data is sorted by date. if some where filtered out, we can stop
      return results if filtered_results.size < page.size

      if all_pages
        while page = page.next_page
          filtered_results = filter_data(page)
          results += filtered_results
          return results if filtered_results.size < page.size
        end
      end

      results
    rescue Koala::Facebook::ClientError => e
      raise e
      puts "Facebook client error: #{e.message}"
      # TODO handle errors
      return []
    end

    results
  end

  # skip posts older than 60 days. data is sorted by descending date
  def filter_data(posts)
    limit_date = 60.days.ago
    posts.take_while do |data|
      Time.parse(data["created_time"]) > limit_date
    end
  end

  private

  def graph
    @graph ||= Koala::Facebook::API.new(token)
  end

  def fields
    ["id", "message", "created_time", "permalink_url", "full_picture"]
  end
end
