# == Schema Information
#
# Table name: brand_logos
#
#  id                 :integer          not null, primary key
#  brand_id           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#
# Indexes
#
#  index_brand_logos_on_brand_id  (brand_id)
#

class BrandLogo < ApplicationRecord
  belongs_to :brand

  has_attached_file :image,
                    styles: { thumb: "200x200>" },
                    default_url: "/images/missing.png"

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
