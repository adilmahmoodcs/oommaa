# == Schema Information
#
# Table name: keywords
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :keyword do
    name { Faker::Hipster.sentence(2) }
  end

end
