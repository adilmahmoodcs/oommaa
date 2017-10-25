# == Schema Information
#
# Table name: labor_card_details
#
#  id            :integer          not null, primary key
#  employee_id   :integer
#  labor_card_id :string
#  name          :string
#  issue         :datetime
#  finish        :datetime
#  completed     :datetime
#  notes         :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_labor_card_details_on_employee_id  (employee_id)
#

FactoryGirl.define do
  factory :labor_card_detail do
    
  end

end
