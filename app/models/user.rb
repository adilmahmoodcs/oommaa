# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  role                   :integer          default("0"), not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_licensor_id           (licensor_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_widgets               (widgets)
#

class User < ApplicationRecord
  include PublicActivity::Common

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable

  attr_accessor :employee_id

  # after_initialize :set_default_role, :if => :new_record?

  validates :email, presence: true
  validates :email, :uniqueness => {:case_sensitive => false}


  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  has_one :employee, dependent: :nullify
  has_many :subordinates, class_name: "Employee",
                          foreign_key: "manager_id", dependent: :nullify

  validates :name, presence: true

  scope :with_manager_rights, -> () { joins(:roles).where(roles: {name: 'manager'}).order(:name) }

  def set_default_role
    self.roles << Role.employee
  end

  Role::DEFAULT_ROLE_NAMES.each do |role_name|
    define_method("#{role_name}?") do
      self.roles.send(role_name).present?
    end
  end

  def rights
    Right.joins(:role_rights).where('role_rights.role_id IN (?)', self.role_ids).distinct
  end

  def rights_keys
    rights.pluck(:key)
  end

  def has_right? right_key
    rights_keys.include? right_key.to_s
  end

  def display_name
    self.name || self.email.split('@').try(:first)
  end

  def employee_id
    self.employee&.id
  end

end
