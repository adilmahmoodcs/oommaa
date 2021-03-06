# == Schema Information
#
# Table name: sent_emails
#
#  id                :integer          not null, primary key
#  subject           :string
#  email             :string
#  cc_emails         :string           default("{}"), is an Array
#  body              :string
#  brand_id          :integer
#  brand_logo_id     :integer
#  domain_id         :integer
#  user_id           :integer
#  email_template_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_sent_emails_on_email_template_id  (email_template_id)
#  index_sent_emails_on_user_id            (user_id)
#

FactoryGirl.define do
  factory :sent_email do
    email {Faker::Internet.email}
    body {Faker::Lorem.paragraph}
    subject {Faker::Lorem.sentence(3)}
  end
end
