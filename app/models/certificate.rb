# == Schema Information
#
# Table name: certificates
#
#  id              :integer          not null, primary key
#  employee_id     :integer
#  name            :string
#  provider        :string
#  confirmation    :boolean
#  completion_date :datetime
#  notes           :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_certificates_on_employee_id  (employee_id)
#

class Certificate < ApplicationRecord
  belongs_to :employee, optional: :true

  validates :name, presence: true
  REPORT_MODEL_NAME = "Certificates"
  REPORT_FIELDS = {
    name: "Name",
    provider: "Provider",
    completion_date: "Completion Date",
    notes: "Notes",
    confirmation: "confirmation"
  }

end
