# == Schema Information
#
# Table name: licensors
#
#  id                :integer          not null, primary key
#  name              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  main_contact      :string
#  logo_file_name    :string
#  logo_content_type :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#

class Licensor < ApplicationRecord
  has_many :brands, dependent: :nullify
  has_many :email_templates, as: :parent, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true

  has_attached_file :logo,
                    styles: { thumb: "200x200>" },
                    default_url: "/images/missing.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

  accepts_nested_attributes_for :email_templates, allow_destroy: true, reject_if: :all_blank

  ransacker :name_case_insensitive, type: :string do
    arel_table[:name].lower
  end
end
