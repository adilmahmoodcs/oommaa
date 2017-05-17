# == Schema Information
#
# Table name: email_templates
#
#  id              :integer          not null, primary key
#  text            :string
#  default_subject :string
#  template_type   :integer
#  parent_type     :string
#  parent_id       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_email_templates_on_parent_type_and_parent_id  (parent_type,parent_id)
#

FactoryGirl.define do
  factory :email_template do
    text {Faker::Lorem.paragraph}
    default_subject {Faker::Lorem.sentence(3)}
    association :parent, :factory => :licensor
  end

end
