# == Schema Information
#
# Table name: role_rights
#
#  id         :integer          not null, primary key
#  role_id    :integer
#  right_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_role_rights_on_right_id  (right_id)
#  index_role_rights_on_role_id   (role_id)
#

FactoryGirl.define do
  factory :role_right do
    role nil
right nil
  end

end
