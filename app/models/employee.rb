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

  has_one :visa_detail, dependent: :destroy
  has_one :labor_card_detail, dependent: :destroy
  has_one :passport_detail, dependent: :destroy
  has_one :employee_quit

  has_many :trainings, dependent: :destroy
  has_many :certificates, dependent: :destroy
  has_many :employee_projects, dependent: :destroy
  has_many :technical_skills, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :languages, dependent: :destroy
  REPORT_MODEL_NAME = ""
  REPORT_FIELDS = {
    name: "Name",
    phone: "Phone#",
    dob: "Date of Birth"
  }

  accepts_nested_attributes_for :visa_detail, :reject_if => lambda { |a| a[:name].blank? || a[:visa_id].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :passport_detail, :reject_if => lambda { |a| a[:name].blank? || a[:passport_no].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :labor_card_detail, :reject_if => lambda { |a| a[:name].blank? || a[:labor_card_id].blank? }, :allow_destroy => true

  accepts_nested_attributes_for :trainings, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :certificates, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :employee_projects, :reject_if => lambda { |a| a[:name].blank? || a[:project_id].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :technical_skills, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :educations, :reject_if => lambda { |a| a[:degree].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :languages, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true

  validates :name, presence: true
  validates :name, :uniqueness => {:case_sensitive => false}


  scope :of_manager, -> (manager) { where(manager_id: manager.id) }
  scope :active, -> () { where.not(user_id: nil) }

  ransacker :name_case_insensitive, type: :string do
    arel_table[:name].lower
  end

  ransacker :surname_case_insensitive, type: :string do
    arel_table[:surname].lower
  end

  def full_name
    [self.name, self.surname].join(' ')
  end
end
