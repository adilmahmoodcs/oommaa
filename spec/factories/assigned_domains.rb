# == Schema Information
#
# Table name: assigned_domains
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  domain_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_assigned_domains_on_domain_id  (domain_id)
#  index_assigned_domains_on_user_id    (user_id)
#
FactoryGirl.define do
  factory :assigned_domain, :class => 'AssignedDomains' do
    user_id { [create(:user).id] }
    domain_id { [create(:domain).id] }
  end

end
