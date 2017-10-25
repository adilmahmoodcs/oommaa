# == Schema Information
#
# Table name: languages
#
#  id              :integer          not null, primary key
#  employee_id     :integer
#  name            :string
#  written_level   :string
#  speaking_level  :string
#  native_language :boolean
#  notes           :text
#  confirmation    :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_languages_on_employee_id  (employee_id)
#

class Language < ApplicationRecord
  belongs_to :employee, optional: :true

  validates :name, presence: true
  REPORT_MODEL_NAME = "Languages"
  REPORT_FIELDS = {
    name: "Name",
    written_level: "Written Level",
    speaking_level: "Speaking Level",
    native_language: "Native",
    notes: "Notes",
    confirmation: "Confirmation"
  }
end
