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

class LabourCardDetail < ApplicationRecord
  belongs_to :employee
end
