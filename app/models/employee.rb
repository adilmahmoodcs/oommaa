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
  include PublicActivity::Common

  belongs_to :user, required: false
  belongs_to :manager, class_name: "User", required: false

  has_one :visa_detail
  has_one :labor_card_detail
  has_one :passport_detail
  has_one :employee_quit

  has_many :trainings
  has_many :certificates
  has_many :employee_projects
  has_many :technical_skills
  has_many :educations
  has_many :languages

  scope :of_manager, -> (manager) { where(manager_id: manager.id) }

  ransacker :name_case_insensitive, type: :string do
    arel_table[:name].lower
  end

  ransacker :surname_case_insensitive, type: :string do
    arel_table[:surname].lower
  end
end
