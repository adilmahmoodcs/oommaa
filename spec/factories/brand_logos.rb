# == Schema Information
#
# Table name: brand_logos
#
#  id                              :integer          not null, primary key
#  brand_id                        :integer
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  image_file_name                 :string
#  image_content_type              :string
#  image_file_size                 :integer
#  image_updated_at                :datetime
#  trademark_registration_number   :string
#  trademark_registration_location :string
#  trademark_registration_category :string
#  trademark_registration_url      :string
#
# Indexes
#
#  index_brand_logos_on_brand_id  (brand_id)
#

FactoryGirl.define do
  factory :brand_logo do
    brand nil
  end

end
