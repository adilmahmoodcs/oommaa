# == Schema Information
#
# Table name: educations
#
#  id             :integer          not null, primary key
#  employee_id    :integer
#  department     :string
#  degree         :string
#  institution    :string
#  thesis         :string
#  notes          :text
#  still_studying :string
#  entrance_date  :datetime
#  graduation     :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_educations_on_employee_id  (employee_id)
#

FactoryGirl.define do
  factory :education do
    employee nil
department "MyString"
degree "MyString"
institution "MyString"
thesis "MyString"
notes "MyText"
still_studying "MyString"
entrance_date "2017-10-02 09:18:46"
graduation "MyString"
  end

end
