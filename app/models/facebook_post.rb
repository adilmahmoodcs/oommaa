# == Schema Information
#
# Table name: facebook_posts
#
#  id          :integer          not null, primary key
#  facebook_id :string           not null
#  message     :string           not null
#  posted_at   :datetime
#  permalink   :string
#  image_url   :string
#  status      :integer          default("0"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class FacebookPost < ApplicationRecord
  enum status: [:not_suspect, :suspect, :whitelisted, :blacklisted]

  validates :facebook_id, :message, presence: true
  validates :facebook_id, uniqueness: true
end
