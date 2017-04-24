# == Schema Information
#
# Table name: facebook_posts
#
#  id                       :integer          not null, primary key
#  facebook_id              :string           not null
#  message                  :string           not null
#  published_at             :datetime
#  permalink                :string
#  image_url                :string
#  status                   :integer          default("0"), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  facebook_page_id         :integer
#  link                     :string
#  all_links                :string           default("{}"), is an Array
#  whitelisted_at           :datetime
#  whitelisted_by           :string
#  blacklisted_at           :datetime
#  blacklisted_by           :string
#  reported_to_facebook_at  :datetime
#  reported_to_facebook_by  :string
#  shut_down_by_facebook_at :datetime
#  all_domains              :string           default("{}"), is an Array
#  added_by                 :string
#  facebook_report_number   :string
#  likes                    :integer
#  mass_job_status          :integer          default("0")
#  greylisted_at            :datetime
#  greylisted_by            :string
#
# Indexes
#
#  index_facebook_posts_on_all_domains              (all_domains)
#  index_facebook_posts_on_all_links                (all_links)
#  index_facebook_posts_on_facebook_page_id         (facebook_page_id)
#  index_facebook_posts_on_status_and_published_at  (status,published_at)
#

FactoryGirl.define do
  factory :facebook_post do
    facebook_id { Faker::Number.number(10) }
    message { [Faker::Lorem.sentence, Faker::Internet.url, Faker::Lorem.sentence, Faker::Internet.url].join(" ")  }
    published_at { Time.now }
    permalink { Faker::Internet.url }
    image_url { Faker::LoremPixel.image("150x150") }
    facebook_page
    likes { Faker::Number.between(1, 10000) }

    factory :blacklisted_post do
      status "blacklisted"
      status_changed_at { Time.now }
    end
  end

end
