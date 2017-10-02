# == Schema Information
#
# Table name: labour_card_details
#
#  id             :integer          not null, primary key
#  employee_id    :integer
#  labour_card_id :string
#  name           :string
#  issue          :datetime
#  finish         :datetime
#  completed      :datetime
#  notes          :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_labour_card_details_on_employee_id  (employee_id)
#

FactoryGirl.define do
  factory :labour_card_detail do
    employee nil
labour_card_id "MyString"
name "MyString"
issue "2017-10-02 08:46:28"
finish "2017-10-02 08:46:28"
completed "2017-10-02 08:46:28"
notes "MyText"
  end

end
