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

class EmployeeProject < ApplicationRecord
    belongs_to :employee, optional: :true

  validates :name, presence: true
  validates :project_id, presence: true
  REPORT_MODEL_NAME = "Projects"
  REPORT_FIELDS = {
    project_id: "ID",
    name: "Name",
    issue: "Issue Date",
    finish: "Finish Date",
    provider: "Provider",
    completed: "Completed Date",
    notes: "Notes"
  }

  default_scope { order('id ASC') }


end
