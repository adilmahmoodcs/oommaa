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
	has_many :user_roles
  has_many :users, through: :user_roles

  DEFAULT_ROLE_NAMES = ['admin', 'manager', 'hr', 'employee']
  
  validates :name, presence: true

  class << self
	  DEFAULT_ROLE_NAMES.each do |role_name|
		  define_method(role_name) do
		    where(name: role_name).first
		  end
		end
	end

end
