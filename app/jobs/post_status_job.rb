class PostStatusJob
  include Sidekiq::Worker
  sidekiq_options queue: "posts"

  def perform(post_id)
    post = FacebookPost.find(post_id)
    post.parse_all_links! # ensure posts have #all_links
    set_status!(post)
  end

  private

  def set_status!(post)
    domains = post.all_domains

    # if any domain is already blacklisted
    status = if blacklist_domain_matcher.match?(domains)
      "blacklisted"
    # if all domains are whitelisted
    elsif whitelist_domain_matcher.match_all?(domains)
      "not_suspect"
    # if some suspect keyword match
    elsif keyword_matcher.match?(post.message)
      "suspect"
    end

    if status && status != post.status
      post.update_attributes!(
        status: status,
        status_changed_at: Time.now
      )
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
end
