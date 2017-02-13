# == Schema Information
#
# Table name: facebook_pages
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  facebook_id :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class FacebookPage < ApplicationRecord
  validates :name, :facebook_id, presence: true
  validates :facebook_id, uniqueness: true
end
