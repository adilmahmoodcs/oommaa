# == Schema Information
#
# Table name: rights
#
#  id         :integer          not null, primary key
#  key        :string
#  name       :string
#  category   :string
#  controller :string
#  actions    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :right do
    key "MyString"
name "MyString"
category "MyString"
controller "MyString"
actions "MyString"
  end

end
