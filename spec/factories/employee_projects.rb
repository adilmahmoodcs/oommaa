# == Schema Information
#
# Table name: employee_projects
#
#  id          :integer          not null, primary key
#  employee_id :integer
#  project_id  :integer
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
#  index_employee_projects_on_employee_id  (employee_id)
#

FactoryGirl.define do
  factory :employee_project do
    employee nil
project_id 1
name "MyString"
issue "2017-10-02 09:12:02"
finish "2017-10-02 09:12:02"
completed "2017-10-02 09:12:02"
notes "MyText"
  end

end
