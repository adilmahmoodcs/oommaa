# == Schema Information
#
# Table name: facebook_pages
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  url         :string           not null
#  image_url   :string
#  facebook_id :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  brand_ids   :integer          default("{}"), is an Array
#
# Indexes
#
#  index_facebook_pages_on_brand_ids  (brand_ids)
#

class FacebookPage < ApplicationRecord
  has_many :facebook_posts, dependent: :destroy

  validates :name, :url, :facebook_id, presence: true
  validates :facebook_id, uniqueness: true

  after_commit :start_posts_importer, on: :create

  def brands
    @brands ||= Brand.where(id: brand_ids)
  end

  private

  def start_posts_importer
    PostsImporterJob.perform_async(id)
  end
end
