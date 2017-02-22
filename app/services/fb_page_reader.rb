require "koala"

class FBPageReader
  attr_reader :object_id, :token

  def initialize(object_id:, token:)
    @object_id = object_id
    @token = token
  end

  def call
    graph.get_object(object_id, fields: fields)
  end

  private

  def graph
    Koala::Facebook::API.new(token)
  end

  def fields
    ["id", "link", "name", "picture.width(200)"]
  end
end
