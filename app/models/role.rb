# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ApplicationRecord
  include PublicActivity::Common

  DEFAULT_ROLE_NAMES = ['admin', 'hr', 'manager', 'employee']

	has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  has_many :role_rights, dependent: :destroy
  has_many :rights, through: :role_rights

  validates :name, presence: true
  validates :name, :uniqueness => {:case_sensitive => false}

  ransacker :name_case_insensitive, type: :string do
    arel_table[:name].lower
  end

  def has_right? right
    right_ids.include? right.id
  end

  def rights
    @rights ||= Right.where(id: right_ids)
  end

  def right_ids
    @right_ids ||= RoleRight.where(role_id: self.id).pluck(:right_id)
  end

  def right_names
    #return '<b>ALL RIGHTS</b>'.html_safe if rights.count == Right.count
    rights.empty? ? '' : rights.pluck(:name).join('<br>').html_safe
  end

  def has_user? user
    user_ids.include? user.id
  end

  def users
    @users ||= User.where(id: user_ids)
  end

  def user_ids
    @user_ids ||= UserRole.where(role_id: self.id).pluck(:user_id)
  end



  class << self
	  def seed
      DEFAULT_ROLE_NAMES.each do |role_name|
        Role.create(name: role_name)
      end
      assign_basic_rights_to_default_roles
    end

    def assign_basic_rights_to_default_roles
      find_each do |role|
        case role.name
        when 'admin'
          assign_rights_of_category(role, 'roles')
          assign_rights_of_category(role, 'users')
          assign_rights_of_category(role, 'all_employees')
          assign_rights_of_category(role, 'own_employee_record')
        when 'hr'
          assign_rights_of_category(role, 'all_employees')
          assign_rights_of_category(role, 'own_employee_record')
        when 'manager'
          RoleRight.create!(role_id: role.id, right_id: Right.find_by(key: 'view_all_employees').id)
          RoleRight.create!(role_id: role.id, right_id: Right.find_by(key: 'edit_managed_employees').id)
          RoleRight.create!(role_id: role.id, right_id: Right.find_by(key: 'get_report_all_employees').id)
          assign_rights_of_category(role, 'own_employee_record')
        when 'employee'
          assign_rights_of_category(role, 'own_employee_record')
        end

      end
    end

    def assign_rights_of_category role, category
      Right.where(category: category).each do |right|
        RoleRight.create!(role_id: role.id, right_id: right.id)
      end
    end

    DEFAULT_ROLE_NAMES.each do |role_name|
		  define_method(role_name) do
		    where(name: role_name).first
		  end
		end
	end

end
