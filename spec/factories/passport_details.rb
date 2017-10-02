# == Schema Information
#
# Table name: passport_details
#
#  id          :integer          not null, primary key
#  employee_id :integer
#  passport_no :string
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
#  index_passport_details_on_employee_id  (employee_id)
#

FactoryGirl.define do
  factory :passport_detail do
    employee nil
passport_no "MyString"
name "MyString"
issue "2017-10-02 09:09:16"
finish "2017-10-02 09:09:16"
completed "2017-10-02 09:09:16"
notes "MyText"
  end

end
