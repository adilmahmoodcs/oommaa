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
#  added_by                 :string
#  facebook_report_number   :string
#  likes                    :integer
#  mass_job_status          :integer          default("0")
#  greylisted_at            :datetime
#  greylisted_by            :string
#  shutdown_queue_at        :datetime
#  shutdown_queue_by        :string
#
# Indexes
#
#  index_facebook_posts_on_all_domains              (all_domains)
#  index_facebook_posts_on_all_links                (all_links)
#  index_facebook_posts_on_facebook_page_id         (facebook_page_id)
#  index_facebook_posts_on_status_and_published_at  (status,published_at)
#

class FacebookPost < ApplicationRecord
  include PublicActivity::Common

  enum status: [
    :not_suspect, :suspect, :whitelisted, :blacklisted, :reported_to_facebook,
    :ignored, :greylisted, :affiliate_greylisted, :shutdown_queue
  ]

  enum mass_job_status: [
    :no_status, :to_be_not_suspect, :to_be_suspect, :to_be_whitelisted, :to_be_blacklisted, :to_be_reported_to_facebook,
    :to_be_ignored, :to_be_greylisted, :to_be_affiliate_greylisted, :to_be_shutdown_queue
  ].freeze

  belongs_to :facebook_page
  has_many :screenshots, dependent: :destroy
  has_many :ad_screenshots
  has_many :product_screenshots
  has_many :facebook_page_post_brands

  validates :facebook_id, :message, :facebook_page, presence: true
  validates :facebook_id, uniqueness: true
  after_save :check_facebook_shutdown_status, if: Proc.new {|p| p.status_changed? and (
                                                   p.status == "blacklisted" or
                                                   p.status == "reported_to_facebook")}

  default_scope { where(mass_job_status: :no_status) }
  scope :with_any_domain, -> (name) { where("? = ANY (all_domains)", name) }
  scope :date_yesterday, -> { where() }
  scope :blacklisted_or_reported_to_facebook, -> {
    where(status: [statuses[:blacklisted], statuses[:reported_to_facebook]])
  }
  scope :of_licensor, -> (licensor, user) {
    ransack(facebook_page_post_brands_facebook_page_brand_brand_licensor_id_eq: licensor.id).result.
    where('ARRAY[?]::varchar[] @> facebook_posts.all_domains', user.domains.pluck(:name))
  }
  scope :shut_down, -> { where.not(shut_down_by_facebook_at: nil) }
  scope :reported_to_facebook_by, -> (user) { where(reported_to_facebook_by: user.email) }
  scope :added_by, -> (user) { where(added_by: user.email) }

  ransacker :status, formatter: proc { |status_name| statuses[status_name] }

  ESTIMATED_VALUE = 120 # $
  IGNORE_POST_FOR = [nil, "PostStatusJob"]

  def self.ransackable_scopes(auth_object = nil)
    [:with_any_domain]
  end

  def change_status_to!(new_status, by)
    return if final_status?

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
    raw_links.delete_if { |l| l.match? (/https\:\/\/www\.facebook\.com\//) }
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

  # some statuses are final and can't be changed
  def final_status?
    status.in? ["reported_to_facebook"]
  end

  def brand_names
    self.facebook_page_post_brands.map(&:brand_name).uniq.join(",")
  end

  def brand_ids
    self.facebook_page_post_brands.map(&:brand_id).uniq
  end

  def licensor_names
    self.facebook_page_post_brands.map(&:licensor_name).uniq.join(",")
  end

  def licensor_ids
    self.facebook_page_post_brands.map(&:licensor_id).uniq
  end

  def check_facebook_shutdown_status
    ShutDownCheckerJob.perform_async(id)
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
