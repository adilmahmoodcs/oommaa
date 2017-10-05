# == Schema Information
#
# Table name: trainings
#
#  id           :integer          not null, primary key
#  employee_id  :integer
#  name         :string
#  location     :text
#  duration     :string
#  provider     :string
#  confirmation :boolean
#  start_date   :datetime
#  end_date     :datetime
#  notes        :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_trainings_on_employee_id  (employee_id)
#

class Training < ApplicationRecord
  belongs_to :employee, optional: :true

  validates :name, presence: true

end
