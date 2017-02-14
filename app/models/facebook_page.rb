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

  after_commit :start_posts_importer, on: :create

  private

  def start_posts_importer
    PostsImporterJob.perform_later(facebook_id)
  end
end
