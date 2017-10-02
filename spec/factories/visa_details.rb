# == Schema Information
#
# Table name: visa_details
#
#  id          :integer          not null, primary key
#  employee_id :integer
#  visa_id     :string
#  name        :string
#  issue       :datetime
#  finish      :datetime
#  completed   :datetime
#  notes       :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_visa_details_on_employee_id  (employee_id)
#

FactoryGirl.define do
  factory :visa_detail do
    employee nil
visa_id "MyString"
name "MyString"
issue "2017-10-02 08:45:21"
finish "2017-10-02 08:45:21"
completed "2017-10-02 08:45:21"
notes "MyText"
  end

end
