# == Schema Information
#
# Table name: user_widgets
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  widget_name :string           not null
#  position    :integer          default("0")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_user_widgets_on_user_id  (user_id)
#

class UserWidget < ApplicationRecord
  belongs_to :user
end
