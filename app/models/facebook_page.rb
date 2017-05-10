# == Schema Information
#
# Table name: facebook_pages
#
#  id                       :integer          not null, primary key
#  name                     :string           not null
#  url                      :string           not null
#  image_url                :string
#  facebook_id              :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  old_brand_ids            :integer          default("{}"), is an Array
#  shut_down_by_facebook_at :datetime
#  cached_licensor_ids      :integer          default("{}"), is an Array
#  status                   :integer          default("0")
#  affiliate_name           :string
#
# Indexes
#
#  index_facebook_pages_on_cached_licensor_ids  (cached_licensor_ids)
#  index_facebook_pages_on_old_brand_ids        (old_brand_ids)
#

class FacebookPage < ApplicationRecord
  include PublicActivity::Common

  has_many :facebook_posts, dependent: :destroy
  has_many :facebook_page_brands, dependent: :destroy
  has_many :brands, through: :facebook_page_brands
  has_many :licensors, through: :brands

  validates :name, :url, :facebook_id, presence: true
  validates :facebook_id, uniqueness: true

  before_save :update_cached_licensor_ids

  scope :of_licensor, -> (licensor) {
    where("? = ANY(cached_licensor_ids)", licensor.id)
  }

  enum status: [
    :brand_page, :affiliate_page
  ].freeze

  ransacker :name_case_insensitive, type: :string do
    arel_table[:name].lower
  end

  def brand_names
    brands.map(&:name).join(", ")
  end

  def licensor_names
    licensors.pluck(:name).compact.uniq.join(", ")
  end

  def mark_as_shut_down!
    now = Time.now
    update_attributes(shut_down_by_facebook_at: now)
    facebook_posts.where(shut_down_by_facebook_at: nil).
                   update_all(shut_down_by_facebook_at: now, updated_at: now)
  end

  def update_cached_licensor_ids
    self.cached_licensor_ids = brands.pluck(:licensor_id).compact.uniq
  end
end
