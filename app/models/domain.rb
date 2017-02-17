# == Schema Information
#
# Table name: domains
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  status     :integer          default("0"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Domain < ApplicationRecord
  enum status: [:blacklisted]
end
