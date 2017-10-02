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

class VisaDetail < ApplicationRecord
  belongs_to :employee
end