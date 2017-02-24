# == Schema Information
#
# Table name: facebook_pages
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  url         :string           not null
#  image_url   :string
#  facebook_id :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  brand_ids   :integer          default("{}"), is an Array
#
# Indexes
#
#  index_facebook_pages_on_brand_ids  (brand_ids)
#

class FacebookPage < ApplicationRecord
  has_many :facebook_posts, dependent: :destroy

  validates :name, :url, :facebook_id, presence: true
  validates :facebook_id, uniqueness: true

  scope :with_any_brand, -> (id) { where("? = ANY (brand_ids)", id) }
  scope :with_licensor_name, -> (name) {
    joins("JOIN brands ON brands.id = ANY(facebook_pages.brand_ids) JOIN licensors ON licensors.id = brands.licensor_id").
    where(licensors: { name: name })
  }

  def brands
    @brands ||= Brand.where(id: brand_ids)
  end
end
