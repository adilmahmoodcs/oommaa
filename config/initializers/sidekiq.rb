unless Rails.env.development?
  url = "unix:///tmp/redis_persistent.sock"

  Sidekiq.configure_server do |config|
    config.redis = { url: url }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: url }
  end
end
