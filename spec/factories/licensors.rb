# == Schema Information
#
# Table name: licensors
#
#  id                :integer          not null, primary key
#  name              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  main_contact      :string
#  logo_file_name    :string
#  logo_content_type :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#

FactoryGirl.define do
  factory :licensor do
    name { Faker::Company.name }
  end

end
