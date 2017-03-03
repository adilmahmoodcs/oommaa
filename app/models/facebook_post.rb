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
  has_many :screenshots, dependent: :destroy
  has_many :ad_screenshots
  has_many :product_screenshots

  validates :facebook_id, :message, :facebook_page, presence: true
  validates :facebook_id, uniqueness: true

  delegate :brands, :brand_names, :licensor_names, to: :facebook_page

  scope :with_any_domain, -> (name) { where("? = ANY (all_domains)", name) }
  scope :with_any_brand, -> (name) { joins(:facebook_page).merge(FacebookPage.with_any_brand(name)) }
  scope :with_licensor_name, ->(name) {
    joins(:facebook_page).merge(FacebookPage.with_licensor_name(name))
  }
  scope :date_yesterday, -> { where() }
  scope :blacklisted_or_reported_to_facebook, -> {
    where(status: [statuses[:blacklisted], statuses[:reported_to_facebook]])
  }

  ransacker :status, formatter: proc { |status_name| statuses[status_name] }

  def self.ransackable_scopes(auth_object = nil)
    [:with_any_domain, :with_any_brand, :with_licensor_name]
  end

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
    raw_links.delete_if { |l| !(Addressable::URI.parse(l) rescue nil) }
    raw_links.compact
  end

  # does HTTP requests, better to call in async context
  def parse_all_links!
    links = LinksParser.new(raw_links).call
    update_attributes!(
      all_links: links,
      all_domains: get_all_domains_from(links)
    )
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
