# == Schema Information
#
# Table name: post_brands
#
#  id               :integer          not null, primary key
#  facebook_post_id :integer
#  brand_id         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_post_brands_on_brand_id          (brand_id)
#  index_post_brands_on_facebook_post_id  (facebook_post_id)
#

FactoryGirl.define do
  factory :post_brand do
    facebook_post_id { [create(:facebook_post).id] }
    brand_id { [create(:brand).id] }
  end

end
