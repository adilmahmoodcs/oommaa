# == Schema Information
#
# Table name: facebook_pages
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  url         :string           not null
#  image_url   :string
#  facebook_id :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :facebook_page do
    name { "#{Faker::Team.name} fans" }
    url { Faker::Internet.url }
    image_url { Faker::LoremPixel.image("150x150") }
    facebook_id { Faker::Number.number(10) }
  end

end
