class PostsImporterJob
  include Sidekiq::Worker
  sidekiq_options queue: "posts"

  def perform(page_id)
    import_posts(page_id)

    self.class.perform_in(60.minutes, page_id)
  end

  private

  def import_posts(page_id)
    page = FacebookPage.find(page_id)
    posts_data = FBPostSearcher.new(page_id: page.facebook_id, token: token).call
    keyword_matcher = KeywordMatcher.new

    posts_data.each do |data|
      # we reached already imported posts...
      break if FacebookPost.exists?(facebook_id: data["id"])

      if data["message"].present?
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
  end

  def token
    Rails.configuration.counterfind["facebook"]["tokens"].sample
  end
end
