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
    # if any domain is already blacklisted
    status = if domain_matcher.match?(post.all_domains)
      :blacklisted
    # if some suspect keyword match
    elsif keyword_matcher.match?(post.message)
      :suspect
    end

    post.update_attributes!(status: status) if status
  end

  def keyword_matcher
    @keyword_matcher ||= KeywordMatcher.new
  end

  def domain_matcher
    @domain_matcher ||= DomainMatcher.new
  end
end
