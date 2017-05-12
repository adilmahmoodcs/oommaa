# == Schema Information
#
# Table name: email_templates
#
#  id          :integer          not null, primary key
#  text        :string           not null
#  parent_type :string
#  parent_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_email_templates_on_parent_type_and_parent_id  (parent_type,parent_id)
#

FactoryGirl.define do
  factory :email_template do

  end

end
