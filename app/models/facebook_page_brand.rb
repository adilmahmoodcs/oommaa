# == Schema Information
#
# Table name: facebook_page_brands
#
#  id               :integer          not null, primary key
#  facebook_page_id :integer
#  brand_id         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_facebook_page_brands_on_brand_id          (brand_id)
#  index_facebook_page_brands_on_facebook_page_id  (facebook_page_id)
#

class FacebookPageBrand < ApplicationRecord
  belongs_to :facebook_page
  belongs_to :brand
end
