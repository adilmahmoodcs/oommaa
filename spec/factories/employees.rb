# == Schema Information
#
# Table name: employees
#
#  id         :integer          not null, primary key
#  name       :string
#  surname    :string
#  phone      :string
#  dob        :datetime
#  user_id    :integer
#  manager_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_employees_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :employee do
    name "MyString"
surname "MyString"
phone "MyString"
dob "2017-10-01 03:45:14"
user nil
magager_id 1
  end

end
