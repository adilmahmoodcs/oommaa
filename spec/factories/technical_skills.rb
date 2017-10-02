# == Schema Information
#
# Table name: technical_skills
#
#  id           :integer          not null, primary key
#  employee_id  :integer
#  level        :string
#  level_id     :integer
#  confirmation :boolean
#  name         :string
#  notes        :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_technical_skills_on_employee_id  (employee_id)
#

FactoryGirl.define do
  factory :technical_skill do
    employee nil
level "MyString"
level_id 1
confirmation false
name "MyString"
notes "MyText"
  end

end
