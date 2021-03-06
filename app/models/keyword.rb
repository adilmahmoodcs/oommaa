# == Schema Information
#
# Table name: keywords
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Keyword < ApplicationRecord
  include PublicActivity::Common

  validates :name, presence: true
  validates :name, :uniqueness => {:case_sensitive => false}


  ransacker :name_case_insensitive, type: :string do
    arel_table[:name].lower
  end
end
