# == Schema Information
#
# Table name: assigned_domains
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  domain_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_assigned_domains_on_domain_id  (domain_id)
#  index_assigned_domains_on_user_id    (user_id)
#

class AssignedDomain < ApplicationRecord
  belongs_to :user
  belongs_to :domain

  validates :user, :domain, presence: true
  validates_uniqueness_of :domain, scope: [:user]
  validate :validate_user

  def validate_user
    errors.add(:error, "Cannot Assign to Admin User") if User.find(self.user_id).admin?
  end
end
