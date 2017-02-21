# == Schema Information
#
# Table name: brands
#
#  id                :integer          not null, primary key
#  name              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  logo_file_name    :string
#  logo_content_type :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#  licensor_id       :integer
#
# Indexes
#
#  index_brands_on_licensor_id  (licensor_id)
#

FactoryGirl.define do
  factory :brand do
    name { Faker::Team.name }
  end
end
