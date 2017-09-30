# == Schema Information
#
# Table name: employees
#
#  id         :integer          not null, primary key
#  name       :string
#  surname    :string
#  phone      :string
#  dob        :datetime
#  user_id    :integer
#  manager_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_employees_on_user_id  (user_id)
#

class Employee < ApplicationRecord
  belongs_to :user, required: false
  belongs_to :manager, class_name: "User"

  scope :of_manager, -> (manager) { where(manager_id: manager.id) }

  ransacker :name_case_insensitive, type: :string do
    arel_table[:name].lower
  end

  ransacker :surname_case_insensitive, type: :string do
    arel_table[:surname].lower
  end
end
