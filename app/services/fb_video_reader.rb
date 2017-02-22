require "koala"

class FBVideoReader
  attr_reader :object_id, :token

  def initialize(object_id:, token:)
    @object_id = object_id
    @token = token
  end

  def call
    data = graph.get_object(object_id, fields: fields)
    data["name"] = data.delete("title")
    data
  end

  private

  def graph
    Koala::Facebook::API.new(token)
  end

  def fields
    ["id", "created_time", "from", "permalink_url", "title", "picture"]
  end
end
