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
#
# Indexes
#
#  index_facebook_pages_on_old_brand_ids  (old_brand_ids)
#

class FacebookPage < ApplicationRecord
  include PublicActivity::Common

  has_many :facebook_posts, dependent: :destroy
  has_many :facebook_page_brands
  has_many :brands, through: :facebook_page_brands

  validates :name, :url, :facebook_id, presence: true
  validates :facebook_id, uniqueness: true

  scope :with_any_brand, -> (id) { where("? = ANY (brand_ids)", id) }
  scope :with_licensor_name, -> (name) {
    joins("JOIN brands ON brands.id = ANY(facebook_pages.brand_ids) JOIN licensors ON licensors.id = brands.licensor_id").
    where(licensors: { name: name })
  }

  ransacker :name_case_insensitive, type: :string do
    arel_table[:name].lower
  end

  def brand_names
    brands.map(&:name).join(", ")
  end

  def licensor_names
    brands.map(&:licensor_name).compact.uniq.join(", ")
  end

  def mark_as_shut_down!
    now = Time.now
    update_attributes(shut_down_by_facebook_at: now)
    facebook_posts.where(shut_down_by_facebook_at: nil).
                   update_all(shut_down_by_facebook_at: now, updated_at: now)
  end
end
