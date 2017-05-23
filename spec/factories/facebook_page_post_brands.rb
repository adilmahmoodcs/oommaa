# == Schema Information
#
# Table name: facebook_page_post_brands
#
#  id                     :integer          not null, primary key
#  facebook_post_id       :integer
#  facebook_page_brand_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_facebook_page_post_brands_on_facebook_page_brand_id  (facebook_page_brand_id)
#  index_facebook_page_post_brands_on_facebook_post_id        (facebook_post_id)
#

FactoryGirl.define do
  factory :facebook_page_post_brand do
    
  end

end
