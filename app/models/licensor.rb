# == Schema Information
#
# Table name: licensors
#
#  id                        :integer          not null, primary key
#  name                      :string           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  main_contact              :string
#  logo_file_name            :string
#  logo_content_type         :string
#  logo_file_size            :integer
#  logo_updated_at           :datetime
#  cease_and_desist_template :string
#  cease_and_desist_subject  :string
#

class Licensor < ApplicationRecord
  has_many :brands, dependent: :nullify

  validates :name, presence: true
  validates :name, uniqueness: true

  has_attached_file :logo,
                    styles: { thumb: "200x200>" },
                    default_url: "/images/missing.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

  ransacker :name_case_insensitive, type: :string do
    arel_table[:name].lower
  end
end
