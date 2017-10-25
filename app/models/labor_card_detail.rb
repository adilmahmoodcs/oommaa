# == Schema Information
#
# Table name: labor_card_details
#
#  id            :integer          not null, primary key
#  employee_id   :integer
#  labor_card_id :string
#  name          :string
#  issue         :datetime
#  finish        :datetime
#  completed     :datetime
#  notes         :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_labor_card_details_on_employee_id  (employee_id)
#

class LaborCardDetail < ApplicationRecord

  belongs_to :employee, optional: :true

  validates :name, presence: true
  validates :labor_card_id, presence: true

  REPORT_MODEL_NAME = "Labor Card"
  REPORT_FIELDS = {
    labor_card_id: "ID",
    name: "Name",
    issue: "Issue Date",
    finish: "Finish Date",
    completed: "Completed Date",
    notes: "Notes"
  }

end
