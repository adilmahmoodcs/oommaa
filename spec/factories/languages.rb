# == Schema Information
#
# Table name: languages
#
#  id              :integer          not null, primary key
#  employee_id     :integer
#  name            :string
#  written_level   :string
#  speaking_level  :string
#  native_language :boolean
#  notes           :text
#  confirmation    :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_languages_on_employee_id  (employee_id)
#

FactoryGirl.define do
  factory :language do
    employee nil
name "MyString"
written_level "MyString"
speaking_level "MyString"
native_language false
notes "MyText"
confirmation false
  end

end
