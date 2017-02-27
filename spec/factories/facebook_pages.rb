# == Schema Information
#
# Table name: facebook_pages
#
#  id                       :integer          not null, primary key
#  name                     :string           not null
#  url                      :string           not null
#  image_url                :string
#  facebook_id              :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  brand_ids                :integer          default("{}"), is an Array
#  shut_down_by_facebook_at :datetime
#
# Indexes
#
#  index_facebook_pages_on_brand_ids  (brand_ids)
#

FactoryGirl.define do
  factory :facebook_page do
    name { "#{Faker::Team.name} fans" }
    url { Faker::Internet.url }
    image_url { Faker::LoremPixel.image("150x150") }
    facebook_id { Faker::Number.number(10) }
    brand_ids { [create(:brand).id] }
  end

end
