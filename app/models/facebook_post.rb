# == Schema Information
#
# Table name: facebook_posts
#
#  id                       :integer          not null, primary key
#  facebook_id              :string           not null
#  message                  :string           not null
#  published_at             :datetime
#  permalink                :string
#  image_url                :string
#  status                   :integer          default("0"), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  facebook_page_id         :integer
#  link                     :string
#  all_links                :string           default("{}"), is an Array
#  whitelisted_at           :datetime
#  whitelisted_by           :string
#  blacklisted_at           :datetime
#  blacklisted_by           :string
#  reported_to_facebook_at  :datetime
#  reported_to_facebook_by  :string
#  shut_down_by_facebook_at :datetime
#  all_domains              :string           default("{}"), is an Array
#
# Indexes
#
#  index_facebook_posts_on_all_domains       (all_domains)
#  index_facebook_posts_on_all_links         (all_links)
#  index_facebook_posts_on_facebook_page_id  (facebook_page_id)
#

class FacebookPost < ApplicationRecord
  include PublicActivity::Common

  enum status: [
    :not_suspect, :suspect, :whitelisted, :blacklisted, :reported_to_facebook
  ]

  belongs_to :facebook_page

  validates :facebook_id, :message, :facebook_page, presence: true
  validates :facebook_id, uniqueness: true

  delegate :brands, to: :facebook_page

  def change_status_to!(new_status, by)
    self.status = new_status
    if respond_to?(status_changed_at_writer, true)
      self.send(status_changed_at_writer, Time.now)
    end
    if respond_to?(status_changed_by_writer, true) && by
      self.send(status_changed_by_writer, by)
    end

    save!
  end

  def raw_links
    raw_links = URI.extract(message, ["http", "https"])
    raw_links << link if link.present?
    raw_links.delete_if { |l| l.match?(/https\:\/\/www\.facebook\.com\//) }
  end

  # does HTTP requests, better to call in async context
  def parse_all_links!
    links = LinksParser.new(raw_links).call
    update_attributes!(
      all_links: links,
      all_domains: get_all_domains_from(links)
    )
  end

  def brand_names
    brands.map(&:name).join(", ")
  end

  def licensor_names
    brands.map(&:licensor_name).compact.uniq.join(", ")
  end

  def status_changed_at
    send(status_changed_at_reader) if respond_to?(status_changed_at_reader, true)
  end

  def status_changed_by
    send(status_changed_by_reader) if respond_to?(status_changed_by_reader, true)
  end

  private

  def get_all_domains_from(links)
    links.map do |link|
      uri = URI.parse(link)
      begin
        PublicSuffix.parse(uri.host).domain
      rescue PublicSuffix::DomainInvalid
        "<INVALID URL>"
      end
    end.uniq
  end

  def status_changed_at_reader
    "#{status}_at"
  end

  def status_changed_by_reader
    "#{status}_by"
  end

  def status_changed_at_writer
    "#{status_changed_at_reader}="
  end

  def status_changed_by_writer
    "#{status_changed_by_reader}="
  end
end
