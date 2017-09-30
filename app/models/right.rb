# == Schema Information
#
# Table name: rights
#
#  id         :integer          not null, primary key
#  key        :string
#  name       :string
#  category   :string
#  controller :string
#  actions    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Right < ApplicationRecord

  has_many :role_rights
  has_many :rights, through: :role_rights

  validates :name, presence: true
  validates :name, :uniqueness => {:case_sensitive => false}

  validates :key, presence: true
  validates :key, :uniqueness => {:case_sensitive => false}

  ransacker :name_case_insensitive, type: :string do
    arel_table[:name].lower
  end


  def self.seed
    rows = YAML.load(File.read("#{Rails.root}/config/rights.yml"))
    rows['oommaa_users']['rights'].each do |category, items|
      items.each do |key, data|
        r = Right.find_or_create_by(key: key)
        r.name = data['name']
        r.controller = data['controller']
        r.actions = data['actions']
        r.category = category
        r.save
      end
    end
  end
end
