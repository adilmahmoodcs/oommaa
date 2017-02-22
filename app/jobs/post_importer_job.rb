# import a single FB "post" (may be post, image or video) and its page
class PostImporterJob
  include Sidekiq::Worker
  sidekiq_options queue: "posts"

  def perform(url)
    object_id, type = FbURLParser.new(url).call
    return false unless object_id

    data = case type
    when :photo
      FBPhotoReader.new(object_id: object_id, token: token).call
    when :post
      FBPostReader.new(object_id: object_id, token: token).call
    when :video
      FBVideoReader.new(object_id: object_id, token: token).call
    when :page
      # TODO
      return false
    end

    if post = FacebookPost.find_by(facebook_id: data["id"])
      return post
    end

    page = find_or_create_page(data["from"]["id"])
    post = find_or_create_post(data, page)
    post
  end

  private

  def find_or_create_page(object_id)
    if page = FacebookPage.find_by(facebook_id: object_id)
      return page
    end

    data = FBPageReader.new(object_id: object_id, token: token).call
    FacebookPage.create!(
      facebook_id: data["id"],
      name: data["name"],
      url: data["link"],
      image_url: data.dig("picture", "data", "url"),
      brand_ids: matching_brands_for(data["name"]).map(&:id)
    )
  end

  def find_or_create_post(data, page)
    post = page.facebook_posts.create!(
      facebook_id: data["id"],
      message: data["name"],
      posted_at: data["created_time"],
      permalink: data["permalink_url"],
      image_url: data["picture"],
      link: data["link"],
      status: "blacklisted", # temp
      status_changed_at: Time.now # temp
    )
    post.parse_all_links!
    post
  end

  def matching_brands_for(term)
    Brand.select(:id, :name).find_all do |brand|
      term.to_s.match?(/#{brand.name}/i)
    end
  end

  def token
    Rails.configuration.counterfind["facebook"]["tokens"].sample
  end
end
