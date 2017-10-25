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
  belongs_to :employee, optional: :true

  validates :degree, presence: true
  REPORT_MODEL_NAME = "Educations"
  REPORT_FIELDS = {
    degree: "Degree",
    department: "Department",
    institution: "Institute",
    thesis: "Thesis",
    still_studying: "Still Studying",
    entrance_date: "Entrance Date",
    graduation: "Graduation",
    notes: "Notes"
  }
end
