# == Schema Information
#
# Table name: screenshots
#
#  id                 :integer          not null, primary key
#  facebook_post_id   :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  type               :string
#
# Indexes
#
#  index_screenshots_on_facebook_post_id  (facebook_post_id)
#

class Screenshot < ApplicationRecord
  belongs_to :facebook_post

  has_attached_file :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
