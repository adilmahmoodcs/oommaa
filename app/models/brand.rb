# == Schema Information
#
# Table name: brands
#
#  id                :integer          not null, primary key
#  name              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  logo_file_name    :string
#  logo_content_type :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#  licensor_id       :integer
#
# Indexes
#
#  index_brands_on_licensor_id  (licensor_id)
#

class Brand < ApplicationRecord
  include PublicActivity::Common

  belongs_to :licensor, optional: true

  validates :name, presence: true
  validates :name, uniqueness: true

  after_commit :start_pages_importer, on: :create

  has_attached_file :logo,
                    styles: { thumb: "100x100>" },
                    default_url: "/images/missing.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

  def pages
    @pages ||= FacebookPage.where("? = ANY (brand_ids)", id)
  end

  private

  def start_pages_importer
    PagesImporterJob.perform_async(id)
  end
end
