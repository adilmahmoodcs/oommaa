# == Schema Information
#
# Table name: trainings
#
#  id           :integer          not null, primary key
#  employee_id  :integer
#  name         :string
#  location     :text
#  duration     :string
#  provider     :string
#  confirmation :boolean
#  start_date   :datetime
#  end_date     :datetime
#  notes        :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_trainings_on_employee_id  (employee_id)
#

FactoryGirl.define do
  factory :training do
    employee nil
name "MyString"
location "MyText"
duration "MyString"
provider "MyString"
confirmation false
start_date "2017-10-02 08:52:22"
end_date "2017-10-02 08:52:22"
notes "MyText"
  end

end
