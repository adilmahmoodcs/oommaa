# == Schema Information
#
# Table name: facebook_posts
#
#  id          :integer          not null, primary key
#  facebook_id :string           not null
#  message     :string           not null
#  posted_at   :datetime
#  permalink   :string
#  image_url   :string
#  status      :integer          default("0"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :facebook_post do
    facebook_id "MyString"
message "MyString"
posted_at "2017-02-13 17:42:34"
permalink "MyString"
image_url "MyString"
status 1
  end

end
