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
          I18n.l(post.posted_at, format: :long),
          I18n.l(post.status_changed_at, format: :long),
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
    %w[posted_at status_changed_at brand_name licensor_name platform_or_company
       facebook_page_name message link_to_product]
  end
end
