# == Schema Information
#
# Table name: employee_quits
#
#  id               :integer          not null, primary key
#  employee_id      :integer
#  start_date       :datetime
#  end_date         :datetime
#  pc               :string
#  phone_no         :string
#  training_cancel  :integer
#  health_insurance :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_employee_quits_on_employee_id  (employee_id)
#

FactoryGirl.define do
  factory :employee_quit do
    employee nil
start_date "2017-10-02 08:59:46"
end_date ""
pc "MyString"
phone_no "MyString"
training_cancel 1
health_insurance "MyString"
  end

end
