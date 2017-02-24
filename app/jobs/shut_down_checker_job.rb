# check if a Facebook object was shut down
class ShutDownCheckerJob
  include Sidekiq::Worker
  sidekiq_options queue: "posts"

  def perform(post_id)
    post = FacebookPost.find(post_id)
    result = FBShutDownChecker.new(object_id: post.facebook_id, token: token).call

    if result
      unless post.shut_down_by_facebook_at
        post.update_attributes!(shut_down_by_facebook_at: Time.now)
      end
    else
      # retry...
      self.class.perform_in(75.minutes, post_id)
    end
  end

  private

  def token
    Rails.configuration.counterfind["facebook"]["tokens"].sample
  end
end
