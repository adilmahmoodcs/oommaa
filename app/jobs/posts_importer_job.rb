class PostsImporterJob < ApplicationJob
  queue_as :posts

  def perform(page)
    posts_data = FBPostSearcher.new(page_id: page.facebook_id, token: token).call
    keyword_matcher = KeywordMatcher.new

    posts_data.each do |data|
      if data["message"].present? && !FacebookPost.exists?(facebook_id: data["id"])
        match = keyword_matcher.match?(data["message"])

        page.facebook_posts.create!(
          facebook_id: data["id"],
          message: data["message"],
          posted_at: data["created_time"],
          permalink: data["permalink_url"],
          image_url: data["full_picture"],
          status: match ? :suspect : :not_suspect
        )
      end
    end

    self.class.set(wait: 60.minutes).perform_later(page)
  end

  private

  def token
    Rails.configuration.counterfind["facebook"]["tokens"].sample
  end
end
