# == Schema Information
#
# Table name: facebook_pages
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  url         :string           not null
#  description :text
#  image_url   :string
#  facebook_id :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :facebook_page do
    name "MyString"
    url "MyString"
    description "MyText"
    image_url "MyString"
    facebook_id "MyString"
  end

end
