# == Schema Information
#
# Table name: facebook_posts
#
#  id               :integer          not null, primary key
#  facebook_id      :string           not null
#  message          :string           not null
#  posted_at        :datetime
#  permalink        :string
#  image_url        :string
#  status           :integer          default("0"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  facebook_page_id :integer
#
# Indexes
#
#  index_facebook_posts_on_facebook_page_id  (facebook_page_id)
#

class FacebookPost < ApplicationRecord
  include PublicActivity::Common

  enum status: [:not_suspect, :suspect, :whitelisted, :blacklisted]

  belongs_to :facebook_page

  validates :facebook_id, :message, :facebook_page, presence: true
  validates :facebook_id, uniqueness: true
end
