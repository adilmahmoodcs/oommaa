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

class EmployeeQuit < ApplicationRecord
  belongs_to :employee

  REPORT_MODEL_NAME = "Quit"
end
