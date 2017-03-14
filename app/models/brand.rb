# == Schema Information
#
# Table name: brands
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  licensor_id :integer
#  nicknames   :string           default("{}"), is an Array
#
# Indexes
#
#  index_brands_on_licensor_id  (licensor_id)
#  index_brands_on_nicknames    (nicknames)
#

class Brand < ApplicationRecord
  include PublicActivity::Common

  belongs_to :licensor, optional: true
  has_many :logos, class_name: "BrandLogo", dependent: :destroy
  has_many :facebook_page_brands
  has_many :facebook_pages, through: :facebook_page_brands

  validates :name, presence: true
  validates :name, uniqueness: true

  before_validation :remove_blank_values
  after_commit :start_pages_importer, on: :create
  after_commit :update_facebook_pages

  accepts_nested_attributes_for :logos, allow_destroy: true, reject_if: :all_blank

  scope :of_licensor, -> (licensor) { where(licensor_id: licensor.id) }

  ransacker :name_case_insensitive, type: :string do
    arel_table[:name].lower
  end

  def pages
    @pages ||= FacebookPage.where("? = ANY (brand_ids)", id)
  end

  def licensor_name
    licensor&.name
  end

  def logo
    logos.first || logos.new
  end

  private

  def start_pages_importer
    PagesImporterJob.perform_async(id)
  end

  def remove_blank_values
    nicknames.delete('')
  end

  def update_facebook_pages
    facebook_pages.find_each(&:save)
  end
end
