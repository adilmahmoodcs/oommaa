# == Schema Information
#
# Table name: brands
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Brand < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  after_commit :start_pages_importer, on: :create

  private

  def start_pages_importer
    PagesImporterJob.perform_later(self)
  end
end
