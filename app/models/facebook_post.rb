# == Schema Information
#
# Table name: facebook_posts
#
#  id                :integer          not null, primary key
#  facebook_id       :string           not null
#  message           :string           not null
#  posted_at         :datetime
#  permalink         :string
#  image_url         :string
#  status            :integer          default("0"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  facebook_page_id  :integer
#  status_changed_at :datetime
#  link              :string
#  all_links         :string           default("{}"), is an Array
#
# Indexes
#
#  index_facebook_posts_on_all_links         (all_links)
#  index_facebook_posts_on_facebook_page_id  (facebook_page_id)
#

class FacebookPost < ApplicationRecord
  include PublicActivity::Common

  enum status: [:not_suspect, :suspect, :whitelisted, :blacklisted]

  belongs_to :facebook_page

  validates :facebook_id, :message, :facebook_page, presence: true
  validates :facebook_id, uniqueness: true

  def change_status_to!(new_status)
    self.status = new_status
    self.status_changed_at = Time.now
    set_all_links if blacklisted? # TODO should be better async?
    save!
  end

  def raw_links
    raw_links = URI.extract(message)
    raw_links << link if link.present?
    raw_links.delete_if { |l| l.match?(/https\:\/\/www\.facebook\.com\//) }
  end

  def set_all_links
    self.all_links = LinksParser.new(raw_links).call
  end
end
