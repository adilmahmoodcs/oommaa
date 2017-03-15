# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  role                   :integer          default("0"), not null
#  licensor_id            :integer
#  name                   :string
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_licensor_id           (licensor_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  include PublicActivity::Common

  enum role: [:unconfirmed_client, :confirmed_client, :admin]

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable

  belongs_to :licensor, optional: true
  has_many :user_widgets

  validates :name, presence: true

  before_save :remove_licensor_for_admins

  def widgets
    user_widgets.order(:position).pluck(:widget_name).uniq
  end

  private

  def remove_licensor_for_admins
    self.licensor = nil if admin?
  end
end
