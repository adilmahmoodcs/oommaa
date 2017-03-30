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
          (I18n.l(post.blacklisted_at, format: :compact) if post.blacklisted_at),
          post.blacklisted_by,
          post.message,
          post.brand_names,
          post.licensor_names,
          post.all_domains.join(", "),
          post.facebook_page.name,
          (I18n.l(post.reported_to_facebook_at, format: :compact) if post.reported_to_facebook_at),
          post.reported_to_facebook_by,
          (I18n.l(post.shut_down_by_facebook_at, format: :compact) if post.shut_down_by_facebook_at),
          post.facebook_report_number,
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
    %w[
      published_at
      blacklisted_at
      blacklisted_by
      message
      brand_name
      licensor_name
      platform_or_company
      facebook_page_name
      reported_to_facebook_at
      reported_to_facebook_by
      shut_down_by_facebook_at
      facebook_report_number
      link_to_product
    ]
  end
end
