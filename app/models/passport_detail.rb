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

class PassportDetail < ApplicationRecord
  belongs_to :employee
end
