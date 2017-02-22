require "koala"

class FBPhotoReader
  attr_reader :object_id, :token

  def initialize(object_id:, token:)
    @object_id = object_id
    @token = token
  end

  def call
    data = graph.get_object(object_id, fields: fields)
    data["permalink_url"] = data.delete("link")
    data
  end

  private

  def graph
    Koala::Facebook::API.new(token)
  end

  def fields
    ["id", "created_time", "from", "link", "name", "picture"]
  end
end
