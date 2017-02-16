# == Schema Information
#
# Table name: facebook_posts
#
#  id                :integer          not null, primary key
#  facebook_id       :string           not null
#  message           :string           not null
#  posted_at         :datetime
#  permalink         :string
#  image_url         :string
#  status            :integer          default("0"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  facebook_page_id  :integer
#  status_changed_at :datetime
#  link              :string
#
# Indexes
#
#  index_facebook_posts_on_facebook_page_id  (facebook_page_id)
#

FactoryGirl.define do
  factory :facebook_post do
    facebook_id { Faker::Number.number(10) }
    message { Faker::Lorem.sentence }
    posted_at { Time.now }
    permalink { Faker::Internet.url }
    image_url { Faker::LoremPixel.image("150x150") }
    facebook_page
  end

end
