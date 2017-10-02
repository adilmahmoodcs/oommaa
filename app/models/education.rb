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

class Education < ApplicationRecord
  belongs_to :employee
end
