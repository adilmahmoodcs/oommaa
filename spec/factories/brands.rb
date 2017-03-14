# == Schema Information
#
# Table name: brands
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  licensor_id :integer
#  nicknames   :string           default("{}"), is an Array
#
# Indexes
#
#  index_brands_on_licensor_id  (licensor_id)
#  index_brands_on_nicknames    (nicknames)
#

FactoryGirl.define do
  factory :brand do
    name { Faker::Team.name }
    nicknames []
  end
end
