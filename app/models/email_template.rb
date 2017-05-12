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

class EmailTemplate < ApplicationRecord
  belongs_to :parent, polymorphic: true

  has_many :sent_emails, dependent: :destroy

  accepts_nested_attributes_for :sent_emails, allow_destroy: true, reject_if: :all_blank

end
