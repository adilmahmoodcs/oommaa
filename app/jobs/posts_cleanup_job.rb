class PostsCleanupJob
  include Sidekiq::Worker
  sidekiq_options queue: "not_facebook"

  def perform
    scope = FacebookPost.ignored.where("published_at < ?", 60.days.ago)
    count = scope.size

    scope.destroy_all
    logger.info "PostsCleanupJob: Destroyed #{count} old ignored posts"

    self.class.perform_in(3.days)
  end

  private

  def logger
    @logger ||= Logger.new(Rails.root.join('log/jobs.log'))
  end
end
