class PostStatusJob
  include Sidekiq::Worker
  sidekiq_options queue: "posts"

  def perform(post_id)
    post = FacebookPost.find(post_id)
    return if post.final_status?

    post.parse_all_links! # ensure posts have #all_links and #all_domains
    set_status!(post)
  end

  private

  def set_status!(post)
    domains = post.all_domains

    # if any domain is blacklisted
    status = if blacklist_domain_matcher.match?(domains)
      "blacklisted"
    # if all domains are whitelisted
    elsif whitelist_domain_matcher.match_all?(domains)
      "whitelisted"
    # if some suspect keyword match
    elsif keyword_matcher.match?(post.message)
      "suspect"
    end

    if status && status != post.status
      old_status = post.status
      post.change_status_to!(status, "PostStatusJob")
      post.create_activity(status, parameters: { name: post.permalink, auto: true })
      PostScreenshotsJob.perform_async(post.id) if status == "blacklisted"
      logger.info "PostStatusJob: changed FacebookPost #{post.id} status from #{old_status} to #{status}"
    end
  end

  def keyword_matcher
    @keyword_matcher ||= KeywordMatcher.new
  end

  def blacklist_domain_matcher
    @blacklist_domain_matcher ||= DomainMatcher.new
  end

  def whitelist_domain_matcher
    @whitelist_domain_matcher ||= DomainMatcher.new(status: "whitelisted")
  end

  def logger
    @logger ||= Logger.new(Rails.root.join('log/jobs.log'))
  end
end
