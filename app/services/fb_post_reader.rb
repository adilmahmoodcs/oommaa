require "koala"

class FBPostReader
  attr_reader :object_id, :token

  def initialize(object_id:, token:)
    @object_id = object_id
    @token = token
  end

  def call
    data = graph.get_object(object_id, fields: fields)
    data["name"] = data.delete("message")
    data
  end

  private

  def graph
    Koala::Facebook::API.new(token)
  end

  def fields
    [
      "id", "created_time", "from", "link", "message", "permalink_url",
      "picture", "likes.limit(0).summary(true)"
    ]
  end
end
