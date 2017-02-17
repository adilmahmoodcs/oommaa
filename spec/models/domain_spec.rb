require 'rails_helper'

RSpec.describe Domain, type: :model do
  subject { Domain }
  let(:domain_name) { "badsite.com" }

  describe ".blacklist!" do
    it "adds a blacklisted domain" do
      Domain.blacklist!(domain_name)
      expect(Domain.first.name).to eq(domain_name)
    end

    it "doesn't add duplicates" do
      3.times { Domain.blacklist!(domain_name) }
      expect(Domain.count).to eq(1)
    end
  end
end
