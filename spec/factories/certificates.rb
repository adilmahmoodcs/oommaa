# == Schema Information
#
# Table name: certificates
#
#  id              :integer          not null, primary key
#  employee_id     :integer
#  name            :string
#  provider        :string
#  confirmation    :boolean
#  completion_date :datetime
#  notes           :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_certificates_on_employee_id  (employee_id)
#

FactoryGirl.define do
  factory :certificate do
    employee nil
name "MyString"
provider "MyString"
confirmation false
completion_date "2017-10-02 08:54:09"
notes "MyText"
  end

end
