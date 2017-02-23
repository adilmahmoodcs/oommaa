require "csv"

class PostsCSVExporter
  attr_reader :posts

  def initialize(posts)
    @posts = posts
  end

  def call
    ::CSV.generate(csv_options) do |csv|
      csv << fields.map do |field|
        I18n.t(field)
      end

      posts.each do |post|
         csv << [
          I18n.l(post.published_at, format: :compact),
          I18n.l(post.blacklisted_at, format: :compact),
          post.blacklisted_by,
          post.brand_names,
          post.licensor_names,
          post.all_domains.join(", "),
          post.facebook_page.name,
          post.message,
          post.all_links.last
        ]
      end
    end
  end

  private

  def csv_options
    {}
  end

  def fields
    %w[published_at blacklisted_at blacklisted_by brand_name licensor_name platform_or_company
       facebook_page_name message link_to_product]
  end
end
