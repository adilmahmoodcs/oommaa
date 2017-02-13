class FacebookPage < ApplicationRecord
  validates :name, :url, :facebook_id, presence: true
  validates :facebook_id, uniqueness: true
end
