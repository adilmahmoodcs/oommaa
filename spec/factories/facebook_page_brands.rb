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

FactoryGirl.define do
  factory :facebook_page_brand do
    facebook_page nil
brand nil
  end

end
