# == Schema Information
#
# Table name: attachments
#
#  id          :integer          not null, primary key
#  employee_id :integer
#  file        :string
#  notes       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_attachments_on_employee_id  (employee_id)
#

class Attachment < ApplicationRecord
  belongs_to :employee
end
