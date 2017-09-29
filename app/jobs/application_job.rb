class ApplicationJob < ActiveJob::Base
  rescue_from ActiveJob::DeserializationError do |exception|
  end
end
