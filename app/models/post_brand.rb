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

class PostBrand < ApplicationRecord
  belongs_to :facebook_post
  belongs_to :brand

  validates :brand, :facebook_post, presence: true
  validates :brand, uniqueness: { scope: :facebook_post}

  def assign_brand_to_post(post,brand)
    post_brand = PostBrand.build(facebook_post: post, brand: brand)
    post_brand.save ? true : post_brand.errors.full_messages.to_sentence
  end
end
