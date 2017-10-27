# == Schema Information
#
# Table name: technical_skills
#
#  id           :integer          not null, primary key
#  employee_id  :integer
#  level        :string
#  level_id     :integer
#  confirmation :boolean
#  name         :string
#  notes        :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_technical_skills_on_employee_id  (employee_id)
#

class TechnicalSkill < ApplicationRecord
  belongs_to :employee, optional: :true

  validates :name, presence: true
  REPORT_MODEL_NAME = "Technical Skills"
  REPORT_FIELDS = {
    name: "Name",
    level: "Level",
    level_id: "Level ID",
    notes: "Notes",
    confirmation: "confirmation"
  }

  default_scope { order('id ASC') }

end
