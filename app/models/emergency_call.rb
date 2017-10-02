# == Schema Information
#
# Table name: emergency_calls
#
#  id           :integer          not null, primary key
#  employee_id  :integer
#  surname      :string
#  name         :string
#  relationship :string
#  phone_no     :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_emergency_calls_on_employee_id  (employee_id)
#

class EmergencyCall < ApplicationRecord
  belongs_to :employee
end
