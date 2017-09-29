require "koala"

class FBShutDownChecker
  attr_reader :object_id, :token

  def initialize(object_id:, token:)
    @object_id = object_id
    @token = token
  end

  def call
    shut_down = false

    begin
      graph.get_object(object_id)
    rescue Koala::Facebook::ClientError => e
      shut_down = e.fb_error_code.in?(shut_down_error_codes)
    end

    shut_down
  end

  private

  def graph
    Koala::Facebook::API.new(token)
  end

  def shut_down_error_codes
    [100]
  end
end
